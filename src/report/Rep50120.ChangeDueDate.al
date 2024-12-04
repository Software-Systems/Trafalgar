report 50120 ChangeDueDate
{
    ApplicationArea = All;
    Caption = 'Change Due Date';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions =
        tabledata "Purch. Inv. Header" = RM;
    dataset
    {
        dataitem(PurchaseInvHeader; "Purch. Inv. Header")
        {
            trigger OnAfterGetRecord()
            var
                VendorLedgerEntry: Record "Vendor Ledger Entry";
            begin
                if PurchaseInvHeader."Due Date" <> DueDate then begin
                    PurchaseInvHeader."Due Date" := DueDate;
                    if PurchaseInvHeader.Modify(false) then begin
                        VendorLedgerEntry.Reset();
                        VendorLedgerEntry.SetRange("Document No.", PurchaseInvHeader."No.");
                        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                        if VendorLedgerEntry.FindFirst() then begin
                            VendorLedgerEntry."Due Date" := DueDate;
                            VendorLedgerEntry.Modify(false);
                        end;
                    end
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Change Due Date")
                {
                    field(DueDate; DueDate)
                    {
                        Caption = 'New Due Date';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    var
        DueDate: Date;
}
