table 50107 "Payment File Data"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Vendor Bank Branch"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Bank Branch';
        }
        field(3; "Vendor Bank Account"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Bank Account';
        }
        field(4; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(5; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.';
        }
        field(6; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Name';
        }
        field(7; "Payment File Text"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment File Text';
        }
        field(8; "Message to Recipient"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Message to Recipient';
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