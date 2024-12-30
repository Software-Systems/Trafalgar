tableextension 50023 TabExtVendor extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(52010; "Account Manager E-Mail"; Text[100])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Account Manager E-Mail" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Account Manager E-Mail");
            end;
        }
        field(52020; "Account E-Mail"; Text[100])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "Account E-Mail" = '' then
                    exit;
                MailManagement.CheckValidEmailAddresses("Account E-Mail");
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}