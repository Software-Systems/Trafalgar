pageextension 50041 PagExtSalesQuote extends "Sales Quote"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = False;
            Editable = False;
        }
        addafter("Salesperson Code")
        {
            field(AssignedUserID; AssignedUserID)
            {
                Caption = 'Assigned User ID';
                ApplicationArea = all;
                Style = StrongAccent;
                TableRelation = "User Setup"."User ID" where("Sales Doc Assigned" = const(true));
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    Rec."Assigned User ID" := AssignedUserID;
                end;
            }
        }
        addafter(Status)
        {
            field("Method Of Enquiry"; Rec."Method Of Enquiry")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
            field("Quote Created By"; Rec."Quote Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Created By field.', Comment = '%';
                Editable = false;
            }
            field("Lost Opportunity"; Rec."Lost Opportunity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lost Opportunity field.', Comment = '%';
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("Quote Reason Code"; Rec."Quote Reason Code")
            {
                ApplicationArea = All;
                Caption = 'Lost Reason'; // Updated caption
                Editable = Rec."Lost Opportunity";
                ToolTip = 'Specifies the value of the Lost Reason field.', Comment = '%';
            }
        }
    }
    actions
    {
        // Add changes to page actions here
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
        addbefore("Create &Task")
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
            action(OpenMaps)
            {
                Caption = 'Open in Google Map';
                Image = OpenJournal;
                ToolTip = 'Opens Google Map.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink('https://www.google.com.au/maps/place/' +
                    ReplaceSpecialCharsWithSpaces(Rec."Ship-to Address") + '+' + ReplaceSpecialCharsWithSpaces(Rec."Ship-to Address 2") + '+' + ReplaceSpecialCharsWithSpaces(Rec."Ship-to City") + '+' + ReplaceSpecialCharsWithSpaces(Rec."Ship-to County") + '+' + Rec."Ship-to Post Code");
                end;
            }
        }
        addafter("Archive Document_Promoted")
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
            action("ProFormaInvoice")
            {
                Caption = 'Proforma Invoice';
                Image = Report;
                ToolTip = 'Print Proforma Invoice.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesQuoteReport: Report "Trafalgar Pro Froma Invoice";
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
            actionref("Proforma_Promoted"; "ProFormaInvoice")
            {
            }
            actionref("Open_Maps_Promoted"; OpenMaps)
            {
            }
        }
    }
    procedure ReplaceSpecialCharsWithSpaces(var _Text: Text[100]): Text[100]
    var
        i: Integer;
        Ch: Char;
    begin
        for i := 1 to StrLen(_Text) do begin
            Ch := _Text[i];
            if not IsAlphaNumeric(Ch) then begin
                _Text[i] := ' ';
            end;
        end;
        exit(_Text)
    end;

    procedure IsAlphaNumeric(Char: Char): Boolean
    begin
        if (Char >= 'A') and (Char <= 'Z') then
            exit(true);
        if (Char >= 'a') and (Char <= 'z') then
            exit(true);
        if (Char >= '0') and (Char <= '9') then
            exit(true);
        exit(false);
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        TrafalgarGenCodeunit: Codeunit "Trafalgar General Codeunit";
    begin
        NoStockMessage := Rec.CheckInStockQuantity;
        if Rec."No." <> xRec."No." then begin
            if NoStockMessage <> '' then
                Message('%1', NoStockMessage);

            if Customer.Get(Rec."Bill-to Customer No.") then
                TrafalgarGenCodeunit.PopUpCustomerImportantNotes(Customer."Important Notes");
        end;
        AssignedUserID := Rec."Assigned User ID";
    end;



    var
        NoStockMessage: Text;
        AssignedUserID: Code[50];
}