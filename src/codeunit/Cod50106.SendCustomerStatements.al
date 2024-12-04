codeunit 50106 SendCustomerStatements
{
    trigger OnRun()
    var
        Customer: Record Customer;

    begin
        Customer.SetRange("Send Statements", true);
        if Customer.FindSet() then
            repeat
                Customer.CalcFields("Balance (LCY)");
                if Customer."Balance (LCY)" <> 0 then
                    SendCustomerStatement(Customer, True, GetSOADatePeriod(Customer."No.", True), GetSOADatePeriod(Customer."No.", False));
            until Customer.Next() = 0;
    end;

    procedure GetSOADatePeriod(ParCustomerNo: Code[20]; IsStartDate: Boolean) RetValueDate: Date
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        StartDate: Date;
        EndDate: Date;
    begin
        CustLedgerEntry.Reset;
        CustLedgerEntry.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
        CustLedgerEntry.SETRANGE(CustLedgerEntry."Customer No.", ParCustomerNo);
        //CustLedgerEntry.Setrange(CustLedgerEntry.Open, True);
        if CustLedgerEntry.FindFirst() then begin
            StartDate := CustLedgerEntry."Posting Date";
            EndDate := CalcDate('<-1D>', TODAY);
            if EndDate < StartDate then
                EndDate := StartDate;
        end;

        if IsStartDate = true then
            RetValueDate := StartDate
        else
            RetValueDate := EndDate;

        exit(RetValueDate);
    end;

    procedure SendCustomerStatement(Customer: Record Customer;
        ParOpenOnly: Boolean;
        ParStartDate: Date;
        ParEndDate: Date)
    var
        EmailMessage: Codeunit "Email Message";
        Recipient: List of [Text];
        RecipientType: Enum "Email Recipient Type";
        Subject: Text;
        BodyTxt: Text;
        SubjectTxt: Label 'Customer Statement %1', Comment = '%1=Statement No.';
    begin
        if RecipientEmailNotValid(Customer) then
            exit;
        Recipient.Add(GetReceipientEmail(Customer));
        //EmailMessage.AddRecipient(RecipientType::Cc, 'nikhils@softwaresystems.com.au');
        Subject := StrSubstNo(SubjectTxt, Customer."No.");
        GetBodyTextFromStatementReport(Customer, BodyTxt);
        EmailMessage.Create(Recipient, Subject, BodyTxt, true);
        GetStatementAttachment(Customer, EmailMessage, ParOpenOnly, ParStartDate, ParEndDate);
        SendEmail(EmailMessage);
    end;

    local procedure RecipientEmailNotValid(Customer: Record Customer): Boolean
    begin
        if Customer."E-Mail" = '' then
            exit(true);
    end;

    local procedure GetStatementAttachment(Customer: Record Customer;
    var EmailMessage: Codeunit "Email Message"; ParOpenOnly: Boolean; ParStartDate: Date; ParEndDate: Date)
    var
        AttachmentTempBlob: Codeunit "Temp Blob";
        CustomerRecRef: RecordRef;
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        ReportParamenters: Text;
        AttachmentFileNameLbl: Label 'Statement %1.pdf', Comment = '%1 Statement No.';
        GotAttachment: Boolean;

        CustomerStatement: Report EmailCustomerStatement;
        PeriodLength: Text;
        StartDate: Date;
        EndDate: Date;
    begin
        PeriodLength := '<1M+CM>';
        CustomerRecRef := SetCustomerRecordRef(Customer);
        AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
        CustomerStatement.InitializeRequest(
                  TRUE,           //NewPrintEntriesDue: Boolean; 
                  FALSE,          //NewPrintAllHavingEntry: Boolean; 
                  TRUE,           //NewPrintAllHavingBal: Boolean; 
                  FALSE,          //NewPrintReversedEntries: Boolean; 
                  FALSE,          //NewPrintUnappliedEntries: Boolean;
                  TRUE,           //NewIncludeAgingBand: Boolean;
                  PeriodLength,   //NewPeriodLength: Text[30]; 
                  0,              //NewDateChoice: Option "Due Date","Posting Date"; 
                  FALSE,          //NewLogInteraction: Boolean; 
                  ParStartDate,      //NewStartDate: Date; 
                  ParEndDate,         //NewEndDate: Date
                  ParOpenOnly            //ParPrintOnlyOpen : Boolen;
              );
        /*
        GotAttachment := Report.SaveAs(Report::EmailCustomerStatement, '', ReportFormat::Pdf, AttachmentOutStream, CustomerRecRef);
        if GotAttachment then begin
            AttachmentTempBlob.CreateInStream(AttachmentInstream);
            EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, Customer."No."), '', AttachmentInstream);
        end
        */
        CustomerStatement.SETTABLEVIEW(Customer);
        CustomerStatement.SaveAs('', ReportFormat::Pdf, AttachmentOutStream, CustomerRecRef);
        AttachmentTempBlob.CreateInStream(AttachmentInstream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, Customer."No."), '', AttachmentInstream);
    end;

    local procedure GetReceipientEmail(Customer: Record Customer): Text[80]
    begin
        if Customer."E-Mail" <> '' then
            exit(Customer."E-Mail");
    end;

    local procedure GetBodyTextFromStatementReport(Customer: Record Customer; var _TextBody: Text)
    var
        StatementReport: Report CustomerStatementBody;
        CodeUnitTempBlob: Codeunit "Temp Blob";
        OutStreamHtml: OutStream;
        InStreamHtml: InStream;
        bReturn: Boolean;
    begin
        _TextBody := '';
        CodeUnitTempBlob.CreateOutStream(OutStreamHtml);
        StatementReport.SetTableView(Customer);
        bReturn := StatementReport.SaveAs('', ReportFormat::Html, OutStreamHtml);
        if bReturn then begin
            CodeUnitTempBlob.CreateInStream(InStreamHtml);
            InStreamHtml.ReadText(_TextBody);
        end;
    end;

    procedure SetCustomerRecordRef(_Customer: Record Customer) ReturnRecordRef: RecordRef
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("No.", _Customer."No.");
        Customer.Findfirst();
        ReturnRecordRef.GetTable(Customer);
    end;

    local procedure SendEmail(var _EmailMessage: Codeunit "Email Message")
    var
        Email: Codeunit Email;
    begin
        Email.Send(_EmailMessage, Enum::"Email Scenario"::"Customer Statement");
        //Email.OpenInEditorModally(_EmailMessage, Enum::"Email Scenario"::"Customer Statement");
    end;
}
