report 50119 VendorRemitStatementBody
{
    ApplicationArea = All;
    Caption = 'VendorRemitStatementBody';
    UsageCategory = Lists;
    DefaultRenderingLayout = "EmailStatementBody.docx";
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            column(No_Vendor; "No.")
            {
            }
        }
    }

    rendering
    {
        layout("EmailStatementBody.docx")
        {
            Type = Word;
            LayoutFile = '.\Reports\Layouts\VendorRemitStatmentBody.docx';
            Caption = 'Email Vendor Statement Body (Word)';
            Summary = 'The Standard Vendor Statement Body (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
}
