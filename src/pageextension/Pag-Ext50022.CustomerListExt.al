pageextension 50022 PagExtCustomerList extends "Customer List"
{
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.', Comment = '%';
            }
            field("Statement Last Sent Date"; Rec."Statement Last Sent Date")
            {
                Style = StrongAccent;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Statement Last Sent Date field.', Comment = '%';
            }
            field("Statement Error Message"; Rec."Statement Error Message")
            {
                Style = Unfavorable;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Statement Error Message field.', Comment = '%';
            }
        }
    }
    actions
    {
        // Add changes to page actions here

        addafter("Email")
        {
            action("Send Statement")
            {
                ApplicationArea = All;
                Image = SendEmailPDF;
                ToolTip = 'Send statement to selected customer(s)';
                trigger OnAction()
                var
                    Customer: Record Customer;
                    Counter: Integer;
                    IsSent: Boolean;
                begin
                    Customer.COPYFILTERS(Rec);
                    CurrPage.SETSELECTIONFILTER(Customer);
                    IF Customer.FINDSET THEN BEGIN
                        Counter := 0;
                        REPEAT
                            IsSent := CustomerStatementCodeunit.SendCustomerStatement(
                                Customer,
                                True,
                                CustomerStatementCodeunit.GetSOADatePeriod(Customer."No.", True),
                                CustomerStatementCodeunit.GetSOADatePeriod(Customer."No.", False)
                                );
                            if IsSent = True then
                                Counter := Counter + 1;
                        UNTIL Customer.NEXT = 0;
                        Message('%1 Record(s) Successfully Sent', Counter);
                    END;
                end;
            }
        }
        addafter(Email_Promoted)
        {
            actionref(SendStatement_Promoted; "Send Statement")
            {
            }
        }
    }

    var
        CustomerStatementCodeunit: Codeunit SendCustomerStatements;
}
