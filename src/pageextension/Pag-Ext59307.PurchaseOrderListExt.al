pageextension 59307 PagExtPurchaseOrderList extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor Name")
        {
            field("Received Not Invoiced"; Rec."Received Not Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Received Not Invoiced field.', Comment = '%';
            }
            field("Qty Received Not Invoiced"; Rec."Qty Received Not Invoiced")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty Received Not Invoiced field.', Comment = '%';
            }
        }
    }
}