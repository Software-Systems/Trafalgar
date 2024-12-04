pageextension 56630 PagExtSalesReturnOrder extends "Sales Return Order"
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
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Archive Document")
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
        addafter("Archive Document_Promoted")
        {
            actionref("OpenDocs_Promoted"; OpenDocument)
            {
            }
        }
    }
}
