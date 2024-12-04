pageextension 50044 PagExtSalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter(ApplyEntries)
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
        addafter(ApplyEntries_Promoted)
        {
            actionref("OpenDocs_Promoted"; OpenDocument)
            {
            }
        }
    }
}