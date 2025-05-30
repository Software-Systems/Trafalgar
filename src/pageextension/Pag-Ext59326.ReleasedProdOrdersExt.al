pageextension 59326 PagExtReleasedProdOrders extends "Released Production Orders"
{
    layout
    {
        addafter("Source No.")
        {
            field("Product Code"; Rec."Product Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Code field.', Comment = '%';
            }
        }
    }
}
