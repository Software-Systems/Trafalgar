pageextension 50160 PagExtSalesStatistics extends "Sales Statistics"
{
    layout
    {
        modify(InvDiscountAmount)
        {
            trigger OnBeforeValidate()
            begin
                CheckInvDiscountPermission
            end;
        }
    }

    local procedure CheckInvDiscountPermission()
    begin
        if TrafalgarGeneralCodeunit.CheckUserCanApplyGenericDiscount() = false then
            Error('You do not have permission to create system wide discounts, please chat to Kate');
    end;

    var
        TrafalgarGeneralCodeunit: Codeunit "Trafalgar General Codeunit";
}
