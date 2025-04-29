tableextension 50098 TabExtGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "SharePoint Document Path"; Text[500])
        {
            Caption = 'Sales Document Path';
            DataClassification = CustomerContent;
        }
        field(50101; "Auto Send Invoice on Posting"; Boolean)
        {
            Caption = 'Auto Send Invoice on Order Posting';
            DataClassification = CustomerContent;
        }
        field(50102; "Location For Make To Order"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50110; "SharePoint User Tasks Path"; Text[500])
        {
            Caption = 'User Tasks Document Path';
            DataClassification = CustomerContent;
        }
        field(50200; "SharePoint Purch Document Path"; Text[500])
        {
            Caption = 'Purchase Document Path';
            DataClassification = CustomerContent;
        }

    }
}