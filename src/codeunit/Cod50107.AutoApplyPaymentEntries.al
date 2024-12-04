codeunit 50107 AutoApplyPaymentEntries
{
    trigger OnRun()
    begin
        ApplyPaymentEntries();
    end;

    local procedure ApplyPaymentEntries()
    var
        PaymentCLE: Record "Cust. Ledger Entry";
        InvoiceCLE: Record "Cust. Ledger Entry";
        PaymentToCLE: Record "Cust. Ledger Entry";
        CustEntrySetApplyID: Codeunit "Cust. Entry-SetAppl.ID";
        CustEntryApplyPosted: Codeunit "CustEntry-Apply Posted Entries";
        ApplyUnapplyParameter: Record "Apply Unapply Parameters" temporary;
        DescriptionTxt: Text;
        AppliesToID: Code[50];
        AccountNo: Code[20];
        CountInt: Integer;
        CurrentInt: Integer;
        Progress: Dialog;
        Text000: Label 'Counting to %1  ------ #1';
    begin
        Clear(AccountNo);
        Clear(CurrentInt);
        PaymentCLE.Reset();
        PaymentToCLE.Reset();
        PaymentCLE.SetCurrentKey("Document Type", "External Document No.");
        PaymentCLE.SetRange("Document Type", PaymentCLE."Document Type"::Payment);
        PaymentCLE.SetFilter("External Document No.", '<>%1', '');
        PaymentCLE.SetRange(Open, true);
        if PaymentCLE.FindSet(true) then begin
            CountInt := PaymentCLE.Count;
            if GuiAllowed then
                Progress.Open(StrSubstNo(Text000, CountInt), CurrentInt);
            repeat
                CurrentInt += 1;
                if PaymentCLE.Open then begin
                    Clear(DescriptionTxt);
                    AccountNo := PaymentCLE."Customer No.";
                    InvoiceCLE.SetCurrentKey("Customer No.", "Document Type");
                    InvoiceCLE.Reset();
                    InvoiceCLE.SetRange("Customer No.", PaymentCLE."Customer No.");
                    InvoiceCLE.SetRange("Document Type", InvoiceCLE."Document Type"::Invoice);
                    InvoiceCLE.SetRange(Open, true);
                    if InvoiceCLE.FindFirst() then begin
                        DescriptionTxt := DelStr(InvoiceCLE.Description, 1, 6);
                        if PaymentCLE."External Document No." = DescriptionTxt then begin
                            InvoiceCLE.CALCFIELDS(Amount);
                            InvoiceCLE."Applying Entry" := true;
                            InvoiceCLE."Applies-to ID" := 'AUTOAPPLIEDENTRY';
                            InvoiceCLE.CALCFIELDS("Remaining Amount");
                            InvoiceCLE.VALIDATE("Amount to Apply", InvoiceCLE."Remaining Amount");
                            CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit", InvoiceCLE);
                            COMMIT;// Commit the change
                            PaymentToCLE.SetRange("Entry No.", PaymentCLE."Entry No.");
                            PaymentToCLE.FindSet();
                            CustEntrySetApplyID.SetApplId(PaymentToCLE, InvoiceCLE, 'AUTOAPPLIEDENTRY');
                            ApplyUnapplyParameter."Entry No." := PaymentToCLE."Entry No.";
                            if PaymentToCLE."Posting Date" > InvoiceCLE."Posting Date" then
                                ApplyUnapplyParameter."Posting Date" := PaymentToCLE."Posting Date"
                            else
                                ApplyUnapplyParameter."Posting Date" := InvoiceCLE."Posting Date";
                            ApplyUnapplyParameter."Document No." := PaymentToCLE."Document No.";
                            ApplyUnapplyParameter."Account Type" := ApplyUnapplyParameter."Account Type"::Customer;
                            ApplyUnapplyParameter."Account No." := PaymentToCLE."Customer No.";
                            ApplyUnapplyParameter.Insert(false);
                            CustEntryApplyPosted.Apply(InvoiceCLE, ApplyUnapplyParameter);
                            COMMIT;// Commit the change
                        end;
                    end;
                end;
                if GuiAllowed then
                    Progress.Update();
            until PaymentCLE.Next() = 0;
            if GuiAllowed then
                Progress.Close();
        end;
    end;
}
