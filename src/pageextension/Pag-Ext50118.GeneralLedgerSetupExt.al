pageextension 50118 PagExtGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(EnableDataCheck)
        {
            group(Sharepoint)
            {
                field("SharePoint Sales Document Path"; Rec."SharePoint Document Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Document Path field.', Comment = '%';
                }
                field("SharePoint Purch Document Path"; Rec."SharePoint Purch Document Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Document Path field.', Comment = '%';
                }
            }
            field("Auto Send Invoice on Posting"; Rec."Auto Send Invoice on Posting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Auto Send Invoice on Order Posting field.', Comment = '%';
            }
            field("Location For Make To Order"; Rec."Location For Make To Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location For Make To Order field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Dimensions)
        {
            action("Patch Sharepoint")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    GLSetup: Record "General Ledger Setup";
                    SalesHeader: Record "Sales Header";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    GLSetup.Get();

                    SalesHeader.Reset;
                    SalesHeader.SetFilter(SalesHeader."Document Type", '<>%1', SalesHeader."Document Type"::Quote);
                    if SalesHeader.FindSet() then
                        repeat
                            SalesHeader.Documents := GLSetup."SharePoint Document Path" + '' + SalesHeader."No.";
                            SalesHeader.Modify();
                        until SalesHeader.Next = 0;

                    PurchaseHeader.Reset;
                    PurchaseHeader.SetFilter(PurchaseHeader."Document Type", '<>%1', PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        repeat
                            PurchaseHeader.Documents := GLSetup."SharePoint Purch Document Path" + '' + PurchaseHeader."No.";
                            PurchaseHeader.Modify();
                        until PurchaseHeader.Next = 0;

                    Message('Done');

                end;
            }
        }
    }

    var
        myInt: Integer;
}