pageextension 50140 PagExtPostedPurchaseCrMemo extends "Posted Purchase Credit Memo"
{
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents field.', Comment = '%';
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

                        FileURL := TrafalgarSharepointCodeunit.OpenSharepointDocument(38, DocNo);
                    end
                    else
                        FileURL := Rec.Documents;
                    Hyperlink(FileURL);
                end;
            }
        }
        addafter("Update Document_Promoted")
        {
            actionref(OpenDoc_promoted; OpenDocument)
            {
            }
        }
    }
}
