tableextension 50018 TabExtCustomer extends Customer
{
    fields
    {
        field(50100; "Send Statements"; Boolean)
        {
            Caption = 'Send Statements';
            DataClassification = CustomerContent;
        }
        field(50101; "Important Notes"; Text[1024])
        {
            Caption = 'Important Notes';
            DataClassification = CustomerContent;
        }
        field(50102; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                          Blocked = const(false));
            AllowInCustomizations = Always;

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(50103; "Buyer Email Address"; Text[100])
        {
            Caption = 'Buyer Email Address';
            DataClassification = CustomerContent;
        }
        field(50104; "Accounts Email Address"; Text[250])
        {
            Caption = 'Accounts Email Address';
            DataClassification = CustomerContent;
        }
        field(50105; "NZBN"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(53010; "No. of Ongoing Quotes"; Integer)
        {
            CalcFormula = count("Sales Header" where(
                    "Document Type" = const(Quote),
                    "Sell-to Customer No." = field("No."),
                    "Lost Opportunity" = const(False)
                    ));
            Editable = false;
            FieldClass = FlowField;
        }
        field(53020; "No. of Lost Quotes"; Integer)
        {
            CalcFormula = count("Sales Header" where(
                    "Document Type" = const(Quote),
                    "Sell-to Customer No." = field("No."),
                    "Lost Opportunity" = const(True)
                    ));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    /* procedure SharepointOpenDocsCustomer()
     var
         GLSetup: Record "General Ledger Setup";
     begin
         if GLSetup.get then begin
             GLSetup.TestField("SharePoint Customer Path");
             Hyperlink(GLSetup."SharePoint Customer Path" + Rec."No.");
         end;
     end;
   */
}
