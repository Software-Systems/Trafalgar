tableextension 50098 TabExtGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "SharePoint Document Path"; Text[500])
        {
            Caption = 'SharePoint Document Path';
            DataClassification = CustomerContent;
        }
        field(50101; "Auto Send Invoice on Posting"; Boolean)
        {
            Caption = 'Auto Send Invoice on Order Posting';
            DataClassification = CustomerContent;
        }
    }
}