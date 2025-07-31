pageextension 50029 PagExtVendorLedgerEntries extends "Vendor Ledger Entries"
{
    actions
    {
        // Add changes to page actions here
        addafter(RemittanceAdvance)
        {
            action(RemitAdv)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Rem. Advice';
                Image = Attachments;
                ToolTip = 'View which documents have been included in the payment.';

                trigger OnAction()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                begin
                    CurrPage.SetSelectionFilter(VendLedgEntry);
                    VendLedgEntry.SetRange("Document Type", VendLedgEntry."Document Type"::Payment);
                    SendVendorRecords(VendLedgEntry);
                end;
            }
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    TrafalgarSharepointCodeunit.OpenSharepointDocument(25, Rec."Document No.");
                end;
            }
        }
        modify(RemittanceAdvance)
        {
            Visible = false;
        }
        addafter("&Navigate_Promoted")
        {
            actionref(OpenDocument_Promoted; OpenDocument)
            {
            }
        }
    }

    local procedure SendVendorRecords(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
    begin
        if not VendorLedgerEntry.FindSet() then
            exit;

        DocumentSendingProfile.SendVendorRecords(
            DummyReportSelections.Usage::"P.V.Remit.".AsInteger(), VendorLedgerEntry, RemittanceAdviceTxt, Rec."Vendor No.", Rec."Document No.",
            VendorLedgerEntry.FieldNo("Vendor No."), VendorLedgerEntry.FieldNo("Document No."));
    end;

    var
        RemittanceAdviceTxt: Label 'Remittance Advice';
        TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";
}