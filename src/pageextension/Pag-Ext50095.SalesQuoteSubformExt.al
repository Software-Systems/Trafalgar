pageextension 50095 PagExtSalesQuoteSubform extends "Sales Quote Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Visible = true;
                Editable = true;
                ToolTip = 'Specifies the line number.';
            }
        }
    }
}
