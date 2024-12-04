pageextension 50119 PagExtUserSetup extends "User Setup"
{
    layout
    {
        addafter("Change Sales Line Discounts")
        {
            field("Can Reprocess Payment"; Rec."Can Reprocess Payment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can Reporcess Payment field.', Comment = '%';
            }
            field("Can Always Release CIA orders"; Rec."Can Always Release CIA orders")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can Always Release CIA orders field.', Comment = '%';
            }
            field("Can Change Account Customer"; Rec."Can Change Account Customer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can Change Account Customer field.', Comment = '%';
            }
        }
    }
}
