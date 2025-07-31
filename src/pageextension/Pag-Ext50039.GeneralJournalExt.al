pageextension 50039 PagExtGeneralJournal extends "General Journal"
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
        addafter(Reconcile)
        {
            action("Populate Journal No.")
            {
                Image = EditJournal;
                ApplicationArea = All;
                trigger OnAction()
                var
                    GJL: Record "Gen. Journal Line";
                    JournalNo: Code[20];
                    TempDocNo: Code[20];
                    Counter: Integer;
                begin
                    GJL.COPYFILTERS(Rec);
                    CurrPage.SETSELECTIONFILTER(GJL);
                    IF GJL.FINDSET THEN BEGIN
                        Counter := 0;
                        REPEAT
                            if GJL."Journal No." = '' then begin
                                if GJL."Document No." <> TempDocNo then
                                    JournalNo := TrafalgarSharepointCodeunit.GenerateJournalNo();
                                GJL."Journal No." := JournalNo;
                                GJL.Modify();
                                Counter := Counter + 1;

                                TempDocNo := GJL."Document No.";
                            end;
                        UNTIL GJL.NEXT = 0;
                        if Counter = 0 then
                            Message('There is no record Populated Journal No.')
                        else
                            Message('%1 Lines(s) Successfully Populated Journal No.', Counter);
                        CurrPage.Update();
                    END;
                end;
            }
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    if Rec."Journal No." = '' then
                        Rec."Journal No." := TrafalgarSharepointCodeunit.GenerateJournalNo();
                    TrafalgarSharepointCodeunit.OpenSharepointDocument(17, Rec."Journal No.");
                end;
            }
        }
        addafter(Reconcile_Promoted)
        {
            actionref(PopulateJournalNo_Promoted; "Populate Journal No.")
            {
            }
            actionref(OpenDocument_Promoted; OpenDocument)
            {
            }
        }
    }

    var
        TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";

}
