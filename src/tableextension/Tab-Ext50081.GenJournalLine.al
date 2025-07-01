tableextension 50081 TabExtGenJournalLine extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(51010; "Journal No."; Code[20])
        {
            DataClassification = CustomerContent;
            //Editable = False;
        }
    }

    procedure GenerateJournalNo() JournalNo: Code[20];
    var
        GLSetup: Record "General Ledger Setup";
        NoSeries: Codeunit "No. Series";
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GLSetup.Get;
        GLSetup.TestField("Sharepoint GLEntries Nos.");
        JournalNo := NoSeries.GetNextNo(GLSetup."Sharepoint GLEntries Nos.", WorkDate, TRUE);
        exit(JournalNo);
    end;
}