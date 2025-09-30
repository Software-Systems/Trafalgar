tableextension 55409 TabExtProdOrderRoutingLine extends "Prod. Order Routing Line"
{
    procedure GetDefaultRunTime() RetValueRunTime: Decimal
    var
        RoutingLine: Record "Routing Line";
    begin
        Clear(RetValueRunTime);
        RoutingLine.Reset;
        RoutingLine.Setrange(RoutingLine."Routing No.", Rec."Routing No.");
        RoutingLine.Setrange(RoutingLine."Operation No.", Rec."Operation No.");
        if RoutingLine.findset then
            RetValueRunTime := RoutingLine."Run Time";

        Exit(RetValueRunTime);
    end;

    procedure SetStyle() Style: Text
    var
        TotalRunTime: Decimal;
        RunTimeDifference: Decimal;
    begin
        TotalRunTime := GetDefaultRunTime() * "Input Quantity";
        RunTimeDifference := TotalRunTime - "Run Time";
        if ABS(RunTimeDifference) > 10 then
            exit('Unfavorable')
        else
            exit('favorable');
    end;
}