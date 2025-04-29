page 61002 "TG User Task Lines"
{
    ApplicationArea = All;
    Caption = 'User Task Lines';
    PageType = ListPart;
    SourceTable = "User Task";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                    Visible = False;
                    Editable = False;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                    Visible = False;
                    Editable = False;
                }
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the ID of the task.';
                    Visible = False;
                    Editable = False;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the title of the task.';
                }
                field(MultiLineTextControl; MultiLineTextControl)
                {
                    ApplicationArea = All;
                    Caption = 'Task Description';

                    trigger OnValidate()
                    begin
                        Rec.SetDescription(MultiLineTextControl);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                ApplicationArea = All;
                Image = TaskPage;
                RunObject = page "User Task Card";
                RunPageLink = ID = field(ID);
            }
        }
    }

    var
        MultiLineTextControl: Text;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(MultiLineTextControl);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Customer No." := Rec.GetRangeMin("Customer No.");
        Clear(MultiLineTextControl);
    end;

    trigger OnAfterGetRecord()
    begin
        MultiLineTextControl := Rec.GetDescription();
    end;
}
