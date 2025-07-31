tableextension 50027 TabExtItem extends Item
{
    fields
    {
        field(50100; "Long Description"; Text[250])
        {
            Caption = 'Long Description';
            DataClassification = CustomerContent;
        }
        field(53010; "User Prompt"; Text[250])
        {
            Caption = 'User Prompt';
            DataClassification = CustomerContent;
        }
        /*
        field(53013; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(7, "Shortcut Dimension 3 Code");
            end;
        }
        field(54014; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(7, "Shortcut Dimension 4 Code");
            end;
        }
        field(55015; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(7, "Shortcut Dimension 5 Code");
            end;
        }
        field(55016; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(7, "Shortcut Dimension 6 Code");
            end;
        }
        field(55017; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(55018; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        */
        field(54014; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where(
                "Table ID" = const(27),
                "Dimension Code" = const('DIVISION'),
                "No." = field("No.")
                ));
        }
        field(54015; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Default Dimension"."Dimension Value Code" where(
                "Table ID" = const(27),
                "Dimension Code" = const('PRODCAT'),
                "No." = field("No.")
                ));
        }
    }
}
