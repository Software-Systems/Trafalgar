report 50118 "ChangeExtDocNo_Purch"
{
    ApplicationArea = All;
    Caption = 'Change Ext Document No. (Purchase)';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions =
        tabledata "Purch. Inv. Header" = RIMD;
    dataset
    {
        dataitem(PurchaseInvHeader; "Purch. Inv. Header")
        {
            trigger OnAfterGetRecord()
            begin
                PurchaseInvHeader."Vendor Invoice No." := DocumentNo;
                PurchaseInvHeader.Modify(false);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Change Document No.")
                {
                    field(DocumentNo; DocumentNo)
                    {
                        Caption = 'New Document No.';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    var
        DocumentNo: Code[20];
}
