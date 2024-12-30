pageextension 50021 PagExtCustomerCard extends "Customer Card"
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
        }
        // Add changes to page layout here
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Credit Limit (LCY)")
        {
            Editable = Editable_Boolean;
        }
        modify(ABN)
        {
            Editable = Editable_Boolean;
        }
        modify("IRD No.")
        {
            Editable = Editable_Boolean;
        }
        modify(Name)
        {
            Editable = Editable_Boolean;
        }
        modify("Payment Terms Code")
        {
            Editable = Editable_Boolean;
        }
        addafter(Blocked)
        {
            field("Send Statements"; Rec."Send Statements")
            {
                Caption = 'Send Email Statements';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Send Statements field.', Comment = '%';
            }
            field("Important Notes"; Rec."Important Notes")
            {
                Caption = 'Important Note';
                MultiLine = true;
                ApplicationArea = all;
            }

        }
        addafter("E-Mail")
        {
            field("Buyer Email Address"; Rec."Buyer Email Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Buyer E-Mail Address field.', Comment = '%';
            }
            field("Accounts E-Mail"; Rec."Accounts Email Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account E-Mail field.', Comment = '%';
            }
        }
    }

    actions
    {
        addafter(Email)
        {
            action(HistoricalSales)
            {
                ApplicationArea = All;
                Caption = 'Historical Sales';
                Image = PaymentHistory;
                ToolTip = 'View Historical Transactions.';
                RunObject = page "Historical Sales";
                RunPageLink = "Customer No." = field("No.");
            }
            action(EmailStatementOpen)
            {
                ApplicationArea = all;
                Caption = 'Email Statement (Open)';
                Image = Email;
                trigger OnAction()
                var
                    EmailCustomerStatement: Codeunit SendCustomerStatements;
                begin
                    EmailCustomerStatement.SendCustomerStatement
                    (
                    Rec,
                    True,
                    EmailCustomerStatement.GetSOADatePeriod(Rec."No.", True),
                    EmailCustomerStatement.GetSOADatePeriod(Rec."No.", False)
                    );
                end;
            }
            action(EmailStatementAll)
            {
                ApplicationArea = all;
                Caption = 'Email Statement (All)';
                Image = Email;
                trigger OnAction()
                var
                    //EmailCustomerStatement: Codeunit SendCustomerStatements;
                    PageStatementDatePeriod: Page "Statement Date Period";
                begin
                    Clear(PageStatementDatePeriod);
                    PageStatementDatePeriod.SetPar(Rec."No.");
                    PageStatementDatePeriod.RunModal();
                    //EmailCustomerStatement.SendCustomerStatement(Rec, False);
                end;

            }
        }
        addafter(Email_Promoted)
        {
            actionref(HistoricalSales_Promoted; HistoricalSales)
            {
            }
            actionref(EmailStatementOpen_Promoted; EmailstatementOpen)
            {
            }
            actionref(EmailStatementAll_Promoted; EmailstatementAll)
            {
            }

        }
    }
    var
        Editable_Boolean: Boolean;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        Editable_Boolean := false;
        UserSetup.Get(UserId);
        if (Rec."Payment Terms Code" = 'CIA') and (Rec."Payment Terms Code" <> '') then
            Editable_Boolean := true
        else
            Editable_Boolean := false;
        if UserSetup."Can Change Account Customer" then
            Editable_Boolean := true
    end;
}