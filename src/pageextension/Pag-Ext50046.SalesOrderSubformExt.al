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
            field("Picked By"; Rec."Picked By")
            {
                ApplicationArea = All;
                Editable = FieldVisible;
                Visible = FieldVisible;
                ToolTip = 'Specifies the value of the Picked By field.', Comment = '%';
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
                Editable = FieldVisible;
                Visible = FieldVisible;
                ToolTip = 'Specifies the value of the Checked By field.', Comment = '%';
            }
        }
        addafter(Quantity)
        {
            field("In Stock Qty"; Rec.GetInStockQuantity)
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 2;
                Style = Strong;
            }
            /*
            field("Available Qty"; Rec.GetProjAvailableBalance)
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 2;
                Style = Strong;
            }
            */
        }
        modify("Line No.")
        {
            Editable = true;
            Visible = true;
        }
    }

    var
        TrafalgarGenCodeunit: Codeunit "Trafalgar General Codeunit";
        FieldVisible: Boolean;

    trigger OnOpenPage()
    begin
        FieldVisible := TrafalgarGenCodeunit.CheckPickedAndCheckedEnabled()
    end;
}