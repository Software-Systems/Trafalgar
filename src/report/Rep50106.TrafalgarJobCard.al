report 50106 "Trafalgar Job Card"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Trafalgar Job Card Report';
    RDLCLayout = '.\Reports\Layouts\TrafalgarJobCard.rdl';
    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            column(No_; "No.")
            { }
            column(Description; Description)
            { }
            column(Description_2; "Description 2")
            { }
            column(Source_Type; "Source Type")
            { }
            column(SourceNo; "Source No.")
            { }
            column(Quantity; Quantity)
            { }
            column(DueDate; "Due Date")
            { }
            column(ProdCode; CopyStr(Item."Product Code", 1, 100))
            { }
            column(SalesOrderNo_ProductionOrder; "Sales Order No.")
            {
            }
            column(WorkDescription; "Work Description")
            {
            }
            trigger OnAfterGetRecord()
            begin
                Clear(WorkDescription);
                if Item.Get("Source No.") then;
                //WorkDescription := GetWorkDescription("Production Order");
            end;
        }
    }
    // procedure GetWorkDescription(ProductionOrder: Record "Production Order") WorkDescription: Text
    // var
    //     TypeHelper: Codeunit "Type Helper";
    //     InStream: InStream;
    // begin
    //     ProductionOrder.CalcFields("Work Description");
    //     ProductionOrder."Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
    //     exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), ProductionOrder.FieldName("Work Description")));
    // end;

    var
        Item: Record Item;
        WorkDescription: Text;
}