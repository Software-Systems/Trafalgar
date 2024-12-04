page 61001 "Statement Date Period"
{
    ApplicationArea = All;
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Send)
            {
                Image = SendEmailPDF;
                trigger OnAction()
                begin
                    if StartDate > EndDate then
                        Error('Start Date Cant Be Later Than End Date');

                    if Customer.Get(CustomerNo) then
                        SendCustomerStatements.SendCustomerStatement(Customer, False, StartDate, EndDate);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Send_Promoted; Send)
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        StartDate := CalcDate('<-CM>', WorkDate());
        EndDate := CalcDate('<CM>', StartDate);
    end;

    Var
        StartDate: Date;
        EndDate: Date;
        SendCustomerStatements: Codeunit SendCustomerStatements;
        CustomerNo: Code[20];
        Customer: Record Customer;

    procedure SetPar(ParCustomerNo: Code[20])
    begin
        CustomerNo := ParCustomerNo;
    end;
}
