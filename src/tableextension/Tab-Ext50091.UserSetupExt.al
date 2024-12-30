tableextension 50091 TabExtUserSetup extends "User Setup"
{
    fields
    {
        field(50100; "Can Reprocess Payment"; Boolean)
        {
            Caption = 'Can Reporcess Payment';
            DataClassification = CustomerContent;
        }
        field(50101; "Can Always Release CIA orders"; Boolean)
        {
            Caption = 'Can Always Release CIA orders';
            DataClassification = CustomerContent;
        }
        field(50102; "Can Change Account Customer"; Boolean)
        {
            Caption = 'Can Change Account Customer';
            DataClassification = CustomerContent;
        }
        field(50103; "Can Release Order for Overdue"; Boolean)
        {
            Caption = 'Can Release Order for Overdue Cust Entries';
            DataClassification = CustomerContent;
        }
    }
}
