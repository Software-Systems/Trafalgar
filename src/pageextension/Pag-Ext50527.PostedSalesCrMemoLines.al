pageextension 50527 PagExtPostedSalesCrMemoLines extends "Posted Sales Credit Memo Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                Caption = 'Reason Code';
                ApplicationArea = All;
            }
        }
    }
}
