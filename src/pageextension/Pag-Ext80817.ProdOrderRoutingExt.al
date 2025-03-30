pageextension 80817 PagExtProdOrderRouting extends "Prod. Order Routing"
{
    layout
    {
        addafter("Run Time")
        {
            field("Input Quantity"; Rec."Input Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Input Quantity field.', Comment = '%';
            }
        }
    }
}
