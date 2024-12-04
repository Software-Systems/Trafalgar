pageextension 50022 PagExtCustomerList extends "Customer List"
{
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
            }
        }
    }
}
