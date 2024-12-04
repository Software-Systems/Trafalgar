codeunit 50104 "Ext for Production Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", OnBeforeProdOrderLineInsert, '', false, false)]
    local procedure OnBeforeProdOrderLineInsert(var ProdOrderLine: Record "Prod. Order Line"; var ProductionOrder: Record "Production Order"; SalesLineIsSet: Boolean; var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        Item.Get(ProdOrderLine."Item No.");
        ProdOrderLine."Product Code" := Item."Product Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", OnCopyFromProdOrder, '', true, true)]
    local procedure OnCopyFromProdOrder(FromProdOrder: Record "Production Order"; var ToProdOrder: Record "Production Order")
    begin
        ToProdOrder.Documents := FromProdOrder.Documents;
        ToProdOrder."Production Type" := FromProdOrder."Production Type";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", OnAfterCreateProdOrderFromSalesLine, '', true, true)]
    local procedure OnAfterCreateProdOrderFromSalesLine(var SalesLine: Record "Sales Line"; var ProdOrder: Record "Production Order")
    var
        Salesheader: Record "Sales Header";
    begin
        Salesheader.SetRange("No.", SalesLine."Document No.");
        if Salesheader.FindFirst() then
            ProdOrder.Documents := Salesheader.Documents;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", OnBeforeOnRun, '', true, true)]
    local procedure OnBeforeRun(var ProductionOrder: Record "Production Order")
    begin
        ProductionOrder."Delete Confirmation" := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", OnBeforeDeleteEvent, '', true, true)]
    local procedure MyProcedure(var Rec: Record "Production Order")
    var
        Confirmation: Codeunit "Confirm Management";
    begin
        if not Rec."Delete Confirmation" then
            if not Confirmation.GetResponse('Are you sure you want to delete?', false) then
                Error('Production Order Not Deleted!');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", OnAfterModifyEvent, '', true, true)]
    local procedure OnAfterModifyProdOrderLine(var Rec: Record "Prod. Order Routing Line")
    begin
        if Rec."Run Time" <> 0 then
            Rec."Run Time" := Rec."Run Time" * Rec."Input Quantity";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", OnAfterValidateEvent, "Input Quantity", true, true)]
    local procedure OnAfterInsertLine(var Rec: Record "Prod. Order Routing Line")
    begin
        if Rec."Run Time" <> 0 then
            Rec."Run Time" := Rec."Run Time" * Rec."Input Quantity";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", OnAfterCopyFromPlanningRoutingLine, '', true, true)]
    local procedure OnAfterCopyFromPlanningRoutingLine(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; PlanningRoutingLine: Record "Planning Routing Line")
    begin
        ProdOrderRoutingLine."Run Time" := PlanningRoutingLine."Run Time" * PlanningRoutingLine."Input Quantity";
    end;

    // [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", OnAfterRefreshProdOrder, '', true, true)]
    // local procedure OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order")
    // var
    //     GeneLedSEtup: Record "General Ledger Setup";
    // begin
    //     if ProductionOrder.Documents = '' then begin
    //         if ProductionOrder."Sales Order No." <> '' then
    //             ProductionOrder.Documents := ProductionOrder."Sales Order No."
    //         else begin
    //             GeneLedSEtup.GetRecordOnce();
    //             ProductionOrder.Documents := GeneLedSEtup."SharePoint Document Path" + ProductionOrder."No.";
    //             ProductionOrder."Sales Order No." := ProductionOrder."No.";
    //         end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", OnInsertOutputItemJnlLineOnAfterAssignTimes, '', false, false)]
    local procedure ProductionJournalMgt_OnInsertOutputItemJnlLineOnAfterAssignTimes(var ItemJournalLine: Record "Item Journal Line";
    ProdOrderRoutingLine: Record "Prod. Order Routing Line"; ProdOrderLine: Record "Prod. Order Line")
    begin
        ItemJournalLine.VALIDATE(ItemJournalLine."Setup Time", ProdOrderRoutingLine."Setup Time");
        //ItemJournalLine.VALIDATE(ItemJournalLine."Run Time", ProdOrderRoutingLine."Run Time" * ProdOrderLine."Quantity");
        ItemJournalLine.VALIDATE(ItemJournalLine."Run Time", ProdOrderRoutingLine."Run Time");
    end;
}