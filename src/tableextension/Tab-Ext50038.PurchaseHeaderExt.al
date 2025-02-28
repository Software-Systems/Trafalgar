tableextension 50038 TabExtPurchaseHeader extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Price Changed"; Boolean)
        {
            Caption = 'Price Changed';
            DataClassification = CustomerContent;
        }
        field(50101; Documents; Text[500])
        {
            Caption = 'Documents';
            ExtendedDatatype = URL;
            DataClassification = CustomerContent;
        }
        field(53010; "Qty Received Not Invoiced"; Boolean)
        {
            CalcFormula = exist("Purchase Line"
            where("Document Type" = field("Document Type"),
            "Document No." = field("No."),
            Type = filter(<> " "),
            "Qty. Rcd. Not Invoiced" = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
    }
    trigger OnAfterInsert()
    var
        GenLedSetup: Record "General Ledger Setup";
    begin
        GenLedSetup.Get();
        Documents := GenLedSetup."SharePoint Purch Document Path" + '' + "No.";
        Modify();
    end;
}