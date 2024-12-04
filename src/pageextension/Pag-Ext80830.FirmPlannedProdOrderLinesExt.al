pageextension 80830 PagExtFirmPlanProdOrderLines extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item No.")
        {
            field("Product Code"; Rec."Product Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Item.Get(Rec."Item No.") then begin
                    Rec."Product Code" := Item."Product Code";
                end;
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}