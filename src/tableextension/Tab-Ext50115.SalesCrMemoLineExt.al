tableextension 50115 TabExtSalesCrMemoLine extends "Sales Cr.Memo Line"
{
    fields
    {
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
        field(50111; "Method Of Enquiry"; Enum "Method Of Enquiry")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Method Of Enquiry" where("No." = field("Document No.")));
        }

        field(55013; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(3)));
        }
        field(55014; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(4)));
        }
        field(55015; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(5)));
        }
        field(55016; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(6)));
        }
        field(55017; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(7)));
        }
        field(55018; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
            "Global Dimension No." = const(8)));
        }
        field(52010; "Product Code"; Code[200])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Code" where("No." = field("No.")));
        }
        field(52020; "Sales Order Created By"; Code[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Change Log Entry"."User ID" where
            ("Table No." = const(36), "Type of Change" = Filter(Insertion), "Primary Key Field 2 Value" = field("Order No.")
            ));
        }
        field(78020; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Assigned User ID" where("No." = field("Document No.")));
        }
        field(78030; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Reason Code" where("No." = field("Document No.")));
        }

    }

    procedure GetSalesOrderCreatedBy() RetValue: Text
    var
        ChangeLogEntry: Record "Change Log Entry";
    begin
        ChangeLogEntry.Reset;
        ChangeLogEntry.Setrange(ChangeLogEntry."Table No.", 36);
        ChangeLogEntry.Setrange(ChangeLogEntry."Primary Key Field 2 Value", "Order No.");
        ChangeLogEntry.Setrange(ChangeLogEntry."Type of Change", ChangeLogEntry."Type of Change"::Insertion);
        if ChangeLogEntry.FindFirst() then
            RetValue := ChangeLogEntry."User ID";
        exit(RetValue);
    end;
}
