codeunit 50108 SendVendorRemittance
{
    procedure SendVendorStatement(GenJnlline: Record "Gen. Journal Line")
    var
        EmailMessage: Codeunit "Email Message";
        Recipient: List of [Text];
        RecipientType: Enum "Email Recipient Type";
        Subject: Text;
        BodyTxt: Text;
        SubjectTxt: Label 'Vendor Remittance Advice %1', Comment = '%1= Statement No.';

    begin
        if RecipientEmailNotValid(GenJnlline."Account No.") then
            exit;
        Recipient.Add(GetReceipientEmail(GenJnlline."Account No."));
        Subject := StrSubstNo(SubjectTxt, GenJnlline."Document No.");
        GetBodyTextFromStatementReport(GenJnlline."Account No.", BodyTxt);
        EmailMessage.Create(Recipient, Subject, BodyTxt, true);
        GetStatementAttachment(GenJnlline, EmailMessage);
        SendEmail(EmailMessage);
    end;

    local procedure RecipientEmailNotValid(VendorNo: Code[20]): Boolean
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(VendorNo);
        if Vendor."E-Mail" = '' then
            exit(true);
    end;

    local procedure GetReceipientEmail(VendorNo: Code[20]): Text[80]
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(VendorNo);
        if Vendor."E-Mail" <> '' then
            exit(Vendor."E-Mail");
    end;

    local procedure GetStatementAttachment(GenJnlLine: Record "Gen. Journal Line"; var EmailMessage: Codeunit "Email Message")
    var
        AttachmentTempBlob: Codeunit "Temp Blob";
        GenJournalRecRef: RecordRef;
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        ReportParamenters: Text;
        AttachmentFileNameLbl: Label 'Remittance Advice %1.pdf', Comment = '%1 Statement No.';
    begin
        GenJournalRecRef := SetGenJnlRecordRef(GenJnlLine);
        AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
        Report.SaveAs(Report::"Trafalgar - Remittance Advice", '', ReportFormat::Pdf, AttachmentOutStream, GenJournalRecRef);
        AttachmentTempBlob.CreateInStream(AttachmentInstream);
        EmailMessage.AddAttachment(StrSubstNo(AttachmentFileNameLbl, GenJnlLine."Document No."), '', AttachmentInstream);
    end;

    local procedure GetBodyTextFromStatementReport(VendorNo: Code[20]; var _TextBody: Text)
    var
        StatementReport: Report VendorRemitStatementBody;
        Vendor: Record Vendor;
        Customer: Record Customer;
        CodeUnitTempBlob: Codeunit "Temp Blob";
        OutStreamHtml: OutStream;
        InStreamHtml: InStream;
        bReturn: Boolean;
    begin
        _TextBody := '';
        Vendor.Get(VendorNo);
        CodeUnitTempBlob.CreateOutStream(OutStreamHtml);
        StatementReport.SetTableView(Vendor);
        bReturn := StatementReport.SaveAs('', ReportFormat::Html, OutStreamHtml);
        if bReturn then begin
            CodeUnitTempBlob.CreateInStream(InStreamHtml);
            InStreamHtml.ReadText(_TextBody);
        end;
    end;

    procedure SetGenJnlRecordRef(_GEnJnl: Record "Gen. Journal Line") ReturnRecordRef: RecordRef
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Account No.", _GEnJnl."Account No.");
        GenJournalLine.SetRange("Account Type", GenJournalLine."Account Type"::Vendor);
        ReturnRecordRef.GetTable(GenJournalLine);
    end;

    local procedure SendEmail(var _EmailMessage: Codeunit "Email Message")
    var
        Email: Codeunit Email;
    begin
        Email.Send(_EmailMessage, Enum::"Email Scenario"::"Vendor Remittance");
    end;
}
