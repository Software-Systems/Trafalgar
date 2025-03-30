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
    begin
        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
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
                if SalesHeader."CC Payment Date" = 0D Then
                    GenJnlLine.Validate("Posting Date", Today)
                else
                    GenJnlLine.Validate("Posting Date", SalesHeader."CC Payment Date");
                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", SalesHeader."Bill-to Customer No.");
                GenJnlLine.Validate(Amount, Rec."Amount Paid" * -1);
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                GenJnlLine.Validate("Bal. Account No.", 'CBA');
                GenJnlLine.Validate("External Document No.", SalesHeader."No.");
                GenJnlLine.Modify();
                GenJnlPostBatch.Run(GenJnlLine);
                Rec."Payment Processed" := true;
                Rec.Modify();
                Message('Customer payment of $' + Format(Rec."Amount Paid") + ' has been recorded. ');
            end;
        end;
    end;
}
