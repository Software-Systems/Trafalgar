report 50117 ChangeExtDocNo
{
    ApplicationArea = All;
    Caption = 'ChangeExtDocNo';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions =
        tabledata "Sales Invoice Header" = RIMD;
    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            trigger OnAfterGetRecord()
            begin
                SalesInvoiceHeader."External Document No." := DocumentNo;
                SalesInvoiceHeader."Modified By" := UserId;
                SalesInvoiceHeader.Modify(false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Change Document No.")
                {
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'New Document No.';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    var
        DocumentNo: Code[20];
}
