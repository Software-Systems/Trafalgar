pageextension 50020 PagExtGeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Journal No."; Rec."Journal No.")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                ToolTip = 'Specifies the value of the Journal No. field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter("&Navigate")
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
                    TrafalgarSharepointCodeunit.OpenSharepointDocument(17, Rec."Journal No.");
                end;
            }
        }
        addafter("&Navigate_Promoted")
        {
            actionref(OpenDocument_Promoted; OpenDocument)
            {
            }
        }
    }
}
