pageextension 50050 PagExtPurchaseOrder extends "Purchase Order"
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
        addafter("Archive Document")
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
                begin
                    if Rec.Documents = '' then
                        Rec.Documents := TrafalgarSharepointCodeunit.OpenSharepointDocument(38, Rec."No.");
                    Hyperlink(Rec.Documents);
                end;
            }
        }
        addafter("Archive Document_Promoted")
        {
            actionref(OpenDoc_promoted; OpenDocument)
            {
            }
        }
    }
}
