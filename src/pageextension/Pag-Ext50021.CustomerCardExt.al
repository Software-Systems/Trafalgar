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
        addafter(ABN)
        {
            field(NZBN; Rec.NZBN)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NZBN field.', Comment = '%';
            }
        }
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
            field("Accounts E-Mail Address"; Rec."Accounts Email Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account E-Mail field.', Comment = '%';
            }
        }
        addafter(General)
        {
            part(UserTaskLines; "TG User Task Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Customer No." = field("No.");
                UpdatePropagation = Both;
            }
        }
        modify("Shipment Method Code")
        {
            ShowMandatory = True;
        }
    }

    actions
    {
        addafter(Email)
        {
            /*
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.SharepointOpenDocsCustomer;
                end;
            }
            */
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
            // actionref("Open_Docs_Promoted"; OpenDocument)
            // {
            // }
        }
    }
    var
        Editable_Boolean: Boolean;

    /*
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."Shipment Method Code" = '' then
            Error('Please fill up Shipment Method Code For Customer : \%1 - %2', Rec."No.", Rec.Name);
    end;
    */

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