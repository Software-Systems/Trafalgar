pageextension 59304 PagExtSalesReturnOrderList extends "Sales Return Order List"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = True;
        }
        addafter("External Document No.")
        {
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
            }
        }
    }
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
