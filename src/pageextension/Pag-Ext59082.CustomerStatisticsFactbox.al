pageextension 59082 PagExtCustomerStatisticsFB extends "Customer Statistics FactBox"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field(RemainingCreditLCY; RemainingCreditLCY)
            {
                Caption = 'Remaining Credit (LCY)';
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Rec."Balance (LCY)");
        RemainingCreditLCY := Rec."Credit Limit (LCY)" - Rec."Balance (LCY)";
        if RemainingCreditLCY < 0 then
            RemainingCreditLCY := 0;
    end;

    var
        RemainingCreditLCY: Decimal;
}