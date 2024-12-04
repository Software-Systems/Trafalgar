pageextension 50051 PagExtPurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        addafter(Status)
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
        addafter(Approvals)
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
        addafter(Approvals_Promoted)
        {
            actionref(OpenDoc_promoted; OpenDocument)
            {
            }
        }
    }
}
