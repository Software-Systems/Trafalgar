codeunit 50101 "Extention for Sales Subscriber"
{
    local procedure CheckForPlannedProductionOrders(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        ProductionOrder: Record "Production Order";
        NotAllowedErr: Label 'There are Make to Order items on this sale, that have not been planned, please plan them, and release again (This order has not released).';
        CCDetailsErr: Label 'Cannot release! The Credit Card information is not updated.';
        SalesPayments: Record "Sales Payments";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                Item.Get(SalesLine."No.");
                if Item."Manufacturing Policy" = Item."Manufacturing Policy"::"Make-to-Order" then begin
                    ProductionOrder.SetRange("Sales Order No.", SalesLine."Document No.");
                    ProductionOrder.SetRange("Sales Order Line No.", SalesLine."Line No.");
                    // ProductionOrder.SetRange(Status, ProductionOrder.Status::Planned);
                    if ProductionOrder.IsEmpty then
                        Message(NotAllowedErr);
                end;
            until SalesLine.Next() = 0;
        /*
        Fanie's request to disable this error message on 07th April 2025 (Trafalgar Tasks 07/04/2025)

        if SalesHeader."Payment Terms Code" = 'CIA' then
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                //New One
                SalesPayments.Reset;
                SalesPayments.Setrange(SalesPayments."Document Type", SalesHeader."Document Type");
                SalesPayments.Setrange(SalesPayments."Document No.", SalesHeader."No.");
                if SalesPayments.FindSet() then
                    repeat
                        if (SalesPayments."Machine" = '') or (SalesPayments."Processed By" = '')
                        or (SalesPayments."Payment Date" = 0D) or (SalesPayments."Card Type" = SalesPayments."Card Type"::" ") then
                            Error(CCDetailsErr);
                    until SalesPayments.Next() = 0;

                //Old One
                if (SalesHeader."CC Machine" = '') or (SalesHeader."CC Processed By" = '')
                or (SalesHeader."CC Payment Date" = 0D) or (SalesHeader."CC Card Type" = '') then
                    Error(CCDetailsErr);
            end;        
        */
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", OnBeforeModifySalesOrderHeader, '', false, false)]
    procedure SalesQuoteToOrder_OnBeforeModifySalesOrderHeader(SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    begin
        SalesQuoteHeader.CheckTrafalgarMandatoryFields();
        if SalesQuoteHeader."Shipment Date" < Today then begin
            if Confirm('Do you want to update the Shipment Date ?') then
                SalesOrderHeader."Shipment Date" := TODAY;
        end;

        if SalesQuoteHeader."Requested Delivery Date" < Today then begin
            if Confirm('Do you want to update the Delivery Date ?') then
                SalesOrderHeader."Requested Delivery Date" := TODAY;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Invoice", OnBeforeInsertSalesInvoiceHeader, '', false, false)]
    procedure SalesQuotetoInvoice_OnBeforeInsertSalesInvoiceHeader(QuoteSalesHeader: Record "Sales Header")
    begin
        QuoteSalesHeader.CheckTrafalgarMandatoryFields();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    procedure SalesPost_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesHeader.CheckTrafalgarMandatoryFields();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Mgt.", OnAfterCalculateShipBillToOptions, '', false, false)]
    procedure CustomerMgt_OnAfterCalculateShipBillToOptions(var ShipToOptions: Enum "Sales Ship-to Options")
    begin
        ShipToOptions := ShipToOptions::"Custom Address";
    end;

    local procedure UpdateWarehouseLocation(var SalesHeader: Record "Sales Header"; var xSalesHeader: Record "Sales Header")
    var
        PostCode: Record "Post Code";
        salesLine: Record "Sales Line";
        County: Record County;
        ConfirmationMgmnt: Codeunit "Confirm Management";
        ConfirmDialog: Label 'Do you want to change the Warehouse location to %1?', Comment = '1% = Location.Code';
    begin
        if SalesHeader."Ship-to Post Code" <> xSalesHeader."Ship-to Post Code" then begin
            PostCode.SetRange(Code, SalesHeader."Ship-to Post Code");
            if PostCode.FindFirst() then begin
                County.SetRange(County.name, PostCode.County);
                if County.FindFirst() then
                    if ConfirmationMgmnt.GetResponse(StrSubstNo(ConfirmDialog, County."Shipping Location")) then begin
                        SalesHeader.Validate("Location Code", County."Shipping Location");
                        salesLine.SetRange("Document No.", SalesHeader."No.");
                        salesLine.SetRange(Type, salesLine.Type::Item);
                        if salesLine.FindSet() then
                            repeat
                                salesLine.Validate("Location Code", County."Shipping Location");
                                salesLine.Modify(false);
                            until salesLine.Next() = 0;
                    end
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", 'OnCreateProdOrderOnAfterProdOrderInsert', '', false, false)]
    local procedure OnCreateProdOrderOnAfterProdOrderInsert(var ProductionOrder: Record "Production Order"; SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        SalesLine2: Record "Sales Line";
    begin
        ProductionOrder."Sales Order No." := SalesLine."Document No.";
        ProductionOrder."Sales Order Line No." := SalesLine."Line No.";
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", SalesLine."Document No.");
        if SalesHeader.FindFirst() then begin
            ProductionOrder."Customer Name" := SalesHeader."Sell-to Customer Name";
            ProductionOrder."Order Release Date" := SalesHeader.SystemModifiedAt;
        end;
        // If SalesLine2.get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then begin
        //     SalesLine2."Production Order No." := ProductionOrder."No.";
        //     If ProductionOrder.Status = ProductionOrder.Status::Planned then
        //         SalesLine2."Production Order Status" := SalesLine2."Production Order Status"::"1 Prod Planned"
        //     else
        //         if ProductionOrder.Status = ProductionOrder.Status::Released then
        //             SalesLine2."Production Order Status" := SalesLine2."Production Order Status"::"2 Prod Released"
        //         else
        //             if ProductionOrder.Status = ProductionOrder.Status::Finished then
        //                 SalesLine2."Production Order Status" := SalesLine2."Production Order Status"::"3 Prod Completed";

        //     SalesLine2.Modify(true);
        // end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnAfterConfirmPost, '', true, true)]
    local procedure SalesPostYesNo_OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
    var
        ConfirmManagement: Codeunit "Confirm Management";
        SalesLine: Record "Sales Line";
        QuestionLbl: Label 'Do you want to Update the Posting, Shipment & Document Date to today?';
    begin
        if ConfirmManagement.GetResponse(QuestionLbl, false) then begin
            SalesHeader."Posting Date" := Today;
            SalesHeader."Shipment Date" := Today;
            SalesHeader.Validate("Document Date", Today);
            SalesHeader."VAT Reporting Date" := Today;
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindSet() then
                repeat
                    SalesLine."Shipment Date" := SalesHeader."Shipment Date";
                    SalesLine.Modify(false);
                until SalesLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforePerformManualReleaseProcedure, '', true, true)]
    local procedure OnBeforePerformManualReleaseProcedure(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        UserSetup: Record "User Setup";
        DocumentTotal: Codeunit "Document Totals";
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPCT: Decimal;
        VATAMount: Decimal;
        NotAllowedtoRelease: Label 'This order cannot be released until the Total Amount has been paid.';
        //SG Start
        ExceededOverdueEntries: Label 'This Customer Has Overdue Entries, Or Is Over Their Credit Limit. This Order Cannot Be Released';
        ConfirmationOverdueEntries: Label 'This Customer Has Overdue Entries, Or Is Over Their Credit Limit. Do You Still Want to Release This Order ?';
        Customer: Record Customer;
        OverDueBalance: Decimal;
    begin
        if UserSetup.Get(UserId) then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
                SalesHeader.CalcFields(SalesHeader.Amount, SalesHeader."Amount Including VAT");
                if not UserSetup."Can Always Release CIA orders" then begin
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    if SalesLine.FindSet() then
                        DocumentTotal.CalculateSalesSubPageTotals(SalesHeader, SalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
                    if (SalesHeader."Payment Terms Code" = 'CIA') then
                        if (SalesHeader.GetTotalSalesPaid() < SalesHeader."Amount Including VAT") then
                            Error(NotAllowedtoRelease);
                end;

                if Customer.Get(SalesHeader."Bill-to Customer No.") then
                    OverDueBalance := Customer.CalcOverdueBalance();

                if OverDueBalance > 0 then begin
                    if not UserSetup."Can Release Order for Overdue" then
                        if not Confirm('This customer has an overdue balance, do you want to continue?') then begin
                            Error(ExceededOverdueEntries);
                        end
                        else begin
                            //User Has Authority To Release
                            if Confirm(ConfirmationOverdueEntries) then begin
                                //Sales Order Released
                            end
                            else
                                Error('%1 Still Remains In Open Status.', SalesHeader."No.")
                        end;
                end;
            end;
        end;
        CheckForPlannedProductionOrders(SalesHeader, SalesLine);
    end;

    procedure SendEmailProforma(var SalesHeader: Record "Sales Header")
    var
        ReportSelections: Record "Report Selections";
        ReportUsage: Enum "Report Selection Usage";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeader.SetRange("No.", SalesHeader."No.");
        ReportUsage := ReportSelections.Usage::"Pro Forma S. Invoice";
        ReportSelections.SendEmailToCust(
                ReportUsage.AsInteger(), SalesHeader, SalesHeader."No.", SalesHeader.GetDocTypeTxt(), true, SalesHeader.GetBillToNo())
    end;

    //============================== CUSTOMER =============================================
    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeCheckBlockedCust, '', true, true)]
    local procedure Customer_OnBeforeCheckBlockedCust(Customer: Record Customer; Source: Option; var IsHandled: Boolean)
    begin
        if Source = 1 then
            if (Customer.Blocked = Customer.Blocked::Ship) or (Customer.Blocked = Customer.Blocked::" ") then
                IsHandled := true
            else
                IsHandled := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeGetCustNoOpenCard, '', true, true)]
    local procedure Customer_OnBeforeGetCustNoOpenCard(CustomerText: Text; var ShowCreateCustomerOption: Boolean; var IsHandled: Boolean; var CustomerNo: Code[20])
    var
        Customer: Record Customer;
        Found: Boolean;
        CustomerWithoutQuote: Text;
        CustomerFilterFromStart: Text;
        CustomerFilterContains: Text;
    begin
        if CustomerText = '' then
            exit;
        CustomerWithoutQuote := ConvertStr(CustomerText, '''', '?');
        Customer.SetFilter(Name, '''@' + CustomerWithoutQuote + '''');
        if Customer.FindFirst() then
            CustomerNo := Customer."No.";

        CustomerFilterFromStart := '''@' + CustomerWithoutQuote + '*''';
        Customer.Reset();
        Customer.FilterGroup := -1;
        Customer.SetFilter("No.", CustomerFilterFromStart);
        Customer.SetFilter(Name, CustomerFilterFromStart);
        if Customer.FindFirst() and (Customer.Count() = 1) then
            CustomerNo := Customer."No.";

        if CustomerNo = '' then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", OnAfterGetRecordEvent, '', true, true)]
    local procedure CustomerCard_OnAfterGetRecordEvent(var Rec: Record Customer)
    begin
        if Rec."Important Notes" <> '' then
            Message(Rec."Important Notes");
    end;

    //============================== SALES HEADER =============================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "No.", true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_No(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            Rec."Quote Valid Until Date" := CalcDate('+30D', Today)
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeDeleteEvent, '', true, true)]
    local procedure SalesHeader_OnBeforeDeleteEvent(var Rec: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SalesHeaderQuote: Record "Sales Header";
    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            if SalesHeaderQuote.Get(Rec."Document Type", Rec."No.") then begin
                ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeaderQuote);
                ApprovalsMgmt.DeleteApprovalEntries(SalesHeaderQuote.RecordId);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Payment Processed", false, false)]
    local procedure SalesHeader_OnAfterValidateEvent_PaymentProcessed(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if (not UserSetup."Can Reprocess Payment") or (not UserSetup."Can Always Release CIA orders") then
                Error('Cannot Modify the Payment Processed field, please contact the administrator!');
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterLookupShipToPostCode, '', true, true)]
    local procedure SalesHeader_OnAfterLookupShipToPostCode(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    begin
        UpdateWarehouseLocation(SalesHeader, xSalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateBillToCustomerNoOnBeforeCheckBlockedCustOnDocs, '', true, true)]
    local procedure SalesHeader_OnValidateBillToCustomerNoOnBeforeCheckBlockedCustOnDocs(var Cust: Record Customer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) or
        (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) then begin
            if (Cust.Blocked = Cust.Blocked::Ship) or (Cust.Blocked = Cust.Blocked::" ") then
                IsHandled := true
            else
                IsHandled := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterOnInsert, '', true, true)]
    local procedure SalesHeader_OnAfterOnInsert(var SalesHeader: Record "Sales Header")
    var
        PostCode: Record "Post Code";
        salesLine: Record "Sales Line";
        County: Record County;
        ConfirmationMgmnt: Codeunit "Confirm Management";
        ConfirmDialog: Label 'Do you want to change the Warehouse location to %1?', Comment = '1% = Location.Code';
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then begin
            SalesHeader."Quote Valid Until Date" := CalcDate('+30D', Today)
        end;
        if SalesHeader."Sell-to Customer No." <> '' then begin
            PostCode.SetRange(Code, SalesHeader."Ship-to Post Code");
            if PostCode.FindFirst() then begin
                County.SetRange(County.name, PostCode.County);
                if County.FindFirst() then begin
                    //if ConfirmationMgmnt.GetResponse(StrSubstNo(ConfirmDialog, County."Shipping Location")) then begin
                    SalesHeader.Validate("Location Code", County."Shipping Location");
                    salesLine.SetRange("Document No.", SalesHeader."No.");
                    salesLine.SetRange(Type, salesLine.Type::Item);
                    if salesLine.FindSet() then
                        repeat
                            salesLine.Validate("Location Code", County."Shipping Location");
                            salesLine.Modify(false);
                        until salesLine.Next() = 0;
                end;
                //end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs, '', true, true)]
    local procedure SalesHeader_OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs(var Cust: Record Customer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) or
        (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) then begin
            if Cust.Blocked = Cust.Blocked::Ship then
                IsHandled := true
            else
                IsHandled := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification, '', true, true)]
    local procedure SalesHeader_OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        PostCode: Record "Post Code";
        salesLine: Record "Sales Line";
        County: Record County;
    begin
        //UpdateWarehouseLocation(SalesHeader, xSalesHeader);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader."Requested Delivery Date" := today;
        end;

        if SalesHeader."Sell-to Customer No." <> '' then begin
            PostCode.SetRange(Code, SalesHeader."Ship-to Post Code");
            if PostCode.FindFirst() then begin
                County.SetRange(County.name, PostCode.County);
                if County.FindFirst() then begin
                    SalesHeader.Validate("Location Code", County."Shipping Location");
                    salesLine.SetRange("Document No.", SalesHeader."No.");
                    salesLine.SetRange(Type, salesLine.Type::Item);
                    if salesLine.FindSet() then
                        repeat
                            salesLine.Validate("Location Code", County."Shipping Location");
                            salesLine.Modify(false);
                        until salesLine.Next() = 0;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr, '', true, true)]
    local procedure SalesHeader_OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    begin
        UpdateWarehouseLocation(SalesHeader, xSalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_SellToCustomerNo(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Sell-to Customer No.") then
            if Customer."Important Notes" <> '' then
                Message(Customer."Important Notes");

        if Rec."Document Type" = Rec."Document Type"::Quote then
            Rec."Quote Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInsertEvent, '', false, false)]
    local procedure SalesHeader_OnAfterInsertEvent(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            Rec."Quote Valid Until Date" := CalcDate('+30D', Today)
        end;
    end;
    //============================== SALES LINE =============================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "No.", true, true)]
    local procedure SalesLine_OnAfterValidateEvent_No(var Rec: Record "Sales Line")
    var
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
    begin
        if Rec.Type = Rec.Type::Item then
            if Item.Get(Rec."No.") then begin
                if Item."User Prompt" <> '' then
                    Message(Item."User Prompt");

                if Item."Manufacturing Policy" = Item."Manufacturing Policy"::"Make-to-Order" then begin
                    GLSetup.Get;
                    if GLSetup."Location For Make To Order" <> '' then
                        Rec.Validate(Rec."Location Code", GLSetup."Location For Make To Order");
                end;

                Rec."Product Code" := Item."Product Code";
                if Item."Product Code" = 'DELIVERY' then begin
                    Rec.Validate(Quantity, 1);
                    Rec.Validate("Qty. to Ship", 1);
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line Discount", OnBeforeValidateEvent, "Line Discount %", true, true)]
    local procedure SalesLineDiscount_OnBeforeValidateEvent_LineDiscountPct(var Rec: Record "Sales Line Discount")
    var
        TrafalgarGeneralCodeunit: Codeunit "Trafalgar General Codeunit";
    begin
        if Rec."Sales Type" = Rec."Sales Type"::"All Customers" then
            if TrafalgarGeneralCodeunit.CheckUserCanApplyGenericDiscount() = false then
                Error('You do not have permission to create system wide discounts, please chat to Kate');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateLineDiscountPercentOnAfterTestStatusOpen, '', true, true)]
    local procedure SalesLine_OnValidateLineDiscountPercentOnAfterTestStatusOpen(CurrentFieldNo: Integer)
    var
        TrafalgarGeneralCodeunit: Codeunit "Trafalgar General Codeunit";
    begin
        if CurrentFieldNo IN [27, 28] then begin
            if TrafalgarGeneralCodeunit.CheckUserCanApplyGenericDiscount() = false then
                Error('You do not have permission to create system wide discounts, please chat to Kate');
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdateLineDiscPct, '', true, true)]
    local procedure SalesLine_OnBeforeUpdateLineDiscPct(var SalesLine: Record "Sales Line")
    var
        TrafalgarGeneralCodeunit: Codeunit "Trafalgar General Codeunit";
    begin
        if TrafalgarGeneralCodeunit.CheckUserCanApplyGenericDiscount() = false then
            Error('You do not have permission to create system wide discounts, please chat to Kate');
    end;

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopySalesLineFromSalesDocSalesLine, '', false, false)]
    procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesDocSalesLine(ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; var FromSalesLine: Record "Sales Line"; IncludeHeader: Boolean; RecalculateLines: Boolean)
    begin
        ToSalesLine."Product Code" := FromSalesLine."Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopySalesLineFromSalesLineBuffer, '', false, false)]
    procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesLineBuffer(var ToSalesLine: Record "Sales Line"; FromSalesInvLine: Record "Sales Invoice Line"; IncludeHeader: Boolean; RecalculateLines: Boolean; var TempDocSalesLine: Record "Sales Line" temporary; ToSalesHeader: Record "Sales Header"; FromSalesLineBuf: Record "Sales Line"; var FromSalesLine2: Record "Sales Line")
    begin
        ToSalesLine."Product Code" := FromSalesInvLine."Product Code";
        ToSalesLine.MODIFY;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopySalesLineFromSalesCrMemoLineBuffer, '', false, false)]
    procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesCrMemoLineBuffer(var ToSalesLine: Record "Sales Line"; FromSalesCrMemoLine: Record "Sales Cr.Memo Line"; IncludeHeader: Boolean; RecalculateLines: Boolean; var TempDocSalesLine: Record "Sales Line" temporary; ToSalesHeader: Record "Sales Header"; FromSalesLineBuf: Record "Sales Line"; FromSalesLine: Record "Sales Line")
    begin
        ToSalesLine."Product Code" := FromSalesCrMemoLine."Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopySalesLineFromSalesShptLineBuffer, '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesShptLineBuffer(var ToSalesLine: Record "Sales Line"; FromSalesShipmentLine: Record "Sales Shipment Line"; IncludeHeader: Boolean; RecalculateLines: Boolean; var TempDocSalesLine: Record "Sales Line" temporary; ToSalesHeader: Record "Sales Header"; FromSalesLineBuf: Record "Sales Line"; ExactCostRevMandatory: Boolean)
    begin
        ToSalesLine."Product Code" := FromSalesShipmentLine."Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnAfterCopySalesLineFromReturnRcptLineBuffer, '', false, false)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromReturnRcptLineBuffer(var ToSalesLine: Record "Sales Line"; FromReturnReceiptLine: Record "Return Receipt Line"; IncludeHeader: Boolean; RecalculateLines: Boolean; var TempDocSalesLine: Record "Sales Line" temporary; ToSalesHeader: Record "Sales Header"; FromSalesLineBuf: Record "Sales Line"; CopyItemTrkg: Boolean)
    begin
    end;
    */

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "Qty. To Ship", true, true)]
    local procedure SalesLine_OnAfterValidateEvent_QtyToShip(var Rec: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if Rec."Document Type" IN [Rec."Document Type"::Quote, Rec."Document Type"::Order] then begin
            if Rec.Type = Rec.Type::Item then
                if Item.Get(Rec."No.") then begin
                    if Item.Type = Item.Type::Inventory then
                        if Item."Manufacturing Policy" <> Item."Manufacturing Policy"::"Make-to-Order" then
                            if Rec."Qty. to Ship (Base)" > Rec.GetInStockQuantity() then
                                Message('You Do Not Have Enough Stock For Item %1 - %2', Rec."No.", Rec."Product Code");
                end;
        end;
    end;


}