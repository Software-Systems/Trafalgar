tableextension 55406 TabExtProductionOrderLine extends "Prod. Order Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Product Code"; Code[200])
        {
            Caption = 'Product Code';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}