page 50108 "Sales Payments"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Sales Payments';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Sales Payments";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                    Visible = False;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                    Visible = False;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = False;
                }
                field("Processed By"; Rec."Processed By")
                {
                    ToolTip = 'Specifies the value of the Processed By field.', Comment = '%';
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ToolTip = 'Specifies the value of the Payment Date field.', Comment = '%';
                }
                field("Card Type"; Rec."Card Type")
                {
                    ToolTip = 'Specifies the value of the Card Type field.', Comment = '%';
                }
                field(Machine; Rec.Machine)
                {
                    ToolTip = 'Specifies the value of the Machine field.', Comment = '%';
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ToolTip = 'Specifies the value of the Amount Paid field.', Comment = '%';
                }
                field("Payment Processed"; Rec."Payment Processed")
                {
                    ToolTip = 'Specifies the value of the Payment Processed field.', Comment = '%';
                }
                field("Apply to this Invoice"; Rec."Apply to this Invoice")
                {
                    ToolTip = 'Specifies the value of the Apply to this Invoice field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Process Payment")
            {
                ApplicationArea = All;
                Image = Payroll;
                Enabled = Not Rec."Payment Processed";
                trigger OnAction()
                begin
                    Rec.CreateandPostPayReceipt();
                end;
            }
        }
        area(Promoted)
        {
            actionref(ProcessPayment_Promoted; "Process Payment")
            {
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Apply to this Invoice" := True;
    end;
}
