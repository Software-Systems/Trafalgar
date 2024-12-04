tableextension 78004 TabExtCounty extends County
{
    fields
    {
        field(50100; "Shipping Location"; Code[20])
        {
            Caption = 'Shipping Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
    }
}
