tableextension 50037 TabExtSalesLine extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Production Order No."; Code[20])
        {
            Caption = 'Production Order No.';
            DataClassification = CustomerContent;
        }
        field(50102; "Production Order Status"; Enum "Order Status")
        {
            Caption = 'Production Order Status';
            DataClassification = CustomerContent;
        }
        field(50110; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(6)));
        }
    }

    keys
    {
        // Add changes to keys here
        key(ProdOrderStatus; "Production Order Status")
        {
        }
    }

    procedure GetInStockQuantity_OLD() TotalQty: Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LocationCode: Text;
    begin
        TotalQty := 0;
        if Rec.Type = Rec.Type::Item then begin
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.Setfilter(ItemLedgerEntry."Remaining Quantity", '<>%1', 0);
            ItemLedgerEntry.Setrange(ItemLedgerEntry."Item No.", Rec."No.");
            ItemLedgerEntry.SetFilter(ItemLedgerEntry."Location Code", Rec."Location Code");
            if ItemLedgerEntry.FindSet() then
                repeat
                    TotalQty := TotalQty + ItemLedgerEntry."Remaining Quantity";
                until ItemLedgerEntry.Next() = 0;
        end;
        Exit(TotalQty);
    end;

    procedure GetInStockQuantity() ProjAvailableBalance: Decimal
    var
        Item: Record Item;
        GrossRequirement: Decimal;
        PlannedOrderReceipt: Decimal;
        ScheduledReceipt: Decimal;
        PlannedOrderReleases: Decimal;

        TransOrdShipmentQty: Decimal;
        QtyinTransit: Decimal;
        TransOrdReceiptQty: Decimal;
    begin
        if Rec.Type = Rec.Type::Item then begin
            Item.Reset;
            Item.Setrange(Item.Type, Item.Type::Inventory);
            Item.Setrange(Item."No.", Rec."No.");
            Item.Setrange(Item."Location Filter", Rec."Location Code");
            //Item.Setfilter(Item."Date Filter", '%1..%2', 0D, Rec.);
            if Item.FindSet() then begin
                Item.CalcFields(
                    Item.Inventory,
                    Item."Trans. Ord. Shipment (Qty.)",
                    Item."Qty. in Transit",
                    Item."Trans. Ord. Receipt (Qty.)",
                    Item."Qty. on Sales Order",
                    Item."Qty. on Job Order",
                    Item."Qty. on Component Lines",
                    Item."Planning Issues (Qty.)",
                    Item."Qty. on Asm. Component",
                    Item."Qty. on Purch. Return",
                    Item."Planned Order Receipt (Qty.)",
                    Item."Purch. Req. Receipt (Qty.)",
                    Item."FP Order Receipt (Qty.)",
                    Item."Rel. Order Receipt (Qty.)",
                    Item."Qty. on Purch. Order",
                    Item."Qty. on Assembly Order",
                    Item."Qty. on Sales Return",
                    Item."Planned Order Release (Qty.)",
                    Item."Purch. Req. Release (Qty.)"
                );
                if Rec."Location Code" = '' then begin
                    TransOrdShipmentQty := 0;
                    QtyinTransit := 0;
                    TransOrdReceiptQty := 0;
                end else begin
                    TransOrdShipmentQty := Item."Trans. Ord. Shipment (Qty.)";
                    QtyinTransit := Item."Qty. in Transit";
                    TransOrdReceiptQty := Item."Trans. Ord. Receipt (Qty.)";
                end;
                GrossRequirement := Item."Qty. on Sales Order" + Item."Qty. on Job Order" + Item."Qty. on Component Lines" +
                TransOrdShipmentQty + Item."Planning Issues (Qty.)" + Item."Qty. on Asm. Component" + Item."Qty. on Purch. Return";
                PlannedOrderReceipt := Item."Planned Order Receipt (Qty.)" + Item."Purch. Req. Receipt (Qty.)";
                ScheduledReceipt := Item."FP Order Receipt (Qty.)" + Item."Rel. Order Receipt (Qty.)" + Item."Qty. on Purch. Order" +
                    QtyinTransit + TransOrdReceiptQty + Item."Qty. on Assembly Order" + Item."Qty. on Sales Return";
                PlannedOrderReleases := Item."Planned Order Release (Qty.)" + Item."Purch. Req. Release (Qty.)";
                ProjAvailableBalance := Item.Inventory + PlannedOrderReceipt + ScheduledReceipt - GrossRequirement;

            end;
        end;
        exit(ProjAvailableBalance);
    end;
}