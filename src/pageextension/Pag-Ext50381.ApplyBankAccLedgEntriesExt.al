pageextension 50381 PagExtApplyBankAccLedgEntries extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addbefore(Open)
        {
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
