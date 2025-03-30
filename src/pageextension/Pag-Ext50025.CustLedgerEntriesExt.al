pageextension 50025 PagExtCustLedgerEntries extends "Customer Ledger Entries"
{
    actions
    {
        // Add changes to page actions here
        addafter(Customer)
        {
            action("Payment Gen Journal")
            {
                ApplicationArea = All;
                Image = CashReceiptJournal;
                ToolTip = 'View which documents have been included in the payment.';

                trigger OnAction()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    Counter: Integer;
                    CustLedgerEntryNo: Text;
                    DocNo: Code[20];
                    GenJnlLine: Record "Gen. Journal Line";
                    JnlTemplateName: Text;
                    JnlBatchName: Text;
                    TempCustomerNo: Code[20];
                begin
                    JnlTemplateName := 'GENERAL';
                    JnlBatchName := 'BANK MAN';
                    CustLedgEntry.Setrange(CustLedgEntry.Open, True);
                    CustLedgEntry.COPYFILTERS(Rec);
                    CurrPage.SETSELECTIONFILTER(CustLedgEntry);
                    IF CustLedgEntry.FINDSET THEN BEGIN
                        Counter := 0;
                        REPEAT
                            if (TempCustomerNo <> '') AND (TempCustomerNo <> CustLedgEntry."Customer No.") then
                                Error('Customer %1 For Document No. %2 not equal to Previous Customer %3', CustLedgEntry."Customer No.", CustLedgEntry."Document No.", TempCustomerNo)
                            else begin
                                CustLedgerEntryNo := CustLedgerEntryNo + Format(CustLedgEntry."Entry No.") + '|';
                                Counter := Counter + 1;
                            end;
                            TempCustomerNo := CustLedgEntry."Customer No.";
                        UNTIL CustLedgEntry.NEXT = 0;
                        if CustLedgerEntryNo <> '' then begin
                            CustLedgerEntryNo := CopyStr(CustLedgerEntryNo, 1, StrLen(CustLedgerEntryNo) - 1);
                            DocNo := CreateGenJournal(JnlTemplateName, JnlBatchName, CustLedgerEntryNo);
                        end;

                        if DocNo = '' then
                            Message('There is no Document Created.')
                        else begin
                            GenJnlLine.Reset;
                            GenJnlLine.Setrange(GenJnlLine."Journal Template Name", JnlTemplateName);
                            GenJnlLine.Setrange(GenJnlLine."Journal Batch Name", JnlBatchName);
                            GenJnlLine.Setrange(GenJnlLine."Document No.", DocNo);
                            if GenJnlLine.Findfirst then begin
                                Message('%1 Successfully Created & Applied to %2 Record(s)', DocNo, Counter);
                                Page.Run(Page::"General Journal", GenJnlLine);
                                CurrPage.Close();
                            end;
                        end;
                    END;
                end;

            }
        }
        addafter(Customer_Promoted)
        {
            actionref(PaymentGenJournal_Promoted; "Payment Gen Journal")
            {

            }
        }
    }

    var
        CustLedgEntry: Record "Cust. Ledger Entry";

    procedure CreateGenJournal(
        ParJournalTemplateName: Text;
        ParJournalBatchName: Text;
        ParCustLedgEntryNo: Text) DocNoCreated: Code[20];
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        Employee: Record Employee;
        LastLineNo: Integer;
        Counter: Integer;
        DocumentNo: Code[20];
        TotalAmount: Decimal;
        NoSeries: Codeunit "No. Series";
    begin
        Counter := 0;

        GenJournalTemplate.Reset;
        GenJournalTemplate.SETRANGE(GenJournalTemplate.Name, ParJournalTemplateName);
        if GenJournalTemplate.findset then;

        GenJournalBatch.Reset;
        GenJournalBatch.SETRANGE(GenJournalBatch."Journal Template Name", ParJournalTemplateName);
        GenJournalBatch.SETRANGE(GenJournalBatch.Name, ParJournalBatchName);
        if GenJournalBatch.findset then;

        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", ParJournalTemplateName);
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", ParJournalBatchName);
        IF GenJournalLine.FINDLAST THEN
            LastLineNo := GenJournalLine."Line No."
        else
            LastLineNo := 0;

        CustLedgEntry.reset;
        CustLedgEntry.SetFilter(CustLedgEntry."Entry No.", ParCustLedgEntryNo);
        CustLedgEntry.SetCurrentKey("Customer No.");
        if CustLedgEntry.findset then begin
            BEGIN
                REPEAT
                    CustLedgEntry.CalcFields(CustLedgEntry."Remaining Amount", "Remaining Amt. (LCY)");
                    TotalAmount := TotalAmount - CustLedgEntry."Remaining Amt. (LCY)";
                until CustLedgEntry.Next() = 0;

                LastLineNo := LastLineNo + 10000;
                GenJournalLine."Journal Template Name" := ParJournalTemplateName;
                GenJournalLine."Journal Batch Name" := ParJournalBatchName;
                GenJournalLine."Line No." := LastLineNo;
                GenJournalLine."Document No." := NoSeries.GetNextNo(GenJournalBatch."No. Series", WorkDate());
                GenJournalLine.INSERT(TRUE);
                GenJournalLine.SetUpNewLine(GenJournalLine, 0, True);
                GenJournalLine.VALIDATE(GenJournalLine."Document Type", GenJournalLine."Document Type"::Payment);
                GenJournalLine.VALIDATE(GenJournalLine."Account Type", GenJournalLine."Account Type"::Customer);
                GenJournalLine.VALIDATE(GenJournalLine."Posting Date", WorkDate);
                GenJournalLine.VALIDATE(GenJournalLine."External Document No.", CustLedgEntry."Document No.");
                GenJournalLine.Validate(GenJournalLine."Account No.", CustLedgEntry."Customer No.");
                GenJournalLine.VALIDATE(GenJournalLine.Quantity, 1);
                GenJournalLine.VALIDATE(GenJournalLine.Amount, TotalAmount);
                GenJournalLine.MODIFY;
                SetAppliesToID(ParCustLedgEntryNo, GenJournalLine."Document No.");
                exit(GenJournalLine."Document No.");
            END;
        end;
    end;

    procedure SetAppliesToID(ParCustLedgerEntryNo: Text; ParDocNo: Code[20])
    var
        CLE: Record "Cust. Ledger Entry";
        CLEToApply: Record "Cust. Ledger Entry";
        CLE_SetApplID: Codeunit "Cust. Entry-SetAppl.ID";
    begin
        CLE.reset;
        CLE.setcurrentkey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        CLE.SetFilter(CLE."Entry No.", ParCustLedgerEntryNo);
        CLE.setrange("Open", true);
        if CLE.findset then begin
            repeat
                CLE.CalcFields("Remaining Amount");

                IF CLE."Applies-to ID" <> '' then begin
                    CLE.validate("Applies-to ID", '');
                    CLE.validate("Amount to Apply", 0);
                    CLE.modify(false);
                end;

                CLE.modify(false);

                CLEToApply.reset;
                CLEToApply.setrange("Entry No.", CLE."Entry No.");
                CLEAR(CLE_SetApplID);
                CLE_SetApplID.SetApplID(CLEToApply, CLE, ParDocNo);
            until (CLE.next = 0);
        end;
    end;

}