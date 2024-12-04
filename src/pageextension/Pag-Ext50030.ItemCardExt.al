pageextension 50030 PagExtItemCard extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Long Description"; Rec."Long Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Long Description field.', Comment = '%';
            }
        }
    }
}
