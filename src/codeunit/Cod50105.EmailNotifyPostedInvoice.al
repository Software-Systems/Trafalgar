codeunit 50105 "EmailNotify_PostedInvoice"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', true, true)]
    local procedure OnAfterPostSalesDoc(SalesInvHdrNo: Code[20])
    var
        SalesInvHeader: Record "Sales Invoice Header";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.GetRecordOnce();
        if GeneralLedgerSetup."Auto Send Invoice on Posting" then begin
            if SalesInvHeader.Get(SalesInvHdrNo) then
                SendInvoiceNotification(SalesInvHeader);
        end;
    end;

    procedure SendInvoiceNotification(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        EmailMessage: Codeunit "Email Message";
        Recipient: List of [Text];
        RecipientType: Enum "Email Recipient Type";
        Subject: Text;
        BodyTxt: Text;
        SubjectTxt: Label 'Trafalgar Invoice %1', Comment = '%1=Invoice No.';

    begin
        if RecipientEmailNotValid(SalesInvoiceHeader) then
            exit;
        Recipient.Add(GetReceipientEmail(SalesInvoiceHeader));
        //EmailMessage.AddRecipient(RecipientType::Cc, 'accounts@tgroup.com.au');
        EmailMessage.AddRecipient(RecipientType::Cc, 'nev@softwaresystems.com.au');
        Subject := StrSubstNo(SubjectTxt, SalesInvoiceHeader."No.");
        GetBodyTextFromInvoiceReport(SalesInvoiceHeader, BodyTxt);
        EmailMessage.Create(Recipient, Subject, BodyTxt, true);
        GetInvoiceAttachment(SalesInvoiceHeader, EmailMessage);
        SendEmail(EmailMessage);
    end;

    local procedure RecipientEmailNotValid(var SalesInvHdr: Record "Sales Invoice Header"): Boolean
    var
        Customer: Record Customer;
    begin
        Customer.Get(SalesInvHdr."Sell-to Customer No.");
        if Customer."E-Mail" = '' then
            exit(true);
    end;

    local procedure GetInvoiceAttachment(SalesInvHdr: Record "Sales Invoice Header"; var EmailMessage: Codeunit "Email Message")
    var
        AttachmentTempBlob: Codeunit "Temp Blob";
        InvoiceRecRef: RecordRef;
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        AttachmentFileNameLbl: Label 'Invoice %1.pdf', Comment = '%1 Invoice No.';
    begin
        InvoiceRecRef := SetSalesInvoiceRecordRef(SalesInvHdr);
        AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
        Report.SaveAs(Report::"Trafalgar Sales - Invoice", '', ReportFormat::Pdf, AttachmentOutStream, InvoiceRecRef);
        AttachmentTempBlob.CreateInStream(AttachmentInstream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, SalesInvHdr."No."), '', AttachmentInstream);
    end;

    local procedure GetReceipientEmail(var SalesInvHdr: Record "Sales Invoice Header"): Text[80]
    var
        Customer: Record Customer;
    begin
        Customer.Get(SalesInvHdr."Sell-to Customer No.");
        if Customer."E-Mail" <> '' then
            exit(Customer."E-Mail");
    end;

    local procedure GetBodyTextFromInvoiceReport(var _SalesInvoiceHdr: Record "Sales Invoice Header"; var _TextBody: Text)
    var
        InvoiceNotificationReport: Report "Invoice Email Notification";
        CodeUnitTempBlob: Codeunit "Temp Blob";
        OutStreamHtml: OutStream;
        InStreamHtml: InStream;
        bReturn: Boolean;

    begin
        _TextBody := '';
        CodeUnitTempBlob.CreateOutStream(OutStreamHtml);
        InvoiceNotificationReport.SetTableView(_SalesInvoiceHdr);
        bReturn := InvoiceNotificationReport.SaveAs('', ReportFormat::Html, OutStreamHtml);
        if bReturn then begin
            CodeUnitTempBlob.CreateInStream(InStreamHtml);
            InStreamHtml.ReadText(_TextBody);
        end;
    end;

    procedure SetSalesInvoiceRecordRef(_SalesInvHeader: Record "Sales Invoice Header") ReturnRecordRef: RecordRef
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.SetRange("No.", _SalesInvHeader."No.");
        SalesInvHeader.Findfirst();
        ReturnRecordRef.GetTable(SalesInvHeader);
    end;

    local procedure SendEmail(var _EmailMessage: Codeunit "Email Message")
    var
        Email: Codeunit Email;
    begin
        Email.Send(_EmailMessage, Enum::"Email Scenario"::Default);
    end;
}
