pageextension 50043 PagExtSalesInvoice extends "Sales Invoice"
{
    layout
    {

    }

    actions
    {
        // Add changes to page actions here
        addafter(CalculateInvoiceDiscount)
        {
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
                        Rec.Documents := TrafalgarSharepointCodeunit.OpenSharepointDocument(36, Rec."No.");
                    Hyperlink(Rec.Documents);
                end;
            }
        }

        addafter(CalculateInvoiceDiscount_Promoted)
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
        }
    }
}