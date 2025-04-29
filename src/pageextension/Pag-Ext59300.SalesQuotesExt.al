pageextension 59300 PagExtSalesQuotes extends "Sales Quotes"
{
    layout
    {
        addafter("No.")
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
            field("Lost Opportunity"; Rec."Lost Opportunity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lost Opportunity field.', Comment = '%';
            }
        }
        modify("Assigned User ID")
        {
            Visible = True;
        }
        moveafter("Salesperson Code"; "Assigned User ID")
    }

    actions
    {
        // Add changes to page actions here
        addbefore(CreateTask)
        {
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink(Rec.Documents);
                end;
            }
        }
        addafter(CreateTask_Promoted)
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
        }
        addafter(AttachAsPDF)
        {
            action("Sales Quote")
            {
                Caption = 'Sales Quote';
                Image = Report;
                ToolTip = 'Print Sales Quote.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesQuoteReport: Report "Sales Quote";
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.SetRange("No.", Rec."No.");
                    SalesHeader.FindFirst();
                    SalesQuoteReport.SetTableView(SalesHeader);
                    SalesQuoteReport.Run();
                end;
            }
        }
        addafter(AttachAsPDF_Promoted)
        {
            actionref("Sales_Quote_Promoted"; "Sales Quote")
            {
            }
        }
        addafter(Email)
        {
            action(SendProformaByEmail)
            {
                Caption = 'Email Proforma';
                Visible = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesEvents: Codeunit "Extention for Sales Subscriber";
                begin
                    SalesEvents.SendEmailProforma(Rec);
                end;
            }
        }
        addafter(Email_Promoted)
        {
            actionref(EmailProforma_Promoted; SendProformaByEmail)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange("Quote Valid Until Date", Today, CalcDate('+10Y', Today));
    end;
}
