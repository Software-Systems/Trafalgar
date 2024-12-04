pageextension 59304 PagExtSalesReturnOrderList extends "Sales Return Order List"
{
    actions
    {
        addafter("Get Posted Doc&ument Lines to Reverse")
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
        addafter("Get Posted Doc&ument Lines to Reverse_Promoted")
        {
            actionref("OpenDocs_Promoted"; OpenDocument)
            {
            }
        }
    }
}
