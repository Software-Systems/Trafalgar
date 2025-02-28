enum 50100 "Order Status"
{
    Extensible = false;

    value(0; " ")
    { }
    value(1; "1 Prod Planned")
    {
        Caption = 'Prod Planned';
    }
    value(2; "2 Prod Released")
    {
        Caption = 'Prod Released';
    }
    value(3; "3 Prod Completed")
    {
        Caption = 'Prod Completed';
    }
    value(4; "4 Not Enough Stock")
    {
        Caption = 'Not Enough Stock';
    }
    value(5; "5 In WH")
    {
        Caption = 'In WH';
    }
    value(6; "6 Moved to WH")
    {
        Caption = 'Moved to WH';
    }
    value(7; "7 Packed")
    {
        Caption = 'Packed';
    }
    value(8; "8 Printed")
    {
        Caption = 'Printed';
    }
    value(9; "9 Partial")
    {
        Caption = 'Partial';
    }
}