codeunit 50100 "Update Posting Range"
{
    trigger OnRun()
    begin
        if (GenJnlSetup.get()) and (GenJnlSetup."Allow Posting To" < Today) then begin
            GenJnlSetup."Allow Posting From" := CalcDate('<-CM>', Today);
            GenJnlSetup."Allow Posting To" := CalcDate('<CM>', Today);
            GenJnlSetup.Modify(true);
        end;
    end;

    var
        GenJnlSetup: Record "General Ledger Setup";
}