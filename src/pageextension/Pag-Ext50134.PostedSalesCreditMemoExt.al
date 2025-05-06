pageextension 50134 PagExtPostedSalesCreditMemo extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Refund Type"; Rec."Refund Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Refund Type field.', Comment = '%';
            }
            field(Documents; Rec.Documents)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents field.', Comment = '%';
            }
        }
        addlast(General)
        {
            group("Sales Return Order")
            {
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned User ID field.', Comment = '%';
                }
                field("Method Of Enquiry"; Rec."Method Of Enquiry")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Method Of Enquiry field.', Comment = '%';
                }
                field("Sales Return Created By"; Rec."Sales Return Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Return Created By field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        addafter("Update Document")
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
        }
        addafter("Update Document_Promoted")
        {
            actionref("OpenDocs_Promoted"; OpenDocument)
            {
            }
        }
    }
}
