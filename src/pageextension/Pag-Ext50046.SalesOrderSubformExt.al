pageextension 50046 PagExtSalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Quantity Invoiced")
        {
            field("Production Order No."; Rec."Production Order No.")
            {
                ApplicationArea = all;
            }
            field("Production Order Status"; Rec."Production Order Status")
            {
                ApplicationArea = all;
            }
        }
        modify("Line No.")
        {
            Editable = true;
            Visible = true;
        }
    }
}