tableextension 51170 TabExtUserTask extends "User Task"
{
    fields
    {
        field(78010; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            trigger OnValidate()
            begin
                "Sales Order No." := '';
                "Posted Sales Invoice No." := '';
            end;
        }
        field(78011; "Customer Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
        }
        field(78020; "Sales Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Customer No." = const('')) "Sales Header"."No." Where("Document Type" = const(Order))
            else
            if ("Customer No." = filter(<> '')) "Sales Header"."No." where("Document Type" = const(Order), "Bill-to Customer No." = field("Customer No."));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                if SalesHeader.get(SalesHeader."Document Type"::Order, "Sales Order No.") then begin
                    "Customer No." := SalesHeader."Bill-to Customer No.";
                end
                else begin
                    "Customer No." := '';
                end;
                "Posted Sales Invoice No." := '';
            end;
        }
        field(78030; "Posted Sales Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if ("Customer No." = const('')) "Sales Invoice Header"."No."
            else
            if ("Customer No." = filter(<> '')) "Sales Invoice Header"."No." where("Bill-to Customer No." = field("Customer No."));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                SalesInvHeader: Record "Sales Invoice Header";
            begin
                if SalesInvHeader.get("Posted Sales Invoice No.") then begin
                    "Customer No." := SalesInvHeader."Bill-to Customer No.";
                    "Sales Order No." := SalesInvHeader."Order No.";
                end
                else begin
                    "Customer No." := '';
                    "Sales Order No." := '';
                end;
            end;
        }
        field(78040; "Refund Amount"; Decimal)
        {
            BlankZero = True;
            DataClassification = CustomerContent;
        }
        field(78110; "Bank BSB"; Text[50])
        {
            Caption = 'BSB';
            DataClassification = CustomerContent;
        }
        field(78120; "Bank Account No."; Text[100])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(78130; "Bank Account Name"; Text[100])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(78140; "Bank Email Contact"; Text[100])
        {
            Caption = 'Email Contact';
            DataClassification = CustomerContent;
        }
        field(78150; Documents; Text[500])
        {
            Caption = 'Documents';
            ExtendedDatatype = URL;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(CustNo; "Customer No.")
        {

        }
    }

    trigger OnAfterInsert()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        Clear("Assigned To");

        if GLSetup.Get() then
            Rec.Documents := GLSetup."SharePoint User Tasks Path" + Format(Rec.ID);
    end;

}
