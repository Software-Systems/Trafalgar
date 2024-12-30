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
    }

    keys
    {
        // Add changes to keys here
        key(ProdOrderStatus; "Production Order Status")
        {
        }
    }

    procedure GetInStockQuantity(): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQty: Decimal;
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
}