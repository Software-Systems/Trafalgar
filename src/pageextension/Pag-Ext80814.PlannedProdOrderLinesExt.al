pageextension 80814 PagExtPlannedProdOrderLines extends "Planned Prod. Order Lines"
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
                if item.Get(Rec."Item No.") then begin
                    Rec."Product Code" := Item."Product Code";
                    Rec.Modify();
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