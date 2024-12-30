tableextension 50036 TabExtSalesHeader extends "Sales Header"
{
    fields
    {
        //Add changes to table fields here
        field(50100; "Order Status"; Enum "Order Status")
        {
            Caption = 'Order Status';
            DataClassification = CustomerContent;
        }
        field(50101; Documents; Text[500])
        {
            Caption = 'Documents';
            ExtendedDatatype = URL;
            DataClassification = CustomerContent;
        }
        field(50102; "Order Status Manually Changed"; Boolean)
        {
            Caption = 'Order Status Manually Changed';
            DataClassification = CustomerContent;
        }
        field(50103; "Created By"; Text[100])
        {
            Caption = 'Created By';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemCreatedBy)));
        }
        field(50104; "Modified By"; Text[100])
        {
            Caption = 'Modified By';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(User."User Name" where("User Security ID" = field(SystemModifiedBy)));
        }
        field(50105; "CC Payment Date"; Date)
        {
            Caption = 'CC Payment Date';
            DataClassification = CustomerContent;
        }
        field(50106; "CC Processed By"; Text[100])
        {
            Caption = 'CC Processed By';
            DataClassification = CustomerContent;
        }
        field(50107; "CC Card Type"; Text[50])
        {
            Caption = 'CC Card Type';
            DataClassification = CustomerContent;
        }
        field(50108; "CC Machine"; Text[100])
        {
            Caption = 'CC Machine';
            DataClassification = CustomerContent;
        }
        field(50109; "Quote Created By"; Text[100])
        {
            Caption = 'Quote Created By';
            DataClassification = CustomerContent;
        }
        field(50110; "Refund Type"; Option)
        {
            Caption = 'Refund Type';
            OptionMembers = "",Cash,"Credit Refund";
            DataClassification = CustomerContent;
        }
    }
    trigger OnAfterInsert()
    var
        GenLedSetup: Record "General Ledger Setup";
    begin
        GenLedSetup.Get();
        Documents := GenLedSetup."SharePoint Document Path" + '' + "No.";
        Modify();
    end;

    procedure CheckInStockQuantity() RetValue: Text
    var
        SalesLine: Record "Sales Line";
        TypeHelper: Codeunit "Type Helper";
    begin
        Clear(RetValue);
        SalesLine.Reset;
        SalesLine.Setrange(SalesLine."Document Type", Rec."Document Type");
        SalesLine.Setrange(SalesLine."Document No.", Rec."No.");
        SalesLine.Setrange(SalesLine.Type, SalesLine.Type::Item);
        SalesLine.SetFilter(SalesLine."Product Code", '<> %1', 'DELIVERY');
        if SalesLine.findset then
            repeat
                if SalesLine."Qty. to Ship (Base)" > SalesLine.GetInStockQuantity() then begin
                    if RetValue <> '' then
                        RetValue := RetValue + TypeHelper.CRLFSeparator();

                    RetValue := RetValue + 'Item ' + SalesLine."No." + ' - ' + SalesLine."Product Code" +
                    ' (Line : ' + Format(SalesLine."Line No.") + ')';
                end;
            until SalesLine.Next() = 0;
        if RetValue <> '' then
            RetValue := 'Not Enough Stock For Item Below : ' + TypeHelper.CRLFSeparator() + TypeHelper.CRLFSeparator() + RetValue;
        exit(RetValue);
    end;
}