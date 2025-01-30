pageextension 59080 PagExtSalesHistSelltoFactBox extends "Sales Hist. Sell-to FactBox"
{
    layout
    {
        // Add changes to page layout here
        addbefore(NoofQuotesTile)
        {
            field("No. of Ongoing Quotes"; Rec."No. of Ongoing Quotes")
            {
                ApplicationArea = All;
                DrillDownPageID = "Sales Quotes";
                ToolTip = 'Specifies the value of the No. of Ongoing Quotes field.', Comment = '%';
            }
            field("No. of Lost Quotes"; Rec."No. of Lost Quotes")
            {
                ApplicationArea = All;
                DrillDownPageID = "Sales Quotes";
                ToolTip = 'Specifies the value of the No. of Lost Quotes field.', Comment = '%';
            }
        }
        modify(NoofQuotesTile)
        {
            Visible = False;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
