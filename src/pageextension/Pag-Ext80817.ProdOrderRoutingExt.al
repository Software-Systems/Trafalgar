pageextension 80817 PagExtProdOrderRouting extends "Prod. Order Routing"
{
    layout
    {
        addbefore("Run Time")
        {
            field("Input Quantity"; Rec."Input Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Input Quantity field.', Comment = '%';
            }
        }
        addafter("Run Time")
        {
            field("Default Run Time"; Rec.GetDefaultRunTime)
            {
                ApplicationArea = All;
                Style = Strong;
            }
            field("Calculated Run Time"; Rec."Input Quantity" * Rec.GetDefaultRunTime)
            {
                ApplicationArea = All;
                Style = Strong;
            }
            field("Difference Run Time"; ABS((Rec."Input Quantity" * Rec.GetDefaultRunTime) - Rec."Run Time"))
            {
                ApplicationArea = All;
                StyleExpr = SetStyleTxt;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        SetStyleTxt := Rec.SetStyle();
    end;

    var
        SetStyleTxt: Text;
}
