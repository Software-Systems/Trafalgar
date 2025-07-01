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
        field(51030; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(3)
            ));
        }
        field(51040; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(4)
            ));
        }
        field(51050; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(5)
            ));
        }

        field(51060; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(6)
            ));
        }

        field(51070; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(7)
            ));
        }
        field(51080; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(8)
            ));
        }
    }
}