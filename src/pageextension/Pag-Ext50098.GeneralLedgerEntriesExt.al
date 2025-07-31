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
                    JournalNo: Text;
                begin
                    if Rec."Journal No." = '' then
                        JournalNo := TrafalgarSharepointCodeunit.UpdateGLEntryJournalNo(Rec."Entry No.")
                    else
                        JournalNo := Rec."Journal No.";
                    TrafalgarSharepointCodeunit.OpenSharepointDocument(17, JournalNo);
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

    var
        TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";
}
