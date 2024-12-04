pageextension 50516 PagExtSalesLines extends "Sales Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field(CustomerName; CustomerName)
            {
                Caption = 'Customer Name';
                ApplicationArea = all;
            }
        }
    }
    var
        CustomerName: Text[100];

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        Clear(CustomerName);
        if Customer.Get(Rec."Sell-to Customer No.") then
            CustomerName := Customer.Name;
    end;
}
