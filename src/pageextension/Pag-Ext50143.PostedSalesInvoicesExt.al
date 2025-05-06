pageextension 50143 PagExtPostedSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Order No.")
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
            field("Sales Order Created By"; Rec."Sales Order Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Created By field.', Comment = '%';
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
