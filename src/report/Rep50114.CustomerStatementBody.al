report 50114 CustomerStatementBody
{
    Caption = 'CustomerStatementBody';
    DefaultRenderingLayout = "EmailStatementBody.docx";
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_Customer; "No.")
            {
            }
        }
    }

    rendering
    {
        layout("EmailStatementBody.docx")
        {
            Type = Word;
            LayoutFile = '.\Reports\Layouts\CustomerStatment.docx';
            Caption = 'Email Customer Statement Body (Word)';
            Summary = 'The Standard Customer Statement Body (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
}
