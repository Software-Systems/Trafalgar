page 50107 "Historical Sales"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Historical Sales";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }
                field("SO Number"; Rec."SO Number")
                {
                    ApplicationArea = all;
                }
                field("Customer PO"; Rec."Customer PO")
                {
                    ToolTip = 'Specifies the value of the Customer PO # field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Product Number"; Rec."Product Number")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Invoice Amount(excl GST)"; Rec."Invoice Amount(excl GST)")
                {
                    ApplicationArea = all;
                }
                field("Ship to City"; Rec."Ship to City")
                {
                    ToolTip = 'Specifies the value of the Ship to City field.', Comment = '%';
                }
                field("Ship to State"; Rec."Ship to State")
                {
                    ApplicationArea = all;
                }
                field("Ship to Country"; Rec."Ship to Country")
                {
                    ToolTip = 'Specifies the value of the Ship to Country field.', Comment = '%';
                }
            }
        }

        area(Factboxes)
        {
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                end;
            }
        }
    }
}