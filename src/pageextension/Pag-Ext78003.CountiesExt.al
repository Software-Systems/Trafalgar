pageextension 78003 PagExtCounties extends Counties
{
    layout
    {
        addafter(Name)
        {
            field("Shipping Location"; Rec."Shipping Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Location field.', Comment = '%';
            }
        }
    }
}
