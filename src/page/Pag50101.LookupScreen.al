page 50101 "Lookup Screen"
{
    ApplicationArea = All;
    Caption = 'Lookup Screen';
    PageType = Document;
    UsageCategory = Documents;
    Editable = true;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Search Box';
                field(SearchBarText; SearchBarText)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Customer)
            {
                action(CustomerNo)
                {
                    Caption = 'Customer No';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByCustomerNo();
                    end;
                }
                action(CustomerName)
                {
                    Caption = 'Customer Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByCustomerName();
                    end;
                }
                action(CustomerLedgerEntryNo)
                {
                    Caption = 'Cust. Ledg. Entry- Customer No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByCustomerLedgerEntryNo();
                    end;
                }
                action(CustomerLedgerEntryName)
                {
                    Caption = 'Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByCustomerLedgerEntryName()
                    end;
                }
                action(CustomerLedgerEntryAmount)
                {
                    Caption = 'Amount';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByCustomerLedgerEntryAmount()
                    end;
                }
                action(VendorNo)
                {
                    Caption = 'Vendor No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByVendorNo();
                    end;
                }
                action(VendorName)
                {
                    Caption = 'Vendor Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByVendorName();
                    end;
                }
                action(VendorLedgerEntryNo)
                {
                    Caption = 'Vend. Ledg. Entry- Vendor No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByVendorLedgerEntryNo();
                    end;
                }
                action(VendorLedgerEntryName)
                {
                    Caption = 'Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByVendorLedgerEntryName()
                    end;
                }
                action(VendorLedgerEntryAmount)
                {
                    Caption = 'Amount';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindByVendorLedgerEntryAmount()
                    end;
                }
                action(SalesQuoteNo)
                {
                    Caption = 'Sales Quote- No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesQuoteByNo();
                    end;
                }
                action(SalesQuoteCustomerNo)
                {
                    Caption = 'Customer No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesQuoteByCustomerNo();
                    end;
                }
                action(SalesQuoteCustomerName)
                {
                    Caption = 'Customer Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesQuoteByCustomerName();
                    end;
                }
                action(SalesQuoteCustomerAmount)
                {
                    Caption = 'Amount';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesQuoteByAmount();
                    end;
                }
                action(SalesOrderNo)
                {
                    Caption = 'Sales Order- No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesOrderByNo();
                    end;
                }
                action(SalesOrderCustomerNo)
                {
                    Caption = 'Customer No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesOrderByCustomerNo();
                    end;
                }
                action(SalesOrderCustomerName)
                {
                    Caption = 'Customer Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesOrderByCustomerName();
                    end;
                }
                action(SalesOrderCustomerAmount)
                {
                    Caption = 'Amount';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesOrderByAmount();
                    end;
                }
                action(SalesINvoiceNo)
                {
                    Caption = 'Posted Sales Invoice- No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesInvoiceByNo();
                    end;
                }
                action(SalesInvoiceCustomerNo)
                {
                    Caption = 'Customer No.';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesInvoiceByCustomerNo();
                    end;
                }
                action(SalesInvoiceCustomerName)
                {
                    Caption = 'Customer Name';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesInvoiceByCustomerName();
                    end;
                }
                action(SalesInvoiceCustomerAmount)
                {
                    Caption = 'Amount';
                    ApplicationArea = all;
                    Image = Find;
                    trigger OnAction()
                    begin
                        FindBySalesInvoiceByAmount();
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Filter', Comment = 'Generated from the PromotedActionCategories';

                group(Category_Category6)
                {
                    Caption = 'Customer', Comment = 'Filter Customers By';
                    ShowAs = SplitButton;

                    actionref(CustomerNo_Promoted; CustomerNo)
                    {
                    }
                    actionref(CustomerName_Promoted; CustomerName)
                    {
                    }
                }
                group(Category_Category7)
                {
                    Caption = 'Customer Ledger Entry', Comment = 'Filter Customers Ledger Entry By';
                    ShowAs = SplitButton;

                    actionref(CustomerLedgerEntryNo_Promoted; CustomerLedgerEntryNo)
                    {
                    }
                    actionref(CustomerLedgerEntryName_Promoted; CustomerLedgerEntryName)
                    {
                    }
                    actionref(CustomerLedgerEntryAmount_Promoted; CustomerLedgerEntryAmount)
                    {
                    }
                }
                group(Category_Category8)
                {
                    Caption = 'Vendor', Comment = 'Filter Vendors By';
                    ShowAs = SplitButton;

                    actionref(VendorNo_Promoted; VendorNo)
                    {
                    }
                    actionref(VendorName_Promoted; VendorName)
                    {
                    }
                }
                group(Category_Category9)
                {
                    Caption = 'Vendor Ledger Entry', Comment = 'Filter Vendor Ledger Entry By';
                    ShowAs = SplitButton;

                    actionref(VendorLedgerEntryNo_Promoted; VendorLedgerEntryNo)
                    {
                    }
                    actionref(VendorLedgerEntryName_Promoted; VendorLedgerEntryName)
                    {
                    }
                    actionref(VendorLedgerEntryAmount_Promoted; VendorLedgerEntryAmount)
                    {
                    }
                }
                group(Category_Category10)
                {
                    Caption = 'Sales Quote', Comment = 'Filter Sales Quote By';
                    ShowAs = SplitButton;

                    actionref(SalesQuote_Promoted; SalesQuoteNo)
                    {
                    }
                    actionref(SalesQuoteCustomerNo_Promoted; SalesQuoteCustomerNo)
                    {
                    }
                    actionref(SalesQuoteCustomerName_Promoted; SalesQuoteCustomerName)
                    {
                    }
                    actionref(SalesQuoteCustomerAmount_Promoted; SalesQuoteCustomerAmount)
                    {
                    }
                }
                group(Category_Category11)
                {
                    Caption = 'Sales Order', Comment = 'Filter Sales Order By';
                    ShowAs = SplitButton;

                    actionref(SalesOrderNo_Promoted; SalesOrderNo)
                    {
                    }
                    actionref(SalesOrderCustomerNo_Promoted; SalesOrderCustomerNo)
                    {
                    }
                    actionref(SalesOrderCustomerName_Promoted; SalesOrderCustomerName)
                    {
                    }
                    actionref(SalesOrderCustomerAmount_Promoted; SalesOrderCustomerAmount)
                    {
                    }
                }
                group(Category_Category12)
                {
                    Caption = 'Posted Sales Invoices', Comment = 'Filter Posted Sales Invoices By';
                    ShowAs = SplitButton;

                    actionref(SalesInvoiceNo_Promoted; SalesInvoiceNo)
                    {
                    }
                    actionref(SalesInvoiceCustomerNo_Promoted; SalesInvoiceCustomerNo)
                    {
                    }
                    actionref(SalesInvoiceCustomerName_Promoted; SalesInvoiceCustomerName)
                    {
                    }
                    actionref(SalesInvoiceCustomerAmount_Promoted; SalesInvoiceCustomerAmount)
                    {
                    }
                }
            }
        }
    }

    var
        SearchBarText: Text;
        ErrorMessageLbl: Label 'There are no records found within the filter %1', Comment = '%1 = Searchbartext';

    local procedure FindByCustomerName()
    var
        Customer: Record Customer;
        CustomerList: Page "Customer List";
    begin
        Customer.Reset();
        Customer.SetFilter(Name, '%1', SearchBarText);
        if Customer.FindSet() then begin
            CustomerList.SetTableView(Customer);
            CustomerList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByCustomerNo()
    var
        Customer: Record Customer;
        CustomerList: Page "Customer List";
    begin
        Customer.Reset();
        Customer.SetFilter("No.", '%1', SearchBarText);
        if Customer.FindSet() then begin
            CustomerList.SetTableView(Customer);
            CustomerList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByCustomerLedgerEntryNo()
    var
        CustomerLEdger: Record "Cust. Ledger Entry";
        CustomerList: Page "Customer Ledger Entries";
    begin
        CustomerLEdger.Reset();
        CustomerLEdger.SetFilter("Customer No.", '%1', SearchBarText);
        if CustomerLEdger.FindSet() then begin
            CustomerList.SetTableView(CustomerLEdger);
            CustomerList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByCustomerLedgerEntryName()
    var
        CustomerLEdger: Record "Cust. Ledger Entry";
        CustomerList: Page "Customer Ledger Entries";
    begin
        CustomerLEdger.Reset();
        CustomerLEdger.SetFilter("Customer Name", '%1', SearchBarText);
        if CustomerLEdger.FindSet() then begin
            CustomerList.SetTableView(CustomerLEdger);
            CustomerList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByCustomerLedgerEntryAmount()
    var
        CustomerLEdger: Record "Cust. Ledger Entry";
        CustomerList: Page "Customer Ledger Entries";
        SearchDec: Decimal;
    begin
        Evaluate(SearchDec, SearchBarText);
        CustomerLEdger.Reset();
        CustomerLEdger.SetFilter(Amount, '%1', SearchDec);
        if CustomerLEdger.FindSet() then begin
            CustomerList.SetTableView(CustomerLEdger);
            CustomerList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByVendorName()
    var
        Vendor: Record Vendor;
        VendorList: Page "Vendor List";
    begin
        Vendor.Reset();
        Vendor.SetFilter(Name, '%1', SearchBarText);
        if Vendor.FindSet() then begin
            VendorList.SetTableView(Vendor);
            VendorList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByVendorNo()
    var
        Vendor: Record Vendor;
        VendorList: Page "Vendor List";
    begin
        Vendor.Reset();
        Vendor.SetFilter("No.", '%1', SearchBarText);
        if Vendor.FindSet() then begin
            VendorList.SetTableView(Vendor);
            VendorList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByVendorLedgerEntryNo()
    var
        VEndorLEdger: Record "Vendor Ledger Entry";
        VendorList: Page "Vendor Ledger Entries";
    begin
        VEndorLEdger.Reset();
        VEndorLEdger.SetFilter("Vendor No.", '%1', SearchBarText);
        if VEndorLEdger.FindSet() then begin
            VendorList.SetTableView(VEndorLEdger);
            VendorList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByVendorLedgerEntryName()
    var
        VendorLedger: Record "Vendor Ledger Entry";
        VendorList: Page "Vendor Ledger Entries";
    begin
        VendorLedger.Reset();
        VendorLedger.SetFilter("Vendor Name", '%1', SearchBarText);
        if VendorLedger.FindSet() then begin
            VendorList.SetTableView(VendorLedger);
            VendorList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindByVendorLedgerEntryAmount()
    var
        VendorLedger: Record "Vendor Ledger Entry";
        VendorList: Page "Vendor Ledger Entries";
        SearchDec: Decimal;
    begin
        Evaluate(SearchDec, SearchBarText);
        VendorLedger.Reset();
        VendorLedger.SetFilter(Amount, '%1', SearchDec);
        if VendorLedger.FindSet() then begin
            VendorList.SetTableView(VendorLedger);
            VendorList.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesOrderByNo()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order List";
    begin
        SalesHeader.SetFilter("No.", SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesOrderByCustomerName()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order List";
    begin
        SalesHeader.SetFilter("Sell-to Customer Name", SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesOrderByCustomerNo()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order List";
    begin
        SalesHeader.SetFilter("Sell-to Customer No.", SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesOrderByAmount()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order List";
        AmountDec: Decimal;
    begin
        Evaluate(AmountDec, SearchBarText);
        SalesHeader.SetFilter("Amount Including VAT", '%1', AmountDec);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesQuoteByNo()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Quotes";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter("No.", SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesQuoteByCustomerName()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Quotes";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter("Sell-to Customer Name", SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesQuoteByCustomerNo()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Quotes";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter("Sell-to Customer No.", SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesQuoteByAmount()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Quotes";
        AmountDec: Decimal;
    begin
        Evaluate(AmountDec, SearchBarText);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetFilter(Amount, '%1', AmountDec);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesInvoiceByNo()
    var
        SalesHeader: Record "Sales Invoice Header";
        SalesOrder: Page "Posted Sales Invoices";
    begin
        SalesHeader.SetFilter("No.", '%1', SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesInvoiceByCustomerName()
    var
        SalesHeader: Record "Sales Invoice Header";
        SalesOrder: Page "Posted Sales Invoices";
    begin
        SalesHeader.SetFilter("Sell-to Customer Name", '%1', SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesInvoiceByCustomerNo()
    var
        SalesHeader: Record "Sales Invoice Header";
        SalesOrder: Page "Posted Sales Invoices";
    begin
        SalesHeader.SetFilter("Sell-to Customer No.", '%1', SearchBarText);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;

    local procedure FindBySalesInvoiceByAmount()
    var
        SalesHeader: Record "Sales Invoice Header";
        SalesOrder: Page "Posted Sales Invoices";
        AmountDec: Decimal;
    begin
        Evaluate(AmountDec, SearchBarText);
        SalesHeader.SetFilter("Amount Including VAT", '%1', AmountDec);
        if SalesHeader.FindSet() then begin
            SalesOrder.SetTableView(SalesHeader);
            SalesOrder.Run();
        end else
            Message(ErrorMessageLbl, SearchBarText);
    end;
}
