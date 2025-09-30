pageextension 51345 PagExtSalesPriceLineDiscounts extends "Sales Price and Line Discounts"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {
            field("Product Code"; Rec."Product Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Code field.', Comment = '%';
            }
        }

        addafter("Sales Code")
        {
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
            }
        }
    }
}
