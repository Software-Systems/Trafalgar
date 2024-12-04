pageextension 59325 PagExtFirmPlannedProdOrders extends "Firm Planned Prod. Orders"
{
    layout
    {
        addafter("Source No.")
        {
            field("Product Code"; ProductCode)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Clear(ProductCode);
        if Item.get(Rec."Source No.") then
            ProductCode := Item."Product Code";
    end;

    var
        ProductCode: Code[200];
        Item: Record Item;
}
