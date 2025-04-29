pageextension 50402 PagExtSalesOrderStatistics extends "Sales Order Statistics"
{
    layout
    {
        modify(InvDiscountAmount_General)
        {
            trigger OnBeforeValidate()
            begin
                CheckInvDiscountPermission
            end;
        }
        modify(InvDiscountAmount_Invoicing)
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
