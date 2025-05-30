table 50108 "Sales Payments"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(10; "Processed By"; Text[100])
        {
            Caption = 'Processed By';
            DataClassification = CustomerContent;
        }
        field(20; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
            DataClassification = CustomerContent;
        }
        field(30; "Card Type"; Option)
        {
            OptionMembers = " ",AMEX,Visa,Mastercard,Other,Bank;
            OptionCaption = ' ,AMEX,Visa,Mastercard,Other,Bank';
            Caption = 'Card Type';
            DataClassification = CustomerContent;
        }
        field(40; Machine; Text[100])
        {
            Caption = 'Machine';
            DataClassification = CustomerContent;
        }
        field(50; "Amount Paid"; Decimal)
        {
            Caption = 'Amount Paid';
            DataClassification = CustomerContent;
        }
        field(60; "Payment Processed"; Boolean)
        {
            Caption = 'Payment Processed';
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(70; "Apply to this Invoice"; Boolean)
        {
            Caption = 'Apply to this Invoice';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure CreateandPostPayReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        NoSeries: Record "No. Series";
        NoSeriesCU: Codeunit "No. Series";
        Dialog: Dialog;
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";

        CCPaymentDate: Date;
        CustomerNo: Code[20];
        ExtDocNo: Text;
        DocNo: Code[20];
        RemainingPaymentAmount: Decimal;
        AppliedAmount: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;

        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        CustLedgerEntry_Payments: Record "Cust. Ledger Entry";
        CustLedgerEntry_InvoicesToApply: Record "Cust. Ledger Entry";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
    begin
        SalesHeader.Reset;
        SalesHeader.Setrange(SalesHeader."Document Type", Rec."Document Type");
        SalesHeader.Setrange(SalesHeader."No.", Rec."Document No.");
        if SalesHeader.FindSet() then begin
            CCPaymentDate := Rec."Payment Date";
            CustomerNo := SalesHeader."Bill-to Customer No.";
            ExtDocNo := SalesHeader."No.";
        end
        else begin
            SalesInvHeader.Reset;
            if Rec."Document Type" = Rec."Document Type"::Order then
                SalesInvHeader.Setrange(SalesInvHeader."Order No.", Rec."Document No.")
            else
                SalesInvHeader.Setrange(SalesInvHeader."No.", Rec."Document No.");
            if SalesInvHeader.FindSet() then begin
                CCPaymentDate := SalesInvHeader."CC Payment Date";
                CustomerNo := SalesInvHeader."Bill-to Customer No.";
                ExtDocNo := SalesInvHeader."No.";
            end;
        end;

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
            if CCPaymentDate = 0D Then
                GenJnlLine.Validate("Posting Date", Today)
            else
                GenJnlLine.Validate("Posting Date", CCPaymentDate);
            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.Validate("Account No.", CustomerNo);
            GenJnlLine.Validate(Amount, Rec."Amount Paid" * -1);
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
            GenJnlLine.Validate("Bal. Account No.", 'CBA');
            GenJnlLine.Validate("External Document No.", ExtDocNo);
            GenJnlLine.Validate("Your Reference", Machine);

            RemainingPaymentAmount := Rec."Amount Paid";
            CustLedgerEntry.Reset;
            CustLedgerEntry.SetCurrentKey("Posting Date");
            CustLedgerEntry.Setrange(CustLedgerEntry.Open, True);
            CustLedgerEntry.Setrange(CustLedgerEntry."Document Type", CustLedgerEntry."Document Type"::Invoice);
            CustLedgerEntry.Setrange(CustLedgerEntry."Customer No.", CustomerNo);
            if CustLedgerEntry.FindFirst() then begin
                repeat
                    CustLedgerEntry.CalcFields(CustLedgerEntry."Remaining Amt. (LCY)");
                    if CustLedgerEntry."Remaining Amt. (LCY)" < RemainingPaymentAmount then
                        AppliedAmount := CustLedgerEntry."Remaining Amt. (LCY)"
                    else
                        AppliedAmount := RemainingPaymentAmount;

                    RemainingPaymentAmount := RemainingPaymentAmount - AppliedAmount;

                    CustLedgerEntry.Validate(CustLedgerEntry."Applies-to ID", GenJnlLine."Document No.");
                    CustLedgerEntry.Validate(CustLedgerEntry."Amount to Apply", AppliedAmount);
                    CustLedgerEntry.Modify();
                until (CustLedgerEntry.Next() = 0) or (RemainingPaymentAmount <= 0)
            end;

            GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
            GenJnlLine.Modify();
            GenJnlPostBatch.Run(GenJnlLine);
            Rec."Payment Processed" := true;
            Rec.Modify();
            Message('Customer payment of $' + Format(Rec."Amount Paid") + ' has been recorded. ');
        end;
    end;
}
