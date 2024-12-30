pageextension 50026 PagExtVendorCard extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        addafter("E-Mail")
        {
            field("Account Manager E-Mail"; Rec."Account Manager E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account Manager E-Mail field.', Comment = '%';
            }
            field("Account E-Mail"; Rec."Account E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Account E-Mail field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(PayVendor)
        {
            action(HistoricalPurchases)
            {
                ApplicationArea = All;
                Caption = 'Historical Purchases';
                Image = PaymentHistory;
                ToolTip = 'View Historical Purchases.';
                RunObject = page "Historical Purchases";
                RunPageLink = "Vendor No." = field("No.");
            }
        }
        addafter(PayVendor_Promoted)
        {
            actionref("HistoricalPurchase_Promoted"; HistoricalPurchases)
            { }
        }
    }

    var
        myInt: Integer;
}