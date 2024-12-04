pageextension 80829 PagExtFirmPlannedProdOrder extends "Firm Planned Prod. Order"
{
    layout
    {
        addafter("Assigned User ID")
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
        addafter("Re&fresh Production Order")
        {
            action("Refresh Production Order")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Re&fresh Production Order';
                Ellipsis = true;
                Image = Refresh;
                ToolTip = 'Calculate changes made to the production order header without involving production BOM levels. The function calculates and initiates the values of the component lines and routing lines based on the master data defined in the assigned production BOM and routing, according to the order quantity and due date on the production order''s header.';

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                    GeneLedSEtup: Record "General Ledger Setup";
                    ProdOrderRtngLine: Record "Prod. Order Routing Line";
                begin
                    ProdOrder.SetRange(Status, Rec.Status);
                    ProdOrder.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Refresh Production Order", true, true, ProdOrder);
                    if Rec.Documents = '' then begin
                        if Rec."Sales Order No." <> '' then
                            Rec.Documents := Rec."Sales Order No."
                        else begin
                            GeneLedSEtup.GetRecordOnce();
                            Rec.Documents := GeneLedSEtup."SharePoint Document Path" + Rec."No.";
                            Rec."Sales Order No." := Rec."No.";
                        end;
                    end;
                    ProdOrderRtngLine.SetRange(Status, Rec.Status);
                    ProdOrderRtngLine.SetRange("Prod. Order No.", Rec."No.");
                    ProdOrderRtngLine.SetRange("Routing No.", Rec."Routing No.");
                    if ProdOrderRtngLine.FindSet(true) then
                        repeat
                            if ProdOrderRtngLine."Run Time" <> 0 then
                                ProdOrderRtngLine."Run Time" := ProdOrderRtngLine."Input Quantity" * ProdOrderRtngLine."Run Time";
                            ProdOrderRtngLine.Modify(false);
                        until ProdOrderRtngLine.Next() = 0;
                end;
            }
        }
        modify("Re&fresh Production Order")
        {
            Visible = false;
        }
        modify("Re&fresh Production Order_Promoted")
        {
            Visible = false;
        }
        addafter("Re&fresh Production Order_Promoted")
        {
            actionref(RefreshPromoted; "Refresh Production Order")
            {
            }
        }
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
        }
        addafter("Re&plan_Promoted")
        {
            actionref("Open_Document_Promoted"; OpenDocument)
            {
            }
        }
    }
}
