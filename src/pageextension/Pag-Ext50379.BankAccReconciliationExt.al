pageextension 50379 PagExtBankAccReconciliation extends "Bank Acc. Reconciliation"
{
    actions
    {
        // Add changes to page actions here
        modify(ImportBankStatement)
        {
            Visible = false;
        }
        addbefore("&Card")
        {
            action(ImportBankStatementCustomized)
            {
                Caption = 'Import Bank Statement';
                ApplicationArea = All;
                trigger OnAction()
                var
                    InS: InStream;
                    FileName: Text[100];
                    UploadMsg: Label 'Please choose the CSV file';
                    Item: Record Item;
                    LineNo: Integer;
                    BankAccRecLine: Record "Bank Acc. Reconciliation Line";
                    BankRecoLineNo: Integer;
                    AmountInt: Decimal;
                    Dbt: Text;
                    Crd: Text;
                    Balance: Text;
                    DebitAmt: Decimal;
                    CreditAmt: Decimal;
                    TransDate: Date;
                begin
                    BankRecoLineNo := 10000;
                    BankAccRecLine.Reset();
                    BankAccRecLine.SetRange("Bank Account No.", Rec."Bank Account No.");
                    BankAccRecLine.SetRange("Statement No.", Rec."Statement No.");
                    if BankAccRecLine.FindFirst() then
                        Error('Please Delete Existing Bank Reconciliation Line');
                    CSVBuffer.Reset();
                    CSVBuffer.DeleteAll();
                    if UploadIntoStream(UploadMsg, '', '', FileName, InS) then begin
                        CSVBuffer.LoadDataFromStream(InS, ',');
                        for LineNo := 2 to CSVBuffer.GetNumberOfLines() do begin
                            BankAccRecLine.Init();
                            BankAccRecLine.Validate("Bank Account No.", Rec."Bank Account No.");
                            BankAccRecLine.Validate("Statement No.", Rec."Statement No.");
                            BankAccRecLine."Statement Line No." := BankRecoLineNo;
                            BankAccRecLine.Insert(true);
                            Evaluate(TransDate, GetValueAtCell(LineNo, 1));
                            BankAccRecLine.Validate(BankAccRecLine."Transaction Date", TransDate);
                            BankAccRecLine.Description := CopyStr(GetValueAtCell(LineNo, 2), 1, 100);
                            Dbt := DelChr(GetValueAtCell(LineNo, 4));
                            Crd := DelChr(GetValueAtCell(LineNo, 5));
                            Balance := DelChr(GetValueAtCell(LineNo, 6));
                            if Dbt <> '' then
                                Evaluate(DebitAmt, Dbt)
                            else
                                DebitAmt := 0;
                            if Crd <> '' then
                                Evaluate(CreditAmt, Crd)
                            else
                                CreditAmt := 0;
                            if DebitAmt <> 0 then
                                DebitAmt := DebitAmt * -1;
                            BankAccRecLine.Validate("Statement Amount", DebitAmt + CreditAmt);
                            BankAccRecLine.Modify(true);
                            BankRecoLineNo := BankRecoLineNo + 10000;
                        end;
                    end;
                    Message('Imported Successfully');
                end;
            }
        }
        addbefore("&Card_Promoted")
        {
            actionref(ImportBankStatementCustomized_Pramoted; ImportBankStatementCustomized)
            { }
        }
    }

    var
        CSVBuffer: Record "CSV Buffer" temporary;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if CSVBuffer.Get(RowNo, ColNo) then
            exit(CSVBuffer.Value)
        else
            exit('');
    end;
}