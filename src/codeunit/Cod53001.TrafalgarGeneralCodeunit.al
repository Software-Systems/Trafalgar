codeunit 53001 "Trafalgar General Codeunit"
{
    procedure CheckUserCanApplyGenericDiscount(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset;
        UserSetup.Setrange(UserSetup."User ID", UserId);
        if UserSetup.FindFirst() then
            exit(UserSetup."Can Apply Generic Discounts")
        else
            exit(False)
    end;

    procedure GetUserNameFromSecurityId(ParUserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(ParUserSecurityID) THEN
            exit(User."User Name")
        ELSE
            exit('');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments", OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer, '', false, false)]
    procedure SuggestVendorPayments_OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        VendorLedgerEntry.Reset;
        VendorLedgerEntry.Setrange(VendorLedgerEntry."Vendor No.", GenJournalLine."Account No.");
        VendorLedgerEntry.Setrange(VendorLedgerEntry."Document Type", GenJournalLine."Applies-to Doc. Type");
        VendorLedgerEntry.Setrange(VendorLedgerEntry."Document No.", GenJournalLine."Applies-to Doc. No.");
        if VendorLedgerEntry.FindSet() then
            GenJournalLine."Message to Recipient" := 'Trafalgar ' + VendorLedgerEntry."External Document No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnBeforeGetVendorEmailAddress, '', false, false)]
    local procedure ReportSelections_OnBeforeGetVendorEmailAddress(BuyFromVendorNo: Code[20]; var ToAddress: Text; ReportUsage: Option; var IsHandled: Boolean; RecVar: Variant)
    var
        ReportUsageLocal: Enum "Report Selection Usage";
        RecVendor: Record Vendor;
    begin
        /*
        Requested on 03rd March 2025,
        Documents that need to be sent to the ‘Accounts Email Address’ from the Vendor Card:
        •	Vendor Remittance, Posted and Payment Journal entries

        Documents that need to be sent to the ‘Account Manager Email’ from the Vendor Card:
        •	Purchase Order
        •	Purchase Quote
        */
        If RecVendor.Get(BuyFromVendorNo) then begin
            case
                ReportUsage of
                84, 86:
                    ToAddress := RecVendor."Account E-Mail";
                5, 6:
                    ToAddress := RecVendor."Account Manager E-Mail";
            end;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", OnBeforeGetCustEmailAddress, '', false, false)]
    local procedure ReportSelections_OnBeforeGetCustEmailAddress(BillToCustomerNo: Code[20]; ReportUsage: Option; var IsHandled: Boolean; var ToAddress: Text)
    var
        ReportUsageLocal: Enum "Report Selection Usage";
        RecCustomer: Record Customer;
    begin
        /*
        value(0; "S.Quote") { Caption = 'Sales Quote'; }
        value(1; "S.Order") { Caption = 'Sales Order'; }
        value(2; "S.Invoice") { Caption = 'Sales Invoice'; }
        value(3; "S.Cr.Memo") { Caption = 'Sales Credit Memo'; }
        value(4; "S.Test") { Caption = 'Sales Test'; }
        value(38; "S.Shipment") { Caption = 'Sales Shipment'; }
        value(39; "S.Ret.Rcpt.") { Caption = 'Sales Return Receipt'; }
        value(40; "S.Work Order") { Caption = 'Sales Work Order'; }
        value(85; "C.Statement") { Caption = 'Customer Statement'; }

        Requested on 03rd March 2025,
        Documents that need to be sent to the ‘Accounts Email Address’ from the Customer Card:
        •	Customer Statement
        •	Sales Invoice
        •	Sales Cr Note

        Documents that need to be sent to the ‘Buyers Email Address from the Customer Card:
        •	Sales Order
        •	Sales Quote
        */

        If RecCustomer.Get(BillToCustomerNo) then begin
            case
                ReportUsage of
                85, 2, 3:
                    ToAddress := RecCustomer."Accounts Email Address";
                0, 1:
                    ToAddress := RecCustomer."Buyer Email Address";
            end;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", OnBeforeSendEmail, '', false, false)]
    local procedure DocumentMailing_OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        RecCustomer: Record Customer;
        RecVendor: Record Vendor;
        CustVendorNo: Code[20];
    begin
        /*
        value(0; "S.Quote") { Caption = 'Sales Quote'; }
        value(1; "S.Order") { Caption = 'Sales Order'; }
        value(2; "S.Invoice") { Caption = 'Sales Invoice'; }
        value(3; "S.Cr.Memo") { Caption = 'Sales Credit Memo'; }
        value(4; "S.Test") { Caption = 'Sales Test'; }
        value(38; "S.Shipment") { Caption = 'Sales Shipment'; }
        value(39; "S.Ret.Rcpt.") { Caption = 'Sales Return Receipt'; }
        value(40; "S.Work Order") { Caption = 'Sales Work Order'; }
        value(85; "C.Statement") { Caption = 'Customer Statement'; }
        value(88; "S.Invoice Draft") { Caption = 'Sales Invoice Draft'; }
        value(89; "Pro Forma S. Invoice") { Caption = 'Pro Forma Sales Invoice'; }

        value(5; "P.Quote") { Caption = 'Purchase Quote'; }
        value(6; "P.Order") { Caption = 'Purchase Order'; }
        value(7; "P.Invoice") { Caption = 'Purchase Invoice'; }
        value(8; "P.Cr.Memo") { Caption = 'Purchase Credit Memo'; }
        value(9; "P.Receipt") { Caption = 'Purchase Receipt'; }
        value(10; "P.Ret.Shpt.") { Caption = 'Purchase Return Shipment'; }
        value(11; "P.Test") { Caption = 'Purchase Test'; }
        value(84; "P.V.Remit.") { Caption = 'Purchase Vendor Remittance'; }
        value(86; "V.Remittance") { Caption = 'Vendor Remittance'; }

        Requested on 03rd March 2025,
        Documents that need to be sent to the ‘Accounts Email Address’ from the Customer Card:
        •	Customer Statement
        •	Sales Invoice
        •	Sales Cr Note

        Documents that need to be sent to the ‘Buyers Email Address from the Customer Card:
        •	Sales Order
        •	Sales Quote

          Documents that need to be sent to the ‘Accounts Email Address’ from the Vendor Card:
        •	Vendor Remittance, Posted and Payment Journal entries

        Documents that need to be sent to the ‘Account Manager Email’ from the Vendor Card:
        •	Purchase Order
        •	Purchase Quote
        */
        case
            ReportUsage of
            // 84, 86: //Vendor Remittance (Posted Unposted)
            //     begin
            //         TempEmailItem."Send to" := RecVendor."Account E-Mail";
            //     end;
            5, 6: //Purchase Quote / Order
                begin
                    PurchHeader.Reset;
                    PurchHeader.Setrange(PurchHeader."No.", PostedDocNo);
                    if PurchHeader.FindFirst() then
                        CustVendorNo := PurchHeader."Pay-to Vendor No.";

                    if CustVendorNo <> '' then begin
                        if RecVendor.Get(CustVendorNo) then
                            TempEmailItem."Send to" := RecVendor."Account Manager E-Mail";
                    end;
                end;

            85, 2, 3: //Customer Statement , Sales Invoice & CN
                begin
                    SalesInvHeader.Reset;
                    SalesInvHeader.Setrange(SalesInvHeader."No.", PostedDocNo);
                    if SalesInvHeader.FindFirst() then
                        CustVendorNo := SalesInvHeader."Bill-to Customer No."
                    else begin
                        SalesCrMemoHeader.Reset;
                        SalesCrMemoHeader.Setrange(SalesCrMemoHeader."No.", PostedDocNo);
                        if SalesCrMemoHeader.FindFirst() then
                            CustVendorNo := SalesCrMemoHeader."Bill-to Customer No."
                    end;

                    if CustVendorNo <> '' then begin
                        if RecCustomer.Get(CustVendorNo) then
                            TempEmailItem."Send to" := RecCustomer."Accounts Email Address";
                    end;
                end;
            0, 1, 89: // Sales Quote & Order & Proforma Invoice
                begin
                    SalesHeader.Reset;
                    SalesHeader.Setrange(SalesHeader."No.", PostedDocNo);
                    if SalesHeader.FindFirst() then
                        CustVendorNo := SalesHeader."Bill-to Customer No.";

                    if CustVendorNo <> '' then begin
                        if RecCustomer.Get(CustVendorNo) then
                            TempEmailItem."Send to" := RecCustomer."Buyer Email Address";
                    end;
                end;
            88: // Sales Invoice Draft
                begin
                    SalesHeader.Reset;
                    SalesHeader.Setrange(SalesHeader."No.", PostedDocNo);
                    if SalesHeader.FindFirst() then
                        CustVendorNo := SalesHeader."Bill-to Customer No.";

                    if CustVendorNo <> '' then begin
                        if RecCustomer.Get(CustVendorNo) then
                            TempEmailItem."Send to" := RecCustomer."Accounts Email Address";
                    end;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnBeforePostingItemJnlFromProduction, '', false, false)]
    procedure ItemJournalLine_OnBeforePostingItemJnlFromProduction(var ItemJournalLine: Record "Item Journal Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderQty: Decimal;
    begin
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output then begin
            ProdOrderLine.Reset;
            ProdOrderLine.Setrange(ProdOrderLine."Prod. Order No.", ItemJournalLine."Order No.");
            ProdOrderLine.Setrange(ProdOrderLine."Line No.", ItemJournalLine."Order Line No.");
            if ProdOrderLine.findset then
                ProdOrderQty := ProdOrderLine.Quantity;

            if ProdOrderQty <> ItemJournalLine.Quantity then begin
                if Confirm('The qty does not match the qty from the Production order Line, Are you sure you want to continue Posting ?') then begin
                    //Go Through Posting
                end
                else
                    Error('Quantity in Production Order %1 Line %2 (Qty = %3) Doesnt Match With Journal Line (Qty = %4).',
                        ProdOrderLine."Prod. Order No.",
                        ProdOrderLine."Line No.",
                        ProdOrderLine.Quantity,
                        ItemJournalLine.Quantity);
            end;
        end;
    end;

    procedure PopUpCustomerImportantNotes(ParImportantNotes: Text)
    var
        CustomerNotification: Notification;
    begin
        if DelChr(ParImportantNotes, '=', ' ') <> '' then begin
            Clear(CustomerNotification);
            CustomerNotification.Message := ParImportantNotes;
            CustomerNotification.Scope := NotificationScope::LocalScope;
            CustomerNotification.Send();
        end;
    end;

    procedure ConvertToBarcode(ParText: Text): Text
    var
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeStr: Code[50];
        RetValueEncodedText: Text;
    begin
        RetValueEncodedText := '';
        if ParText <> '' then begin
            BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;  //FONT PROVIDER IDAUTOMATION
            BarcodeSymbology := Enum::"Barcode Symbology"::Code128;                        //SIMBOLOGY - "CODE 128" in this case
            BarcodeStr := ParText;
            BarcodeFontProvider.ValidateInput(BarcodeStr, BarcodeSymbology);              //VALIDATE INPUT DATA - NOT MANDATORY
            RetValueEncodedText := BarcodeFontProvider.EncodeFont(BarcodeStr, BarcodeSymbology);  //ENCODETEXT in Barcode
        end;
        Exit(RetValueEncodedText);
    end;

}
