report 50111 "Invoice Email Notification"
{
    Caption = 'Invoice Email Notification';
    DefaultRenderingLayout = "EmailInvoice.docx";
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(No_SalesInvoiceHeader; "No.")
            {
            }
        }
    }
    rendering
    {
        layout("EmailInvoice.docx")
        {
            Type = Word;
            LayoutFile = '.\Reports\Layouts\StandardSalesInvoice.docx';
            Caption = 'Email Sales Invoice (Word)';
            Summary = 'The Standard Sales Invoice (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
}
