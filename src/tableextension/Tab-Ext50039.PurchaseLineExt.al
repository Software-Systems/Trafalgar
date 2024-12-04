tableextension 50039 TabExtPurchaseLine extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            var
                PurHeader: Record "Purchase Header";
            begin
                if ("Document Type" = "Document Type"::Order) and (Rec."Direct Unit Cost" <> xRec."Direct Unit Cost") and ("Quantity Received" > 0) then begin
                    if PurHeader.get("Document Type"::Order, "Document No.") then begin
                        PurHeader."Price Changed" := true;
                        PurHeader.Modify();
                    end;
                end;
            end;
        }
    }
}