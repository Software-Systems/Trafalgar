pageextension 50054 PagExtPurchaseOrderSubform extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Quantity Invoiced")
        {
            field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Rcd. Not Invoiced field.', Comment = '%';
            }
        }
    }
}