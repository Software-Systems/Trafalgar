pageextension 59305 PagExtSalesOrderList extends "Sales Order List"
{
    Editable = true;
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = all;
                StyleExpr = StylExpTxt;
            }
            field(Documents; Rec.Documents)
            {
                Caption = 'Document Link';
                ApplicationArea = All;
                Width = 50;
                Visible = false;
            }

        }
        modify("No.")
        {
            Editable = false;
        }
        modify("Sell-to Customer No.")
        {
            Editable = false;
        }
        modify("Sell-to Customer Name")
        {
            Editable = false;
        }
        modify("External Document No.")
        {
            Editable = false;
        }
        modify("Location Code")
        {
            Editable = false;
        }
        modify("Assigned User ID")
        {
            Editable = false;
        }
        modify("Document Date")
        {
            Editable = false;
        }
        modify(Status)
        {
            Editable = false;
        }
        modify("Completely Shipped")
        {
            Editable = false;
        }
        modify("Amt. Ship. Not Inv. (LCY)")
        {
            Editable = false;
        }
        modify("Amt. Ship. Not Inv. (LCY) Base")
        {
            Editable = false;
        }
        modify(Amount)
        {
            Editable = false;
        }
        modify("Amount Including VAT")
        {
            Editable = false;
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Create &Warehouse Shipment")
        {
            action("Update Warehouse Availability")
            {
                ApplicationArea = all;
                Caption = 'Update Warehouse Availability';
                Image = UpdateDescription;
                trigger OnAction()
                var
                    ItemCheck: Record Item;
                begin
                    CheckAndUpdateStatus();
                end;
            }
        }
        addafter("Create &Warehouse Shipment_Promoted")
        {
            actionref("Update Warehouse Availability_Promoted"; "Update Warehouse Availability")
            {
            }
        }
        addafter("Email Confirmation")
        {
            action(SendProformaByEmail)
            {
                Caption = 'Email Proforma';
                Visible = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesEvents: Codeunit "Extention for Sales Subscriber";
                begin
                    SalesEvents.SendEmailProforma(Rec);
                end;
            }
        }
        addafter("Email Confirmation_Promoted")
        {
            actionref(EmailProforma_Promoted; SendProformaByEmail)
            {
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        ChangeFieldColour: Codeunit "Change Field Color";
    begin
        CLEAR(ChangeFieldColour);
        StylExpTxt := ChangeFieldColour.ChangeSalesOrderStatuColor(Rec);
    end;

    trigger OnOpenPage()
    begin
        //Rec.SetCurrentKey("Sell-to Customer No.", "No.");
        Rec.SetAscending("No.", false);
    end;

    local procedure UpdateStatusOnHeader(var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        OrderStatusInt: Integer;
        PreviousOrderStatus: Enum "Order Status";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Order Status Manually Changed", false);
        SalesHeader.SetFilter("Order Status", '<>%1', SalesHeader."Order Status"::"7 Packed");
        if SalesHeader.FindSet() then
            repeat
                OrderStatusInt := 2;
                PreviousOrderStatus := PreviousOrderStatus::"1 Prod Planned";
                SalesLine.Reset();
                SalesLine.SetCurrentKey("Production Order Status");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then begin
                    SalesHeader."Order Status" := SalesLine."Production Order Status";
                    SalesHeader.Modify();
                end;
            until SalesHeader.Next() = 0;
    end;

    local procedure ItemInventoryCheck(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        PackedQty: Decimal;
    begin
        PackedQty := 0;
        GetPackedItemQty(SalesLine, PackedQty);
        Item.Reset();
        Item.SetRange(Item."No.", SalesLine."No.");
        Item.SetRange("Location Filter", SalesLine."Location Code");
        if Item.FindFirst() then begin
            Item.CalcFields(Inventory);
            if ((Item.Inventory + PackedQty) >= SalesLine.Quantity) and (SalesLine."Qty. to Ship" <> 0) then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"5 In WH";
            if ((Item.Inventory + PackedQty) < SalesLine.Quantity) and (SalesLine."Qty. to Ship" <> 0) then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"4 Not Enough Stock";
            if Item.Type = Item.Type::"Non-Inventory" then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"7 Packed";
            SalesLine.Modify(true);
        end;
        SalesLine.CalcFields("Reserved Quantity");
        if SalesLine."Reserved Quantity" = SalesLine.Quantity then begin
            SalesLine."Production Order Status" := SalesLine."Production Order Status"::"6 Moved to WH";
            SalesLine.Modify(true);
        end;
        // If (SalesLine."Quantity Shipped" <> 0) AND (SalesLine."Qty. to Ship" = 0) then begin
        //     SalesLine."Production Order Status" := SalesLine."Production Order Status"::"8 Part Shipped";
        //     SalesLine.Modify(true);
        // end;
    end;

    local procedure ProductionOrderStatusCheck(var SalesLine: Record "Sales Line"; var ProductionOrder: Record "Production Order")
    begin
        if ProductionOrder.Status = ProductionOrder.Status::Planned then
            SalesLine."Production Order Status" := SalesLine."Production Order Status"::"1 Prod Planned"
        else
            if ProductionOrder.Status = ProductionOrder.Status::Released then
                SalesLine."Production Order Status" := SalesLine."Production Order Status"::"2 Prod Released"
            else
                if ProductionOrder.Status = ProductionOrder.Status::Finished then
                    SalesLine."Production Order Status" := SalesLine."Production Order Status"::"3 Prod Completed";
        SalesLine."Production Order No." := ProductionOrder."No.";
        SalesLine.Modify(true);
    end;

    local procedure GetPackedItemQty(var SalesLine: Record "Sales Line"; var PackedQty: Decimal)
    var
        ItemSalesLine: Record "Sales Line";
    begin
        ItemSalesLine.SetRange(ItemSalesLine."No.", SalesLine."No.");
        ItemSalesLine.SetRange(ItemSalesLine."Production Order Status", ItemSalesLine."Production Order Status"::"7 Packed");
        if ItemSalesLine.FindSet() then
            repeat
                PackedQty += ItemSalesLine.Quantity;
            until ItemSalesLine.Next() = 0;
    end;

    local procedure CheckAndUpdateStatus()
    var
        SalesLine: Record "Sales Line";
        StatusCheck: Record "Sales Header";
        ProductionOrder: Record "Production Order";
        Progress: Dialog;
        Counter: Integer;
        Text000: Label 'Status Update ------ #1';
    begin
        Progress.OPEN(Text000, Counter);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        if SalesLine.FindSet() then begin
            StatusCheck.Reset();
            StatusCheck.SetRange("No.", SalesLine."Document No.");
            StatusCheck.FindFirst();
            if (StatusCheck.Status <> StatusCheck.Status::Open) or (StatusCheck.Status <> StatusCheck.Status::Released) then begin
                repeat
                    if (SalesLine."Production Order Status" <> SalesLine."Production Order Status"::"7 Packed") then begin
                        ProductionOrder.Reset();
                        ProductionOrder.SetRange(ProductionOrder."Sales Order No.", SalesLine."Document No.");
                        ProductionOrder.SetRange(ProductionOrder."Source No.", SalesLine."No.");
                        if ProductionOrder.FindFirst() then begin
                            ProductionOrderStatusCheck(SalesLine, ProductionOrder);
                        end else begin
                            ItemInventoryCheck(SalesLine);
                        end;
                        Counter := Counter + 1;
                        Progress.UPDATE(); // Update the field in the dialog.
                        SLEEP(50);
                    end;
                until SalesLine.Next() = 0;
                UpdateStatusOnHeader(SalesLine);
            end;
        end;
        Progress.CLOSE();
    end;

    var
        myInt: Integer;
        StylExpTxt: Text[50];


}