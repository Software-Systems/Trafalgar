tableextension 50037 TabExtSalesLine extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
            DataClassification = CustomerContent;
        }
        field(50102; "Production Order Status"; Enum "Order Status")
        {
            Caption = 'Production Order Status';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        // Add changes to keys here
        key(ProdOrderStatus; "Production Order Status")
        {
        }
    }
}