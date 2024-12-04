tableextension 50124 TabExtPurchCrMemoHeader extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Price Changed"; Boolean)
        {
            Caption = 'Price Changed';
            DataClassification = CustomerContent;
        }
        field(50101; Documents; Text[500])
        {
            Caption = 'Documents';
            ExtendedDatatype = URL;
            DataClassification = CustomerContent;
        }
    }
}