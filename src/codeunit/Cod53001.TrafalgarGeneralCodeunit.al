codeunit 53001 "Trafalgar General Codeunit"
{
    procedure GetUserNameFromSecurityId(ParUserSecurityID: Guid): Code[50]
    var
        User: Record User;
    begin
        IF User.Get(ParUserSecurityID) THEN
            exit(User."User Name")
        ELSE
            exit('');
    end;

    [EventSubscriber(ObjectType::Report, Report::"Suggest Vendor Payments", OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer, '', false, false)]
    procedure SuggestVendorPayments_OnBeforeUpdateGnlJnlLineDimensionsFromVendorPaymentBuffer(var GenJournalLine: Record "Gen. Journal Line"; TempVendorPaymentBuffer: Record "Vendor Payment Buffer" temporary)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CompInfo: Record "Company Information";
    begin
        CompInfo.Get;
        VendorLedgerEntry.Reset;
        VendorLedgerEntry.Setrange(VendorLedgerEntry."Vendor No.", GenJournalLine."Account No.");
        VendorLedgerEntry.Setrange(VendorLedgerEntry."Document Type", GenJournalLine."Applies-to Doc. Type");
        VendorLedgerEntry.Setrange(VendorLedgerEntry."Document No.", GenJournalLine."Applies-to Doc. No.");
        if VendorLedgerEntry.FindSet() then
            GenJournalLine."Message to Recipient" := 'Trafalgar ' + VendorLedgerEntry."External Document No.";
    end;


}
