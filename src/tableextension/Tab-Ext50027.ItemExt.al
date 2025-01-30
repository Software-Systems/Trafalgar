tableextension 50027 TabExtItem extends Item
{
    fields
    {
        field(50100; "Long Description"; Text[250])
        {
            Caption = 'Long Description';
            DataClassification = CustomerContent;
        }
        field(53010; "User Prompt"; Text[250])
        {
            Caption = 'User Prompt';
            DataClassification = CustomerContent;
        }

    }
}
