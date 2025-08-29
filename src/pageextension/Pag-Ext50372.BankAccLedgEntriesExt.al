pageextension 50372 PagExtBankAccLedgEntries extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
            }
            field("CC Machine"; Rec.GetCCMachine)
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("CC Type"; Rec.GetCCType)
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }

}
