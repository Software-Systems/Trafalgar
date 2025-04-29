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
            field("Can Release Order for Overdue"; Rec."Can Release Order for Overdue")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can Release Order for Overdue Cust Entries field.', Comment = '%';
            }
            field("Sales Doc Assigned"; Rec."Sales Doc Assigned")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Doc Assigned field.', Comment = '%';
            }
            field("Can Apply Generic Discounts"; Rec."Can Apply Generic Discounts")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Can Apply Generic Discounts field.', Comment = '%';
            }
        }
    }
}
