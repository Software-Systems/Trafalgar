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
            field("Accounts E-Mail Address"; Rec."Account E-Mail")
            {
                ApplicationArea = All;
                Caption = 'Accounts Email Address'; // Updated Caption
                ToolTip = 'Specifies the value of the Accounts E-Mail Address field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Email)
        {
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";
                    FileURL: Text;
                begin
                    FileURL := TrafalgarSharepointCodeunit.OpenSharepointDocument(23, Rec."No.");
                    if FileURL <> '' then
                        Hyperlink(FileUrl);
                end;
            }
        }
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
        addafter(Email_Promoted)
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
        }
    }

    var
        myInt: Integer;
}