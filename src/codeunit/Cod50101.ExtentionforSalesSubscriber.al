codeunit 50101 "Extention for Sales Subscriber"
{
    local procedure CheckForPlannedProductionOrders(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        ProductionOrder: Record "Production Order";
        NotAllowedErr: Label 'There are Make to Order items on this sale, that have not been planned, please plan them, and release again (This order has not released).';
        CCDetailsErr: Label 'Cannot release! The Credit Card information is not updated.';
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
                    ProductionOrder.SetRange(Status, ProductionOrder.Status::Planned);
                    if ProductionOrder.IsEmpty then
                        Message(NotAllowedErr);
                end;
            until SalesLine.Next() = 0;
        if SalesHeader."Payment Terms Code" = 'CIA' then
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
                if (SalesHeader."CC Machine" = '') or (SalesHeader."CC Processed By" = '')
                    or (SalesHeader."CC Payment Date" = 0D) or (SalesHeader."CC Card Type" = '') then
                    Error(CCDetailsErr);
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

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")

    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader."Requested Delivery Date" := today;
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
        NotAllowedtoRelease: Label 'The payment amount must be equal to the order amount, and the payment processed must be true.';
    begin
        if UserSetup.Get(UserId) then begin
            if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
                if not UserSetup."Can Always Release CIA orders" then begin
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    if SalesLine.FindSet() then
                        DocumentTotal.CalculateSalesSubPageTotals(SalesHeader, SalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
                    if (SalesHeader."Payment Terms Code" = 'CIA') then
                        if (SalesHeader."Amount Paid" <> SalesLine."Amount Including VAT") or (SalesHeader."Payment Processed" = false) then
                            Error(NotAllowedtoRelease);
                end;
        end;
        CheckForPlannedProductionOrders(SalesHeader, SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Sell-to Customer No.", false, false)]
    local procedure OnAfterInsertEventCustomer(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then
            Rec."Quote Created By" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Payment Processed", false, false)]
    local procedure OnAfterValidateEvent(var Rec: Record "Sales Header")
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if (not UserSetup."Can Reprocess Payment") or (not UserSetup."Can Always Release CIA orders") then
                Error('Cannot Modify the Payment Processed field, please contact the administrator!');
        end;
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

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterLookupShipToPostCode, '', true, true)]
    local procedure OnAfterValidate(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    begin
        UpdateWarehouseLocation(SalesHeader, xSalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs, '', true, true)]
    local procedure OnValidateSellTo(var Cust: Record Customer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) or
        (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) then begin
            if Cust.Blocked = Cust.Blocked::Ship then
                IsHandled := true
            else
                IsHandled := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateBillToCustomerNoOnBeforeCheckBlockedCustOnDocs, '', true, true)]
    local procedure OnValidateBilTo(var Cust: Record Customer; var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Order) or
        (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) then begin
            if (Cust.Blocked = Cust.Blocked::Ship) or (Cust.Blocked = Cust.Blocked::" ") then
                IsHandled := true
            else
                IsHandled := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeCheckBlockedCust, '', true, true)]
    local procedure MyProcedure(Customer: Record Customer; Source: Option; var IsHandled: Boolean)
    begin
        if Source = 1 then
            if (Customer.Blocked = Customer.Blocked::Ship) or (Customer.Blocked = Customer.Blocked::" ") then
                IsHandled := true
            else
                IsHandled := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnBeforeGetCustNoOpenCard, '', true, true)]
    local procedure SkipCustomerCreationMessage(CustomerText: Text; var ShowCreateCustomerOption: Boolean; var IsHandled: Boolean; var CustomerNo: Code[20])
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

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterOnInsert, '', true, true)]
    local procedure OnValidateSellTOCustomer(var SalesHeader: Record "Sales Header")
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

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification, '', true, true)]
    local procedure OnAfterValidateCustomer(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        PostCode: Record "Post Code";
        salesLine: Record "Sales Line";
        County: Record County;
    begin
        //UpdateWarehouseLocation(SalesHeader, xSalesHeader);
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
    local procedure OnAfterCopyShipToCustomer(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    begin
        UpdateWarehouseLocation(SalesHeader, xSalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Sell-to Customer No.", true, true)]
    local procedure OnAfterValid(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Sell-to Customer No.") then
            if Customer."Important Notes" <> '' then
                Message(Customer."Important Notes");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", OnAfterGetRecordEvent, '', true, true)]
    local procedure OnAfterGetRec(var Rec: Record Customer)
    begin
        if Rec."Important Notes" <> '' then
            Message(Rec."Important Notes");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertSalesheader(var Rec: Record "Sales Header")

    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            Rec."Quote Valid Until Date" := CalcDate('+30D', Today)
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnAfterConfirmPost, '', true, true)]
    local procedure OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
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

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "No.", true, true)]
    local procedure OnAfterValidateEventNO(var Rec: Record "Sales Header")
    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            Rec."Quote Valid Until Date" := CalcDate('+30D', Today)
        end;
    end;
}