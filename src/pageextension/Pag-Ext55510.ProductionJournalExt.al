pageextension 55510 PagExtProductionJournal extends "Production Journal"
{
    layout
    {
        addafter("Operation No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the order that created the entry.';
            }
        }
    }
}
