pageextension 50381 PagExtApplyBankAccLedgEntries extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addbefore(Open)
        {
            field("CC Machine"; CCMachine)
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("CC Type"; CCType)
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Clear(CCMachine);
        Clear(CCType);
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", rec."External Document No.");
        if SalesHeader.FindFirst() then begin
            CCType := SalesHeader."CC Card Type";
            CCMachine := SalesHeader."CC Machine";
        end else begin
            SalesInvHeader.Reset();
            SalesInvHeader.SetRange("Order No.", rec."External Document No.");
            if SalesInvHeader.FindFirst() then begin
                CCType := SalesInvHeader."CC Card Type";
                CCMachine := SalesInvHeader."CC Machine";
            end;
        end;
    end;

    var
        CCType: Text;
        CCMachine: Text;
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
}
