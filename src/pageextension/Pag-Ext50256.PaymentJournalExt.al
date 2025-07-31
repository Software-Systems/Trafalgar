pageextension 50256 PagExtPaymentJournal extends "Payment Journal"
{

    actions
    {
        // Add changes to page actions here
        modify(CreateFile)
        {
            Visible = false;
        }
        modify(CreateFile_Promoted)
        {
            Visible = false;
        }
        modify(CancelExport)
        {
            Visible = false;
        }
        modify(CancelExport_Promoted)
        {
            Visible = false;
        }
        addafter(Reconcile)
        {
            action(CreateABAPaymentFile)
            {
                ApplicationArea = all;
                Caption = 'Create ABA Payment File';

                trigger OnAction()
                var
                begin
                    GeneratePaymentFileData();
                    GenerateTextData();
                    GenerateFile();
                end;
            }
            action(SendRemitAdvice)
            {
                ApplicationArea = all;
                Caption = 'Send Remit Consol';
                Image = SendEmailPDF;
                Visible = true;
                trigger OnAction()
                var
                    DocumentSendingProfile: Record "Document Sending Profile";
                    GenJournalLine: Record "Gen. Journal Line";
                    GenJournalLineFiltered: Record "Gen. Journal Line";
                    VendorRemittance: Report "Trafalgar - Remittance Advice";
                    ConfirmationMessage: Codeunit "Confirm Management";
                    SendVendorRemittance: Codeunit SendVendorRemittance;
                    VendorNo: Code[20];
                    EmailCount: Integer;
                begin
                    Clear(VendorNo);
                    Clear(EmailCount);
                    if ConfirmationMessage.GetResponse('Send all lines from the batch?', false) then begin
                        GenJournalLine.Copy(Rec);
                        GenJournalLine.SetCurrentKey("Account Type", "Account No.");
                        if GenJournalLine.FindSet() then
                            repeat
                                if VendorNo <> GenJournalLine."Account No." then begin
                                    GenJournalLineFiltered.Reset();
                                    GenJournalLineFiltered.SetRange("Account No.", GenJournalLine."Account No.");
                                    GenJournalLineFiltered.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                                    GenJournalLineFiltered.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                                    if GenJournalLineFiltered.FindSet() then begin
                                        SendVendorRemittance.SendVendorStatement(GenJournalLineFiltered);
                                    end;
                                    EmailCount += 1;
                                    VendorNo := GenJournalLine."Account No.";
                                end;
                            until GenJournalLine.Next() = 0;
                        Message('%1 Emails Sent', EmailCount);
                    end;
                end;
            }
        }
        addafter(CalculatePostingDate)
        {
            action(PaymentJournalApprovalReport)
            {
                ApplicationArea = all;
                Caption = 'Approval Report';
                Visible = false;

                trigger OnAction()
                var
                    PaymentFile: Record "Payment File Data";
                begin
                    GeneratePaymentFileData();
                    Report.RunModal(50105, false, false);
                    PaymentFile.Delete();
                end;
            }
        }
        addafter(Reconcile_Promoted)
        {
            actionref(CreateABAPaymentFile_Promoted; CreateABAPaymentFile)
            {
            }
            actionref(SendVendorRemit_promoted; SendRemitAdvice)
            {
            }
        }
        addafter(CalculatePostingDate_Promoted)
        {
            actionref(PaymentJournalApprovalReport_Promoted; PaymentJournalApprovalReport)
            {
                Visible = false;
            }
        }
    }

    var
        TotalAmount: Decimal;
        TotalLine: Integer;
        TotalAmountText: Text;

    procedure AppendSpace(Data: Text; TotalLen: Integer; CurrLen: Integer; LeftOrRight: Integer) ReturnData: Text
    var
        Difference: Integer;
        I: Integer;
    begin
        Difference := TotalLen - CurrLen;

        for I := 1 to difference do begin
            if LeftOrRight = 0 then // To append Space on Left
                Data := ' ' + Data;
            if LeftOrRight = 1 then // To append Space on Right
                Data := Data + ' ';
            if LeftOrRight = 2 then // To append Zero on Left
                Data := '0' + Data;
        end;
        exit(Data);
    end;

    procedure GenerateFile()
    var
        compInfo: Record "Company Information";
        PaymentFile: Record "Payment File Data";
        Tempblob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        DateText: Text;
        DayText: Text;
        FileName: Text;
        MonthText: Text;
        YearText: Text;
        TxtBuilder: TextBuilder;
    begin

        YearText := COPYSTR(FORMAT(DATE2DMY(Today, 3)), 3, 2);

        if STRLEN(FORMAT(DATE2DMY(Today, 2))) = 1 then
            MonthText := '0' + FORMAT(DATE2DMY(Today, 2))
        else
            MonthText := FORMAT(DATE2DMY(Today, 2));

        if STRLEN(FORMAT(DATE2DMY(Today, 1))) = 1 then
            DayText := '0' + FORMAT(DATE2DMY(Today, 1))
        else
            DayText := FORMAT(DATE2DMY(Today, 1));

        DateText := DayText + MonthText + YearText;

        TotalAmountText := AppendSpace(DelChr(DelChr((Format(TotalAmount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ','), 10, StrLen(DelChr(DelChr((Format(TotalAmount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ',')), 2);

        FileName := 'Payment_' + UserId + '_' + Format(CurrentDateTime) + '.ABA';
        compInfo.get();
        PaymentFile.Reset();
        TxtBuilder.AppendLine('0                 01CBA       Trafalgar Group           301500Batch' + DayText + MonthText + '   ' + DateText + '                                        ');
        if PaymentFile.FindSet() then
            repeat
                TxtBuilder.AppendLine(PaymentFile."Payment File Text");
            until PaymentFile.Next() = 0;
        //TxtBuilder.AppendLine('7999-999            ' + TotalAmountText + TotalAmountText + '0000000000                        ' + AppendSpace(Format(TotalLine), 6, StrLen(Format(TotalLine)), 2));
        TxtBuilder.AppendLine('7999-999            0000000000' + TotalAmountText + TotalAmountText + '                        ' + AppendSpace(Format(TotalLine), 6, StrLen(Format(TotalLine)), 2) + '                                        ');
        TempBlob.CreateOutStream(OutS);
        OutS.WriteText(TxtBuilder.ToText());
        TempBlob.CreateInStream(InS);
        DownloadFromStream(InS, '', '', '', FileName);

        Message('Done');
        PaymentFile.DeleteAll();
    end;

    procedure GeneratePaymentFileData()
    var
        GenJnlLine: Record "Gen. Journal Line";
        PaymentFile: Record "Payment File Data";
        PaymentFile1: Record "Payment File Data";
        PaymentFile2: Record "Payment File Data";
        vendor: Record Vendor;
        vendBankAcc: Record "Vendor Bank Account";
        EntryNo: Integer;
        BankBrach: Text[10];
    begin
        PaymentFile.DeleteAll();
        GenJnlLine.Reset();
        GenJnlLine.SetCurrentKey("Account No.");
        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJnlLine.FindSet() then
            repeat
                if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
                    vendor.Get(GenJnlLine."Account No.");
                    if vendor."EFT Bank Account No." = '' then
                        Error('Vendor %1 does not have a correct bank account.', vendor."No.")
                    else begin
                        vendBankAcc.Get(vendor."No.", vendor."EFT Bank Account No.");
                        if vendBankAcc."Bank Account No." = '' then
                            Error('Vendor %1 does not have a correct bank account.', vendor."No.");
                    end;
                end;
            until GenJnlLine.Next() = 0;


        GenJnlLine.Reset();
        GenJnlLine.SetCurrentKey("Account No.");
        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJnlLine.FindSet() then
            repeat
                if vendor.Get(GenJnlLine."Account No.") then;
                if vendBankAcc.Get(vendor."No.", vendor."EFT Bank Account No.") then;
                PaymentFile.Reset();
                PaymentFile.SetRange("Vendor No.", GenJnlLine."Account No.");
                if not PaymentFile.FindFirst() then begin
                    if PaymentFile2.FindLast() then
                        EntryNo := PaymentFile2."Entry No." + 1
                    else
                        EntryNo := 1;
                    BankBrach := '';
                    PaymentFile1.Init();
                    PaymentFile1."Entry No." := EntryNo;
                    PaymentFile1."Vendor No." := GenJnlLine."Account No.";
                    PaymentFile1.Amount := GenJnlLine.Amount;
                    PaymentFile1."Vendor Name" := vendor.Name;
                    if CopyStr(vendBankAcc."Bank Branch No.", 4, 1) <> '-' then
                        BankBrach := CopyStr(vendBankAcc."Bank Branch No.", 1, 3) + '-' + CopyStr(vendBankAcc."Bank Branch No.", 4, 3)
                    else
                        BankBrach := vendBankAcc."Bank Branch No.";
                    PaymentFile1."Vendor Bank Branch" := BankBrach;
                    PaymentFile1."Vendor Bank Account" := vendBankAcc."Bank Account No.";
                    PaymentFile1."Message to Recipient" := GenJnlLine."Message to Recipient";
                    PaymentFile1.Insert();
                end else begin
                    PaymentFile.Amount += GenJnlLine.Amount;
                    PaymentFile.Modify();
                end;
            until GenJnlLine.Next() = 0;
    end;

    procedure GenerateTextData()
    var
        paymentfileIns: Record "Payment File Data";
        PaymentOfInv: Text;
        TextData: Text[500];
    begin
        TotalAmount := 0;
        TotalLine := 0;
        if paymentfileIns.FindSet() then
            repeat
                PaymentOfInv := '';
                if CopyStr(paymentfileIns."Message to Recipient", 1, 18) = 'Payment of Invoice' then begin
                    PaymentOfInv := 'Trafalgar' + CopyStr(paymentfileIns."Message to Recipient", 19, StrLen(paymentfileIns."Message to Recipient") - 18);
                    PaymentOfInv := CopyStr(PaymentOfInv, 1, 18);
                    PaymentOfInv := AppendSpace(PaymentOfInv, 18, StrLen(PaymentOfInv), 1);
                end else
                    PaymentOfInv := AppendSpace(CopyStr(paymentfileIns."Message to Recipient", 1, 18), 18, StrLen(CopyStr(paymentfileIns."Message to Recipient", 1, 18)), 1);
                TextData := '1' + paymentfileIns."Vendor Bank Branch" + AppendSpace(paymentfileIns."Vendor Bank Account", 9, StrLen(paymentfileIns."Vendor Bank Account"), 0) + 'N50' + AppendSpace(DelChr(DelChr((Format(paymentfileIns.Amount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ','), 10, StrLen(DelChr(DelChr((Format(paymentfileIns.Amount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ',')), 2) + AppendSpace(CopyStr(paymentfileIns."Vendor Name", 1, 32), 32, StrLen(CopyStr(paymentfileIns."Vendor Name", 1, 32)), 1) + PaymentOfInv + '062-223 10979692Trafalgar Group 00000000';
                paymentfileIns."Payment File Text" := TextData;
                paymentfileIns.Modify();
                TotalAmount += paymentfileIns.Amount;
                TotalLine += 1;
            until paymentfileIns.Next() = 0;
    end;
}