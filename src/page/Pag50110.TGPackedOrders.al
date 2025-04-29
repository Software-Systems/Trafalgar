page 50110 "TG Packed Orders"
{
    ApplicationArea = All;
    Caption = 'Packed Orders';
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order), "Packed Location" = filter(<> ''));
    UsageCategory = Lists;
    InsertAllowed = False;
    DeleteAllowed = False;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                }
                field("Packed Location"; Rec."Packed Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Packed Location field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("Sell-to Customer Name");
        Rec.Ascending(True);
        if Rec.FindFirst() then;
    end;

}
