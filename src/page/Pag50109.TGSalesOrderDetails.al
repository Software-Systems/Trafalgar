page 50109 "TG Sales Order Details"
{
    ApplicationArea = All;
    Caption = 'Sales Order Details';
    PageType = Card;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            group(Search)
            {
                field(ScanText; ScanText)
                {
                    Caption = 'Scan Text';
                    ApplicationArea = All;
                    Style = Strong;
                    trigger OnValidate()
                    var
                        SalesLine: Record "Sales Line";
                    begin
                        if Copystr(UpperCase(ScanText), 1, 2) = 'SO' then begin
                            Rec.Reset;
                            Rec.Setrange(Rec."Document Type", Rec."Document Type"::Order);
                            Rec.Setrange(Rec."No.", ScanText);
                            if Rec.FindSet() then begin
                                if Rec.Status <> Rec.Status::Released then begin
                                    Message('The Order Needs to Released before it can be packed.');
                                    ClearPage();
                                end
                                else
                                    ScanText := ''; //Record Found
                            end
                            else begin
                                Message('Sales Order %1 is not exist.', ScanText);
                                ClearPage();
                            end;

                            CurrPage.Update(False);
                        end
                        else begin
                            SalesHeader.Reset;
                            if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."No.") then begin
                                SalesHeader."Packed Location" := ScanText;
                                SalesHeader."Order Status" := SalesHeader."Order Status"::"7 Packed";
                                SalesHeader.Modify();

                                //Reserve All Sales Lines
                                SalesLine.Reset;
                                SalesLine.Setrange(SalesLine."Document Type", Rec."Document Type");
                                SalesLine.Setrange(SalesLine."Document No.", Rec."No.");
                                SalesLine.Setrange(SalesLine.Type, SalesLine.Type::Item);
                                SalesLine.SetFilter(SalesLine."Product Code", '<> %1', 'DELIVERY');
                                if SalesLine.findset then
                                    repeat
                                        SalesLine.AutoReserve();
                                    until SalesLine.Next() = 0;

                                ClearPage();
                                CurrPage.Update();
                            end;
                        end;
                    end;
                }
            }
            group(Details)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                group(Customer)
                {
                    field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                    {
                        ApplicationArea = All;
                        Editable = False;
                    }
                    field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                    {
                        ApplicationArea = All;
                        Editable = False;
                    }
                }
                field("Packed Location"; Rec."Packed Location")
                {
                    ApplicationArea = All;
                    Editable = False;
                    MultiLine = True;
                    Style = StrongAccent;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ClearPage();
    end;

    local procedure ClearPage()
    begin
        ScanText := '';
        Rec.Reset;
        Rec.Setrange(Rec."Document Type", Rec."Document Type"::Order);
        Rec.Setrange(Rec."Sell-to Customer No.", 'XYZ-123');
    end;

    var
        ScanText: Text;
        SalesHeader: Record "Sales Header";
}
