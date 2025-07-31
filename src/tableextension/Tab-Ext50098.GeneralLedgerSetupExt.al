tableextension 50098 TabExtGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "SharePoint Document Path"; Text[500])
        {
            Caption = 'Sharepoint Document Path';
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
        /*
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
        */
        field(50210; "Sharepoint GLEntries Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        /*
        field(50220; "SharePoint GLEntries Doc. Path"; Text[500])
        {
            Caption = 'GLEntries Document Path';
            DataClassification = CustomerContent;
        }
        */
        field(50230; "Sharepoint Client Secret"; Text[50])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
            /*
            Tenant ID : 1949af70-dfa8-4f47-8d72-f0df75f3efb3
            App ID  :   cbfcc940-706f-4617-9e57-2f76762d848b
            Secret  :   unT8Q~ImXL2wRUzW6CksaMWdiCzvMaTITYbcoaxx
            */
        }
    }
}