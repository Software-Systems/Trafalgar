tableextension 50112 TabExtSalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
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
        field(78010; "Sales Order Created By"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = False;
        }
        field(78020; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "User Setup";
        }
    }

    procedure GetTotalSalesPaid() TotalPaid: Decimal
    var
        SalesPayments: Record "Sales Payments";
    begin
        TotalPaid := "Amount Paid";
        SalesPayments.Reset;
        if Rec."Order No." <> '' then
            SalesPayments.Setrange(SalesPayments."Document No.", Rec."Order No.")
        else
            SalesPayments.Setrange(SalesPayments."Document No.", Rec."No.");
        SalesPayments.Setrange(SalesPayments."Apply to this Invoice", True);
        SalesPayments.Setrange(SalesPayments."Payment Processed", True);
        if SalesPayments.findset then
            repeat
                TotalPaid := TotalPaid + SalesPayments."Amount Paid";
            until SalesPayments.Next() = 0;
        exit(TotalPaid);
    end;
}
