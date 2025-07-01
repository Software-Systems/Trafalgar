pageextension 50118 PagExtGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(EnableDataCheck)
        {
            group(Sharepoint)
            {
                field("SharePoint User Tasks Path"; Rec."SharePoint User Tasks Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Task Document Path field.', Comment = '%';
                }
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
                group(GLEntries)
                {
                    field("Sharepoint GLEntries Nos."; Rec."Sharepoint GLEntries Nos.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Sharepoint GLEntries Nos. field.', Comment = '%';
                    }
                    field("SharePoint GLEntries Doc. Path"; Rec."SharePoint GLEntries Doc. Path")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the GLEntries Document Path field.', Comment = '%';
                    }
                    field("Sharepoint Client Secret"; Rec."Sharepoint Client Secret")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Sharepoint Client Secret field.', Comment = '%';
                    }
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
                    UserTask: Record "User Task"; //FV 150425
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
                    //FV 150425
                    UserTask.Reset;
                    if UserTask.FindSet() then
                        repeat
                            UserTask.Documents := GLSetup."SharePoint User Tasks Path" + '' + Format(UserTask.ID);
                            UserTask.Modify();
                        until UserTask.Next = 0;

                    Message('Done');

                end;
            }
        }
    }

    var
        myInt: Integer;
}