pageextension 80867 PagExtFinishedProductionOrder extends "Finished Production Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Due Date")
        {
            field("Production Type"; Rec."Production Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Production Type field.', Comment = '%';
            }
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
            }
            field("Order Release Date"; Rec."Order Release Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Release Date field.', Comment = '%';
            }
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addbefore("Co&mments")
        {
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink(Rec.Documents);
                end;
            }
            action(PrintJobCard)
            {
                Caption = 'Print Job Card';
                Image = Report;
                ToolTip = 'Prints Job Card.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    jobCard: Report "Trafalgar Job Card";
                    ProdOrder: Record "Production Order";
                begin
                    ProdOrder.SetRange("No.", Rec."No.");
                    if ProdOrder.FindFirst() then begin
                        jobCard.SetTableView(ProdOrder);
                        jobCard.Run();
                    end;
                end;
            }
        }
        addafter("Co&mments_Promoted")
        {
            actionref("Open_Document_Promoted"; OpenDocument)
            {
            }
            actionref("PrintJobCard_Promoted"; PrintJobCard)
            { }
        }
    }

    var
        myInt: Integer;
}