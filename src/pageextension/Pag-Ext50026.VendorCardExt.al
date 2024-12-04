pageextension 50026 PagExtVendorCard extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        //addafter("Item References")
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