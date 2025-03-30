pageextension 50042 PagExtSalesOrder extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Amount Paid")
        {
            Editable = False;
        }
        addafter(Status)
        {
            field("Method Of Enquiry"; Rec."Method Of Enquiry")
            {
                ApplicationArea = All;
            }
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
            /*
            field("CC Processed By"; Rec."CC Processed By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Processed By field.', Comment = '%';
            }
            field("CC Payment Date"; Rec."CC Payment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Payment Date field.', Comment = '%';
            }
            field("CC Card Type"; Rec."CC Card Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Card Type field.', Comment = '%';
            }
            field("CC Machine"; Rec."CC Machine")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Machine field.', Comment = '%';
            }
            */
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Modified By field.', Comment = '%';
            }
            field("Quote Created By"; Rec."Quote Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Created By field.', Comment = '%';
                Editable = false;
            }
            field("Lost Opportunity"; Rec."Lost Opportunity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lost Opportunity field.', Comment = '%';
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Quote Reason Code"; Rec."Quote Reason Code")
            {
                ApplicationArea = All;
                Caption = 'Lost Reason'; // Updated caption
                Editable = Rec."Lost Opportunity";
                ToolTip = 'Specifies the value of the Lost Reason field.', Comment = '%';
            }
            field(GetTotalSalesPaid; Rec.GetTotalSalesPaid())
            {
                Caption = 'Total Paid';
                Style = StrongAccent;
                ApplicationArea = All;
            }
        }
    }

    actions
    {

        addafter("Create &Warehouse Shipment")
        {
            action(UpdateWarehouseStatus)
            {
                Caption = 'Update Warehouse Status';
                ApplicationArea = all;
                Image = UpdateShipment;
                trigger OnAction()
                begin
                    CheckAndUpdateStatus(Rec."No.");
                end;
            }
            action(OpenMaps)
            {
                Caption = 'Open in Google Map';
                Image = OpenJournal;
                ToolTip = 'Opens Google Map.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink('https://www.google.com.au/maps/place/' +
                    ReplaceSpecialCharsWithSpaces(Rec."Ship-to Address") + '+' + ReplaceSpecialCharsWithSpaces(Rec."Ship-to Address 2") + '+' + ReplaceSpecialCharsWithSpaces(Rec."Ship-to City") + '+' + ReplaceSpecialCharsWithSpaces(Rec."Ship-to County") + '+' + Rec."Ship-to Post Code");
                end;
            }
        }
        addafter("Create &Warehouse Shipment_Promoted")
        {
            actionref("UpdateWarehouseStatus_Promoted"; UpdateWarehouseStatus)
            {
            }
            actionref(OpenInGoogle_Promoted; OpenMaps)
            {
            }
        }
        // Add changes to page actions here
        addbefore("Send IC Sales Order")
        {
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink(Rec.Documents);
                end;
            }
        }
        addafter(ProformaInvoice)
        {
            action("Print Quotation")
            {
                Image = Print;
                ApplicationArea = all;
                trigger OnAction()
                var
                    TrafalgarSalesQuotation: Report "Trafalgar Sales Quotation";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("No.", Rec."No.");
                    if SalesHeader.FindFirst then begin
                        TrafalgarSalesQuotation.SetTableView(SalesHeader);
                        TrafalgarSalesQuotation.Run();
                    end;
                end;
            }
            action("Delivery Docket")
            {
                Caption = 'Delivery Docket';
                Image = Report;
                ToolTip = 'Print Delivery Docket.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    TrafalgarSalesQuotation: Report "Delivery Docket";
                begin
                    SalesHeader.SetRange("No.", Rec."No.");
                    SalesHeader.FindFirst();
                    TrafalgarSalesQuotation.SetTableView(SalesHeader);
                    TrafalgarSalesQuotation.Run();
                end;
            }
            action("Invoice")
            {
                Caption = 'Invoice';
                Image = Report;
                ToolTip = 'Print Invoice.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    Invoice: Report "Invoice-Sales Order";
                begin
                    SalesHeader.SetRange("No.", Rec."No.");
                    SalesHeader.FindFirst();
                    Invoice.SetTableView(SalesHeader);
                    Invoice.Run();
                end;
            }
            action("Take Payment")
            {
                Image = Payment;
                ApplicationArea = all;
                RunObject = Page "Sales Payments";
                RunPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
            }
        }
        addafter(SendEmailConfirmation)
        {
            action(SendProformaByEmail)
            {
                Caption = 'Email Proforma';
                Visible = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesEvents: Codeunit "Extention for Sales Subscriber";
                    ConfirmationMessage: Codeunit "Confirm Management";
                begin
                    SalesEvents.SendEmailProforma(Rec);
                    if not ConfirmationMessage.GetResponse('Do you want to send this to the client?', false) then
                        Error('Cancelled');
                end;
            }
        }
        addbefore("Send IC Sales Order")
        {
            /*
            action(PostPayReceipt)
            {
                Caption = 'Post Pay Receipt';
                ApplicationArea = all;
                Image = PostDocument;
                ToolTip = 'Post Pay Receipt';
                trigger OnAction()
                begin
                    if Rec."Payment Processed" then
                        Error('You have already processed the payment.');
                    CreateandPostPayReceipt();
                end;
            }
            */
        }
        addafter(SendEmailConfirmation_Promoted)
        {
            actionref(EmailProforma_Promoted; SendProformaByEmail)
            {
            }
        }
        addafter("Archive Document_Promoted")
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
            /*
            actionref("PostPayReceipt_Promoted"; PostPayReceipt)
            {
            }
            */
            actionref(TakePayment_Promoted; "Take Payment")
            {
            }
        }
        addafter(ProformaInvoice_Promoted)
        {
            actionref(PrintQuotation_Promoted; "Print Quotation")
            {
            }
            actionref("DeliveryDocket_Promoted"; "Delivery Docket")
            {
            }
            actionref(Invoice_promoted; "Invoice")
            {
            }
        }
    }
    var
        UserSetup: Record "User Setup";
        AmountEdit: Boolean;
        NoStockMessage: Text;
        ShortcutDimCode: array[8] of Code[20];

    local procedure ItemInventoryCheck(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        PackedQty: Decimal;
    begin
        PackedQty := 0;
        GetPackedItemQty(SalesLine, PackedQty);

        Item.Reset();
        Item.SetRange(Item."No.", SalesLine."No.");
        Item.SetRange("Location Filter", SalesLine."Location Code");
        if Item.FindFirst() then begin
            Item.CalcFields(Inventory);
            if ((Item.Inventory + PackedQty) >= SalesLine.Quantity) and (SalesLine."Qty. to Ship" <> 0) then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"5 In WH";
            if ((Item.Inventory + PackedQty) < SalesLine.Quantity) and (SalesLine."Qty. to Ship" <> 0) then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"4 Not Enough Stock";
            if Item.Type = Item.Type::"Non-Inventory" then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"7 Packed";
            SalesLine.Modify(true);
        end;
        SalesLine.CalcFields("Reserved Quantity");
        if SalesLine."Reserved Quantity" = SalesLine.Quantity then begin
            SalesLine."Production Order Status" := SalesLine."Production Order Status"::"6 Moved to WH";
            SalesLine.Modify(true);
        end;
        // If (SalesLine."Quantity Shipped" <> 0) AND (SalesLine."Qty. to Ship" = 0) then begin
        //     SalesLine."Production Order Status" := SalesLine."Production Order Status"::"8 Part Shipped";
        //     SalesLine.Modify(true);
        // end;
    end;

    local procedure ProductionOrderStatusCheck(var SalesLine: Record "Sales Line"; var ProductionOrder: Record "Production Order")
    begin
        if ProductionOrder.Status = ProductionOrder.Status::Planned then
            SalesLine."Production Order Status" := SalesLine."Production Order Status"::"1 Prod Planned"
        else
            if ProductionOrder.Status = ProductionOrder.Status::Released then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"2 Prod Released"
            else
                if ProductionOrder.Status = ProductionOrder.Status::Finished then
                    SalesLine."Production Order Status" := SalesLine."Production Order Status"::"3 Prod Completed";
        SalesLine."Production Order No." := ProductionOrder."No.";
        SalesLine.Modify(true);
    end;

    local procedure GetPackedItemQty(var SalesLine: Record "Sales Line"; var PackedQty: Decimal)
    var
        ItemSalesLine: Record "Sales Line";
    begin
        ItemSalesLine.SetRange(ItemSalesLine."No.", SalesLine."No.");
        ItemSalesLine.SetRange(ItemSalesLine."Production Order Status", ItemSalesLine."Production Order Status"::"7 Packed");
        if ItemSalesLine.FindSet() then
            repeat
                PackedQty += ItemSalesLine.Quantity;
            until ItemSalesLine.Next() = 0;
    end;

    local procedure UpdateStatusOnHeader(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        OrderStatusInt: Integer;
        PreviousOrderStatus: Enum "Order Status";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Order Status Manually Changed", false);
        SalesHeader.SetFilter("Order Status", '<>%1', SalesHeader."Order Status"::"7 Packed");
        SalesHeader.SetRange("No.", SalesLine."Document No.");
        if SalesHeader.FindSet() then
            repeat
                OrderStatusInt := 2;
                PreviousOrderStatus := PreviousOrderStatus::"1 Prod Planned";
                SalesLine.Reset();
                SalesLine.SetCurrentKey("Production Order Status");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then begin
                    SalesHeader."Order Status" := SalesLine."Production Order Status";
                    SalesHeader.Modify();
                end;
            until SalesHeader.Next() = 0;
    end;

    local procedure CheckAndUpdateStatus(DocNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        StatusCheck: Record "Sales Header";
        ProductionOrder: Record "Production Order";
        Progress: Dialog;
        Counter: Integer;
        Text000: Label 'Status Update ------ #1';
    begin
        Progress.OPEN(Text000, Counter);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", DocNo);
        if SalesLine.FindSet() then begin
            StatusCheck.Reset();
            StatusCheck.SetRange("No.", SalesLine."Document No.");
            StatusCheck.FindFirst();
            if (StatusCheck.Status <> StatusCheck.Status::Open) or (StatusCheck.Status <> StatusCheck.Status::Released) then begin
                repeat
                    if (SalesLine."Production Order Status" <> SalesLine."Production Order Status"::"7 Packed") then begin
                        ProductionOrder.Reset();
                        ProductionOrder.SetRange(ProductionOrder."Sales Order No.", SalesLine."Document No.");
                        ProductionOrder.SetRange(ProductionOrder."Source No.", SalesLine."No.");
                        if ProductionOrder.FindFirst() then begin
                            ProductionOrderStatusCheck(SalesLine, ProductionOrder);
                        end else begin
                            ItemInventoryCheck(SalesLine);
                        end;
                        Counter := Counter + 1;
                        Progress.UPDATE(); // Update the field in the dialog.
                        SLEEP(50);
                    end;
                until SalesLine.Next() = 0;
                UpdateStatusOnHeader(SalesLine);
            end;
        end;
        Progress.CLOSE();
    end;

    procedure ReplaceSpecialCharsWithSpaces(var _Text: Text[100]): Text[100]
    var
        i: Integer;
        Ch: Char;
    begin
        for i := 1 to StrLen(_Text) do begin
            Ch := _Text[i];
            if not IsAlphaNumeric(Ch) then begin
                _Text[i] := ' ';
            end;
        end;
        exit(_Text)
    end;

    procedure IsAlphaNumeric(Char: Char): Boolean
    begin
        if (Char >= 'A') and (Char <= 'Z') then
            exit(true);
        if (Char >= 'a') and (Char <= 'z') then
            exit(true);
        if (Char >= '0') and (Char <= '9') then
            exit(true);
        exit(false);
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        TrafalgarGenCodeunit: Codeunit "Trafalgar General Codeunit";
    begin
        AmountEdit := true;
        if Rec."Payment Processed" then
            AmountEdit := false;

        UserSetup.Get(UserId);
        if UserSetup."Can Reprocess Payment" then
            AmountEdit := true;

        NoStockMessage := Rec.CheckInStockQuantity;
        if Rec."No." <> xRec."No." then begin
            if NoStockMessage <> '' then
                Message('%1', NoStockMessage);

            if Customer.Get(Rec."Bill-to Customer No.") then
                TrafalgarGenCodeunit.PopUpCustomerImportantNotes(Customer."Important Notes");
        end;

        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    procedure CreateandPostPayReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        NoSeries: Record "No. Series";
        NoSeriesCU: Codeunit "No. Series";
        Dialog: Dialog;
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin

        if Rec."Amount Paid" = 0 then
            Error('You must specify amount paid');

        if Confirm('Do you want to record $ ' + Format(Rec."Amount Paid") + ' as a customer payment?', false) then begin
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
            GenJnlLine.SetRange("Journal Batch Name", 'SYSTEM');
            GenJnlLine.SetRange("Line No.", 10000);
            if GenJnlLine.FindFirst() then
                GenJnlLine.Delete();
            GenJnlLine.Init();
            GenJnlLine.Validate("Journal Template Name", 'GENERAL');
            GenJnlLine.Validate("Journal Batch Name", 'SYSTEM');
            NoSeries.Reset();
            NoSeries.SetRange(NoSeries.Code, 'GJNL-GENSYS');
            if NoSeries.FindFirst() then begin
                GenJnlLine.Validate("Document No.", NoSeriesCU.GetNextNo(NoSeries.Code));
            end;
            GenJnlLine.Validate("Line No.", 10000);
            GenJnlLine.Validate("Source Code", 'GENJNL');
            GenJnlLine.Insert();
            /*
            Fanie's Request - 05th March 2025 (Move this code from SmallChanges.app)
            On A Sales Order, On Post Pay Receipt, 
            If the CC Payment Date Field has a value, use that field, 
            if Not, use the Posting Date of the Sale order
            */
            if Rec."CC Payment Date" = 0D Then
                GenJnlLine.Validate("Posting Date", Today)
            else
                GenJnlLine.Validate("Posting Date", Rec."CC Payment Date");
            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.Validate("Account No.", Rec."Bill-to Customer No.");
            GenJnlLine.Validate(Amount, Rec."Amount Paid" * -1);
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
            GenJnlLine.Validate("Bal. Account No.", 'CBA');
            GenJnlLine.Validate("External Document No.", Rec."No.");
            GenJnlLine.Modify();
            GenJnlPostBatch.Run(GenJnlLine);
            Rec."Payment Processed" := true;
            Rec.Modify();
            Message('Customer payment of $' + Format(Rec."Amount Paid") + ' has been recorded. ');
        end;
    end;
}