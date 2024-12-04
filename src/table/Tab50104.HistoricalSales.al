table 50104 "Historical Sales"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(2; "SO Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'SO Number';
        }
        field(3; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(4; "Sales Rep"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Rep';
        }
        field(5; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
        }
        field(6; "Product Group"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Group';
        }
        field(7; "Product Desctiption"; Text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Description';
        }
        field(8; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(9; "Invoice Amount(excl GST)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Amount(excl GST)';
        }
        field(10; "Ship to State"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship to State';
        }
        field(11; "Ship to City"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship to City';
        }
        field(12; "Ship to Country"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship to Country';
        }
        field(13; "Product Number"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Number';
        }
        field(14; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(15; "Customer PO"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer PO #';
            TableRelation = Customer;
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