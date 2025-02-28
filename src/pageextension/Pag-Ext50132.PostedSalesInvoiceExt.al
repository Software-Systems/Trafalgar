pageextension 50132 PagExtPostedSalesInvoice extends "Posted Sales Invoice"
{

    layout
    {
        // Add changes to page layout here
        addafter(Closed)
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
            field("CC Processed By"; Rec."CC Processed By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Processed By field.', Comment = '%';
            }
            field("CC Payment Date"; Rec."CC Payment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Payment Date field.', Comment = '%';
            }
            field("CC Card Type"; Rec."CC Card Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Card Type field.', Comment = '%';
            }
            field("CC Machine"; Rec."CC Machine")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Machine field.', Comment = '%';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Modified By field.', Comment = '%';
            }
            field("Quote Created By"; Rec."Quote Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Created By field.', Comment = '%';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Customer)
        {
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink(Rec.Documents);
                end;
            }
            action(EditExtDocNo)
            {
                Caption = 'Change Ext. Doc. No.';
                Image = OpenJournal;
                ToolTip = 'change External Document No.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    ChangeReport: Report ChangeExtDocNo;
                begin
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    if SalesInvHeader.FindFirst() then begin
                        ChangeReport.SetTableView(SalesInvHeader);
                        ChangeReport.Run();
                    end;
                end;
            }
        }
        addafter("ChangePaymentService_Promoted")
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
            actionref("Change_Doc_Promoted"; EditExtDocNo)
            {
            }
        }
    }

    var
        myInt: Integer;
}