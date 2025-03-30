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
        addafter("No.")
        {
            field("Product Code"; Rec."Product Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product Code field.';
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
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
