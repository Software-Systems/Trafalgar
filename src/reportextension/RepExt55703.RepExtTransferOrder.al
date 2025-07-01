reportextension 55703 RepExtTransferOrder extends "Transfer Order"
{
    dataset
    {
        add("Transfer Line")
        {
            column(ProductCode; ProductCode)
            {
            }
        }
        modify("Transfer Line")
        {
            trigger OnAfterAfterGetRecord()
            begin
                if Item.get("Item No.") then
                    ProductCode := Item."Product Code"
                else
                    ProductCode := '';
            end;
        }
    }
    rendering
    {
        layout("TG Transfer Order")
        {
            Type = RDLC;
            Caption = 'TG Transfer Order';
            Summary = 'TG Transfer Order';
            LayoutFile = 'src\reportextension\RepExt55703.RepExtTransferOrder.rdl';
        }
    }

    var
        Item: Record Item;
        ProductCode: Text;
}
