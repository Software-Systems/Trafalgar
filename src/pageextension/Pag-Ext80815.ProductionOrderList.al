pageextension 80815 PagExtProductionOrderList extends "Production Order List"
{
    layout
    {
        addafter("Source No.")
        {
            field("Product Code"; Rec."Product Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Code field.', Comment = '%';
            }
        }
        modify("Finished Date")
        {
            Visible = True;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = True;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = True;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.', Comment = '%';
            }
            field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code field.', Comment = '%';
            }
        }

    }
}
