reportextension 56631 RepExtReturnOrderConfirmation extends "Return Order Confirmation"
{
    dataset
    {
        add("Sales Header")
        {
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
            column(ReturnOrderNo; "No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(CustomerInformation; CustomerInformation)
            {
            }
            column(CompanyAddressInformation; CompanyAddressInformation)
            {
            }
            column(CompInfoABN; CompInfo.ABN)
            {
            }
        }
        modify("Sales Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                Clear(CustomerInformation);
                CustomerInformation := CustomerInformation + "Sell-to Customer Name" + ' ' + "Sell-to Customer Name 2";
                if "Sell-to Address" <> '' then
                    CustomerInformation := CustomerInformation + TypeHelper.CRLFSeparator() + "Sell-to Address";
                if "Sell-to Address 2" <> '' then
                    CustomerInformation := CustomerInformation + TypeHelper.CRLFSeparator() + "Sell-to Address 2";
                if "Sell-to County" <> '' then
                    CustomerInformation := CustomerInformation + TypeHelper.CRLFSeparator() + "Sell-to County" + ' ' + "Sell-to Post Code";

            end;
        }
        add(RoundLoop)
        {
            column(ProductCode; ProductCode)
            {
            }
            column(DiscountedUnitPrice; DiscountedUnitPrice)
            {
            }
        }
        modify(RoundLoop)
        {
            trigger OnAfterAfterGetRecord()
            begin
                Clear(ProductCode);
                if "Sales Line".Type = "Sales Line".Type::Item then begin
                    if Item.get("Sales Line"."No.") then
                        ProductCode := Item."Product Code"
                    else
                        ProductCode := '';
                end;

                if "Sales Line"."Line Discount %" = 0 then
                    DiscountedUnitPrice := "Sales Line"."Unit Price"
                else
                    DiscountedUnitPrice := ((100 - "Sales Line"."Line Discount %") / 100) * "Sales Line"."Unit Price";
            end;
        }
    }
    rendering
    {
        layout("TG Return Order")
        {
            Type = RDLC;
            Caption = 'TG Return Order Confirmation';
            Summary = 'TG Return Order Confirmation';
            LayoutFile = 'src\reportextension\RepExt56631.RepExtReturnOrderConfirmation.rdl';
        }
    }

    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(CompInfo.Picture);

        CompanyAddressInformation := CompInfo.Address;
        if CompInfo."Address 2" <> '' then
            CompanyAddressInformation := CompanyAddressInformation + TypeHelper.CRLFSeparator() + CompInfo."Address 2";
        if CompInfo.County <> '' then
            CompanyAddressInformation := CompanyAddressInformation + TypeHelper.CRLFSeparator() + CompInfo.County + ' ' + CompInfo."Post Code";
        if CompInfo."Phone No." <> '' then
            CompanyAddressInformation := CompanyAddressInformation + TypeHelper.CRLFSeparator() + 'T : ' + CompInfo."Phone No.";
        if CompInfo."Home Page" <> '' then
            CompanyAddressInformation := CompanyAddressInformation + TypeHelper.CRLFSeparator() + '    ' + CompInfo."Home Page";
        if CompInfo."E-Mail" <> '' then
            CompanyAddressInformation := CompanyAddressInformation + TypeHelper.CRLFSeparator() + 'Email : ' + CompInfo."E-Mail";

    end;

    var
        Item: Record Item;
        ProductCode: Text;
        DiscountedUnitPrice: Decimal;
        CompInfo: Record "Company Information";
        CustomerInformation: Text;
        CompanyAddressInformation: Text;
        TypeHelper: Codeunit "Type Helper";
}
