tableextension 51304 TabExtSalesPriceLineDiscBuff extends "Sales Price and Line Disc Buff"
{
    fields
    {
        field(51010; "Customer Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = Field("Sales Code")));
        }
        field(51020; "Product Code"; Code[200])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Code" where("No." = Field("Code")));
        }
    }
}
