pageextension 59327 PagExtFinishedProdOrders extends "Finished Production Orders"
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
        modify("Finished Date")
        {
            Visible = True;
        }
    }
}
