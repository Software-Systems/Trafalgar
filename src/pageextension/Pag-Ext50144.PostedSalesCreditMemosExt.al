pageextension 50144 PagExtPostedSalesCreditMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Sell-to Customer Name")
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
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason code for the document.';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter("Update Document")
        {
            /*
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
            */
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";
                    DocNo: Code[20];
                    FileURL: Text;
                begin
                    if Rec.Documents = '' then begin
                        if Rec."Return Order No." <> '' then
                            DocNo := Rec."Return Order No."
                        else
                            DocNo := Rec."No.";

                        FileURL := TrafalgarSharepointCodeunit.OpenSharepointDocument(36, DocNo);
                    end
                    else
                        FileURL := Rec.Documents;
                    Hyperlink(FileURL);
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
