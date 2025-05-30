tableextension 55405 TabExtProductionOrder extends "Production Order"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(50101; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
        }
        field(50102; Documents; Text[500])
        {
            Caption = 'Documents';
            ExtendedDatatype = URL;
        }
        field(50103; "Production Type"; Enum "Production Type")
        {
            Caption = 'Production Type';
            AllowInCustomizations = Always;
        }
        field(50104; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            AllowInCustomizations = Always;
        }
        field(50105; "Order Release Date"; DateTime)
        {
            Caption = 'Order Release Date';
            AllowInCustomizations = Always;
        }
        field(50106; "Delete Confirmation"; Boolean)
        {
            Caption = 'Delete Confirmation';
            AllowInCustomizations = Always;
        }

        field(51001; "Product Code"; Code[200])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Code" where("No." = field("Source No.")));
        }
    }
}