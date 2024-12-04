codeunit 50102 "Change Field Color"
{
    procedure ChangeSalesOrderStatuColor(SalesHeader: Record "Sales Header"): Text[50]
    var
        myInt: Integer;
    begin

        case SalesHeader."Order Status" of
            SalesHeader."Order Status"::"1 Prod Planned":
                exit('Unfavorable');
            SalesHeader."Order Status"::"2 Prod Released":
                exit('Unfavorable');
            SalesHeader."Order Status"::"3 Prod Completed":
                exit('Unfavorable');
            SalesHeader."Order Status"::"4 Not Enough Stock":
                exit('Unfavorable');
            SalesHeader."Order Status"::"5 In WH":
                exit('StrongAccent');
            SalesHeader."Order Status"::"6 Moved to WH":
                exit('StrongAccent');
            SalesHeader."Order Status"::"7 Packed":
                exit('Favorable');
        end;
    end;
}