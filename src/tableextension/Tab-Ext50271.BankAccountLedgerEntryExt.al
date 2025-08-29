tableextension 50271 TabExtBankAccLedgerEntry extends "Bank Account Ledger Entry"
{
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesPayments: Record "Sales Payments";

    procedure GetCCType() RetValueCCType: text;
    var
        DocNo: Code[20];
    begin
        Clear(RetValueCCType);
        if Rec."External Document No." <> '' then begin
            SalesInvHeader.Reset;
            SalesInvHeader.SetFilter(SalesInvHeader."Order No.", '<>%1', '');
            SalesInvHeader.Setrange(SalesInvHeader."No.", Rec."External Document No.");
            if SalesInvHeader.FindFirst() then
                DocNo := SalesInvHeader."Order No."
            else
                DocNo := Rec."External Document No.";

            SalesPayments.Reset;
            SalesPayments.Setrange(SalesPayments."Document No.", DocNo);
            if SalesPayments.FindFirst() then begin
                RetValueCCType := Format(SalesPayments."Card Type");
            end;
        end;
        exit(RetValueCCType);
    end;

    procedure GetCCMachine() RetValueCCMachine: text;
    var
        DocNo: Code[20];
    begin
        Clear(RetValueCCMachine);
        if Rec."External Document No." <> '' then begin
            SalesInvHeader.Reset;
            SalesInvHeader.SetFilter(SalesInvHeader."Order No.", '<>%1', '');
            SalesInvHeader.Setrange(SalesInvHeader."No.", Rec."External Document No.");
            if SalesInvHeader.FindFirst() then
                DocNo := SalesInvHeader."Order No."
            else
                DocNo := Rec."External Document No.";

            SalesPayments.Reset;
            SalesPayments.Setrange(SalesPayments."Document No.", DocNo);
            if SalesPayments.FindFirst() then begin
                RetValueCCMachine := Format(SalesPayments.Machine);
            end;
        end;
        exit(RetValueCCMachine);
    end;

}
