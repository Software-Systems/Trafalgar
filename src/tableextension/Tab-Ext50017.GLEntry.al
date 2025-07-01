tableextension 50017 TabExtGLEntry extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(51010; "Journal No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = False;
        }
    }
}