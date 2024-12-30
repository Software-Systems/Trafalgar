tableextension 50113 TabExtSalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        field(52010; "Product Code"; Code[200])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Product Code" where("No." = field("No.")));
        }
        field(52020; "Sales Order Created By"; Code[100])
        {
            Caption = 'MyField';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Change Log Entry"."User ID" where
            ("Table No." = const(36), "Type of Change" = Filter(Insertion), "Primary Key Field 2 Value" = field("Order No.")
            ));
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
