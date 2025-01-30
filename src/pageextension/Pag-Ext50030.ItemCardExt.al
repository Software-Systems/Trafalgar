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
                MultiLine = true;
            }
            field("User Prompt"; Rec."User Prompt")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User Prompt field.', Comment = '%';
                MultiLine = true;
            }
        }
    }
}
