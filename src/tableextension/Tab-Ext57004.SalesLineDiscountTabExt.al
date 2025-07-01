tableextension 57004 TabExtSalesLineDiscount extends "Sales Line Discount"
{
    fields
    {
        field(50000; "Product Code"; Code[200])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Code" where("No." = field(Code)));
        }

        field(50001; "Customer"; Code[200])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Name" where("No." = field("Sales Code")));
        }
    }
}
