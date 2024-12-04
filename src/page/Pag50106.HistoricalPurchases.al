page 50106 "Historical Purchases"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Historical Purchases";

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
                field(PO; Rec.PO)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                // field(Location; Rec.Location)
                // {
                //     ApplicationArea = all;
                // }
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = all;
                }
                field("Part Number"; Rec."Part Number")
                {
                    ApplicationArea = all;
                }
                field("Part Description"; Rec."Part Description")
                {
                    ApplicationArea = all;
                }
                field(Qty; Rec.Qty)
                {
                    ApplicationArea = all;
                }
                field(UOM; Rec.UOM)
                {
                    ApplicationArea = all;
                }
                field(FX; Rec.FX)
                {
                    ApplicationArea = all;
                }
                field("FX Rate"; Rec."FX Rate")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost FX"; Rec."Unit Cost FX")
                {
                    ApplicationArea = all;
                }
                field("Total Cost FX"; Rec."Total Cost FX")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost AUD"; Rec."Unit Cost AUD")
                {
                    ApplicationArea = all;
                }
                field("Total Cost AUD"; Rec."Total Cost AUD")
                {
                    ApplicationArea = all;
                }
                field("Unit Landed Cost AUD"; Rec."Unit Landed Cost AUD")
                {
                    ApplicationArea = all;
                }
                field("Total Landed Cost AUD"; Rec."Total Landed Cost AUD")
                {
                    ApplicationArea = all;
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