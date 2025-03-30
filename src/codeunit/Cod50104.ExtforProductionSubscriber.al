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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", OnAfterCreateProdOrder, '', true, true)]
    local procedure CreateProdOrderfromSale_OnAfterCreateProdOrder(var ProdOrder: Record "Production Order"; var SalesLine: Record "Sales Line")
    var
        ProductionOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderStatusManagement: Codeunit "Prod. Order Status Management";
        WhseProductionRelease: Codeunit "Whse.-Production Release";
        WhseOutputProdRelease: Codeunit "Whse.-Output Prod. Release";
        ConfirmManagement: Codeunit "Confirm Management";
        RoutingNo: Code[20];
        ErrorOccured: Boolean;
        IsHandled: Boolean;
        Confirmed: Boolean;

        CalcLines: Boolean;
        CalcComponents: Boolean;
        CalcRoutings: Boolean;
        Direction: Option Forward,Backward;
        CalculateProdOrder: Codeunit "Calculate Prod. Order";
        CreateInbRqst: Boolean;
    begin
        CalcLines := True;
        CalcRoutings := True;
        CalcComponents := True;
        /*
        if Status = Status::Finished then
            CurrReport.Skip();

        TestField("Due Date");
        if CalcLines then
            if IsComponentPicked(ProdOrder) then begin
                IsHandled := false;
                OnProductionOrderOnAfterGetRecordOnBeforeAlreadyPickedLinesConfirm("Production Order", HideValidationDialog, Confirmed, IsHandled);
                if not IsHandled then
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := ConfirmManagement.GetResponseOrDefault(StrSubstNo(AlreadyPickedLinesQst, "No."), false);

                if not Confirmed then
                    CurrReport.Skip();
            end;

        if not HideValidationDialog then begin
            ProgressDialog.Update(1, Status);
            ProgressDialog.Update(2, "No.");
        end;
        */
        RoutingNo := GetRoutingNo(ProdOrder);
        UpdateRoutingNo(ProdOrder, RoutingNo);

        ProdOrderLine.LockTable();
        //OnBeforeCalcProdOrder(ProdOrder, Direction);
        //CheckReservationExist();

        if CalcLines then begin
            // OnBeforeCalcProdOrderLines(ProdOrder, Direction, CalcLines, CalcRoutings, CalcComponents, IsHandled, ErrorOccured);
            // if not IsHandled then
            //     if not CreateProdOrderLines.Copy(ProdOrder, Direction, ProdOrder."Variant Code", false) then
            //         ErrorOccured := true;
        end else begin
            ProdOrderLine.SetRange(Status, ProdOrder.Status);
            ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
            IsHandled := false;
            //OnBeforeCalcRoutingsOrComponents(ProdOrder, ProdOrderLine, CalcComponents, CalcRoutings, IsHandled);
            if not IsHandled then
                if CalcRoutings or CalcComponents then begin
                    if ProdOrderLine.Find('-') then
                        repeat
                            if CalcRoutings then begin
                                ProdOrderRoutingLine.SetRange(Status, ProdOrder.Status);
                                ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrder."No.");
                                ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                                ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                                if ProdOrderRoutingLine.FindSet(true) then
                                    repeat
                                        ProdOrderRoutingLine.SetSkipUpdateOfCompBinCodes(true);
                                        ProdOrderRoutingLine.Delete(true);
                                    until ProdOrderRoutingLine.Next() = 0;
                            end;
                            if CalcComponents then begin
                                ProdOrderComponent.SetRange(Status, ProdOrder.Status);
                                ProdOrderComponent.SetRange("Prod. Order No.", ProdOrder."No.");
                                ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                                ProdOrderComponent.DeleteAll(true);
                            end;
                        until ProdOrderLine.Next() = 0;
                    if ProdOrderLine.Find('-') then
                        repeat
                            if CalcComponents then
                                CheckProductionBOMStatus(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code");
                            if CalcRoutings then
                                CheckRoutingStatus(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code");
                            ProdOrderLine."Due Date" := ProdOrder."Due Date";
                            IsHandled := false;
                            //OnBeforeCalcProdOrderLine(ProdOrderLine, Direction, CalcLines, CalcRoutings, CalcComponents, IsHandled, ErrorOccured);
                            if not IsHandled then
                                if not CalculateProdOrder.Calculate(ProdOrderLine, Direction, CalcRoutings, CalcComponents, false, false) then
                                    ErrorOccured := true;
                        until ProdOrderLine.Next() = 0;
                end;
        end;
        //OnProductionOrderOnAfterGetRecordOnAfterCalcRoutingsOrComponents(ProdOrder, CalcLines, CalcRoutings, CalcComponents, ErrorOccured);

        ProdOrderRoutingLine.Reset;
        ProdOrderRoutingLine.Setrange(ProdOrderRoutingLine.Status, ProdOrder.Status);
        ProdOrderRoutingLine.Setrange(ProdOrderRoutingLine."Prod. Order No.", ProdOrder."No.");
        if ProdOrderRoutingLine.findset then
            repeat
                if ProdOrderRoutingLine."Run Time" <> 0 then begin
                    ProdOrderRoutingLine."Run Time" := ProdOrderRoutingLine."Run Time" * ProdOrderRoutingLine."Input Quantity";
                    ProdOrderRoutingLine.Modify();
                end;
            until ProdOrderRoutingLine.Next() = 0;

        if (Direction = Direction::Backward) and (ProdOrder."Source Type" = ProdOrder."Source Type"::Family) then begin
            //SetUpdateEndDate();
            ProdOrder.Validate("Due Date", ProdOrder."Due Date");
        end;

        if ProdOrder.Status = ProdOrder.Status::Released then begin
            ProdOrderStatusManagement.FlushProdOrder(ProdOrder, ProdOrder.Status, WorkDate());
            WhseProductionRelease.Release(ProdOrder);
            if CreateInbRqst then
                WhseOutputProdRelease.Release(ProdOrder);
        end;

        //OnAfterRefreshProdOrder("Production Order", ErrorOccured);
        //if ErrorOccured then
        // Message(SpecialWarehouseHandlingRequiredErr, ProductionOrder.TableCaption(), ProdOrderLine.FieldCaption("Bin Code"));
    end;

    local procedure CheckProductionBOMStatus(ProductionBOMNo: Code[20]; ProductionBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        if ProductionBOMNo = '' then
            exit;

        if ProductionBOMVersionNo = '' then begin
            ProductionBOMHeader.SetLoadFields(Status);
            ProductionBOMHeader.Get(ProductionBOMNo);
            ProductionBOMHeader.TestField(Status, ProductionBOMHeader.Status::Certified);
        end else begin
            ProductionBOMVersion.SetLoadFields(Status);
            ProductionBOMVersion.Get(ProductionBOMNo, ProductionBOMVersionNo);
            ProductionBOMVersion.TestField(Status, ProductionBOMVersion.Status::Certified);
        end;
    end;

    local procedure CheckRoutingStatus(RoutingNo: Code[20]; RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        if RoutingNo = '' then
            exit;

        if RoutingVersionNo = '' then begin
            RoutingHeader.SetLoadFields(Status);
            RoutingHeader.Get(RoutingNo);
            RoutingHeader.TestField(Status, RoutingHeader.Status::Certified);
        end else begin
            RoutingVersion.SetLoadFields(Status);
            RoutingVersion.Get(RoutingNo, RoutingVersionNo);
            RoutingVersion.TestField(Status, RoutingVersion.Status::Certified);
        end;
    end;



    local procedure UpdateRoutingNo(var ProductionOrder: Record "Production Order"; RoutingNo: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        //OnBeforeUpdateRoutingNo("Production Order", RoutingNo, IsHandled, CalcLines, CalcComponents, CalcRoutings);
        if IsHandled then
            exit;

        if RoutingNo <> ProductionOrder."Routing No." then begin
            ProductionOrder."Routing No." := RoutingNo;
            ProductionOrder.Modify();
        end;
    end;

    local procedure IsComponentPicked(ProductionOrder: Record "Production Order"): Boolean
    var
        ProdOrderComponent: Record "Prod. Order Component";
    begin
        ProdOrderComponent.SetRange(Status, ProductionOrder.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProductionOrder."No.");
        ProdOrderComponent.SetFilter("Qty. Picked", '<>0');
        exit(not ProdOrderComponent.IsEmpty());
    end;

    local procedure GetRoutingNo(ProductionOrder: Record "Production Order") RoutingNo: Code[20]
    var
        Item: Record Item;
        StockkeepingUnit: Record "Stockkeeping Unit";
        Family: Record Family;
    begin
        RoutingNo := ProductionOrder."Routing No.";
        case ProductionOrder."Source Type" of
            ProductionOrder."Source Type"::Item:
                begin
                    Item.SetLoadFields("Routing No.");
                    if Item.Get(ProductionOrder."Source No.") then
                        RoutingNo := Item."Routing No.";
                    StockkeepingUnit.SetLoadFields("Routing No.");
                    if StockkeepingUnit.Get(ProductionOrder."Location Code", ProductionOrder."Source No.", ProductionOrder."Variant Code") and
                        (StockkeepingUnit."Routing No." <> '')
                    then
                        RoutingNo := StockkeepingUnit."Routing No.";
                end;
            ProductionOrder."Source Type"::Family:
                begin
                    Family.SetLoadFields("Routing No.");
                    if Family.Get(ProductionOrder."Source No.") then
                        RoutingNo := Family."Routing No.";
                end;
        end;

        //OnAfterGetRoutingNo(ProductionOrder, RoutingNo);
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