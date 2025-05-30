tableextension 50036 TabExtSalesHeader extends "Sales Header"
{
    fields
    {
        //Add changes to table fields here
        field(50100; "Order Status"; Enum "Order Status")
        {
            Caption = 'Order Status';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Item: Record Item;
            begin
                if "Order Status" = "Order Status"::"7 Packed" then begin
                    Message('Stock will be reserved for Sales Lines');
                    SalesLine.Reset;
                    SalesLine.Setrange(SalesLine."Document Type", Rec."Document Type");
                    SalesLine.Setrange(SalesLine."Document No.", Rec."No.");
                    SalesLine.Setrange(SalesLine.Type, SalesLine.Type::Item);
                    SalesLine.SetFilter(SalesLine.Quantity, '<>%1', 0);
                    if SalesLine.findset then
                        repeat
                            if Item.Get(SalesLine."No.") then begin
                                if Item.Type = Item.Type::Inventory then
                                    SalesLine.AutoReserve();
                            end;
                        until SalesLine.Next() = 0;
                end;

                if Rec."Order Status" <> xRec."Order Status" then
                    if xRec."Order Status" = xrec."Order Status"::"7 Packed" then
                        Message('Reservations on the lines will have to be cancelled manually');
            end;
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
        /*
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
        */
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
        field(50111; "Method Of Enquiry"; Enum "Method Of Enquiry")
        {
            DataClassification = CustomerContent;
        }
        field(50121; "Lost Opportunity"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50122; "Quote Reason Code"; Enum "Sales Lost Reason")
        {
            DataClassification = CustomerContent;
        }
        field(50131; "Packed Location"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        modify("Assigned User ID")
        {
            TableRelation = "User Setup"."User ID" where("Sales Doc Assigned" = const(true));
        }
    }
    var
        DimMgt: Codeunit DimensionManagement;

    procedure GetTotalSalesPaid() TotalPaid: Decimal
    var
        SalesPayments: Record "Sales Payments";
    begin
        TotalPaid := "Amount Paid";
        if Rec."No." <> '' then begin
            SalesPayments.Reset;
            SalesPayments.Setrange(SalesPayments."Document No.", Rec."No.");
            SalesPayments.Setrange(SalesPayments."Apply to this Invoice", True);
            SalesPayments.Setrange(SalesPayments."Payment Processed", True);
            if SalesPayments.findset then
                repeat
                    TotalPaid := TotalPaid + SalesPayments."Amount Paid";
                until SalesPayments.Next() = 0;
        end;
        exit(TotalPaid);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    trigger OnAfterInsert()
    var
        GenLedSetup: Record "General Ledger Setup";
    begin
        GenLedSetup.Get();
        Documents := GenLedSetup."SharePoint Document Path" + '' + "No.";
        Modify();
    end;

    procedure GetSalesLineItemPrompt() RetValue: Text;
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        TempItemNo: Code[20];
    begin
        SalesLine.Reset;
        SalesLine.SetCurrentKey(SalesLine."No.");
        SalesLine.Setrange(SalesLine."Document Type", "Document Type");
        SalesLine.Setrange(SalesLine."Document No.", "No.");
        SalesLine.Setrange(SalesLine.Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                if SalesLine."No." <> TempItemNo then
                    if Item.Get(SalesLine."No.") then begin
                        if DelChr(Item."User Prompt", '=', ' ') <> '' then
                            RetValue := RetValue + Item."No." + ' : ' + Item."User Prompt" + '|';
                    end;
                TempItemNo := SalesLine."No.";
            until SalesLine.Next() = 0;

        if RetValue <> '' then
            RetValue := CopyStr(RetValue, 1, StrLen(RetValue) - 1);
        exit(RetValue);
    end;

    procedure CheckInStockQuantity() RetValue: Text
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
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
                if Item.Get(SalesLine."No.") then begin
                    if Item."Manufacturing Policy" <> Item."Manufacturing Policy"::"Make-to-Order" then
                        if SalesLine."Qty. to Ship (Base)" > SalesLine.GetInStockQuantity() then begin
                            if RetValue <> '' then
                                RetValue := RetValue + TypeHelper.CRLFSeparator();

                            RetValue := RetValue + 'Item ' + SalesLine."No." + ' - ' + SalesLine."Product Code" +
                            ' (Line : ' + Format(SalesLine."Line No.") + ')';
                        end;
                end;
            until SalesLine.Next() = 0;
        if RetValue <> '' then
            RetValue := 'Not Enough Stock For Item Below : ' + TypeHelper.CRLFSeparator() + TypeHelper.CRLFSeparator() + RetValue;
        exit(RetValue);
    end;

    procedure CheckTrafalgarMandatoryFields()
    begin
        if Rec."Method Of Enquiry" = Rec."Method Of Enquiry"::" " then
            Message('"Method Of Enquiry" is blank in %1 %2', Rec."Document Type", Rec."No.");
        if Rec."Assigned User ID" = '' then
            Error('Please select Assigned User ID in %1 %2', Rec."Document Type", Rec."No.");
    end;

    trigger OnInsert()
    begin
        if Rec."Assigned User ID" = '' then
            "Assigned User ID" := UserId;
    end;


}