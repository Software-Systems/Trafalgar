table 50103 "Historical Purchases"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2; PO; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PO';
        }
        field(3; Status; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(4; Location; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Location';
        }
        field(5; "Vendor"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor';
        }
        field(6; "Part Number"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Part Name';
        }
        field(7; "Part Description"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Part Description';
        }
        field(8; Qty; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty';
        }
        field(9; UOM; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'UOM';
        }
        field(10; "FX"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FX';
        }
        field(11; "FX Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'FX Rate';
        }
        field(12; "Unit Cost FX"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost FX';
        }
        field(13; "Total Cost FX"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Cost FX';
        }
        field(14; "Unit Cost AUD"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost AUD';
        }
        field(15; "Total Cost AUD"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Cost AUD';
        }
        field(16; "Unit Landed Cost AUD"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Landed Cost AUD';
        }
        field(17; "Total Landed Cost AUD"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Landed Cost AUD';
        }
        field(18; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(19; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

}