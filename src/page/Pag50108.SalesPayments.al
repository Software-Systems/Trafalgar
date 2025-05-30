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

    var
        DocType: Enum "Sales Document Type";
        DocNo: Code[20];

    trigger OnOpenPage()
    begin
        if DocNo <> '' then begin
            Rec.Setrange("Document Type", DocType);
            Rec.SetRange("Document No.", DocNo);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Apply to this Invoice" := True;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SalesPayments: Record "Sales Payments";
    begin
        SalesPayments.Reset;
        SalesPayments.Setrange(SalesPayments."Document Type", Rec."Document Type");
        SalesPayments.Setrange(SalesPayments."Document No.", Rec."Document No.");
        SalesPayments.Setrange(SalesPayments."Payment Processed", False);
        if SalesPayments.FindFirst() then begin
            IF Confirm('Theres is a Payment that has not been processed. Are you sure you want to Navigate away from the Page?') then
                exit
            else
                Error('Please Process The Payment for Line No. %1.', SalesPayments."Line No.");
        end;
    end;

    procedure SetPar(ParDocType: Enum "Sales Document Type"; ParDocNo: Code[20])
    begin
        DocType := ParDocType;
        DocNo := ParDocNo;
    end;
}
