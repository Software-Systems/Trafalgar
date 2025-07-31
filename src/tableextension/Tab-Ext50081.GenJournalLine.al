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


}