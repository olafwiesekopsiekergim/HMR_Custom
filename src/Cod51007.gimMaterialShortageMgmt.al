/// <summary>
/// Codeunit gimMaterialShortageMgmt (ID 51007).
/// </summary>
codeunit 51007 gimMaterialShortageMgmt
{

    trigger OnRun()
    begin

    end;

    Procedure getMaterialShortage(var gimMaterialShortage: record gimMaterialShortage temporary; ProdOrder: record "Production Order")
    var
        ProdOrderLine: record "Prod. Order Line";
        ProdOrderComp: record "Prod. Order Component";
    begin
        ProdOrder.setrange(Status, prodorder.status);
        ProdOrder.Setrange("No.", ProdOrder."No.");
        IF ProdOrder.FINDFIRST then
            repeat
                ProdOrderline.setrange(Status, ProdOrder.Status);
                ProdOrderLine.setrange("Prod. Order No.", ProdOrder."No.");
                IF ProdOrderLine.findset() then
                    repeat
                        ProdOrderComp.setrange(Status, ProdOrder.status);
                        ProdOrderComp.setrange("Prod. Order No.", ProdOrder."No.");
                        ProdOrderComp.Setrange("Prod. Order Line No.", ProdOrderline."Line No.");
                        IF ProdOrderComp.findset() then
                            repeat
                                createMaterialShortage(gimMaterialShortage, ProdOrder, ProdOrderLine, ProdOrderComp);
                            until ProdOrderComp.next = 0;
                    until ProdOrderLine.next = 0;
            until ProdOrder.Next() = 0;
        gimMaterialShortage.SETFILTER(ProdOrderDueDate, ProdOrder.getfilter("Date Filter"));
        gimMaterialShortage.SETFILTER(CompItemRemQtyBase, '>0');
    end;








    local procedure CalcProdOrderLineFields(var ProdOrderLineFields: Record "Prod. Order Line")
    var
        ProdOrderLine: Record "Prod. Order Line";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        ProdOrderLine.Copy(ProdOrderLineFields);

        if ProdOrderLine.FindSet() then
            repeat
                ProdOrderLine.CalcFields("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderLine."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderLine."Reserved Qty. (Base)";
            until ProdOrderLine.Next() = 0;

        ProdOrderLineFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderLineFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;

    local procedure CalcProdOrderCompFields(var ProdOrderCompFields: Record "Prod. Order Component")
    var
        ProdOrderComp: Record "Prod. Order Component";
        RemainingQtyBase: Decimal;
        ReservedQtyBase: Decimal;
    begin
        ProdOrderComp.Copy(ProdOrderCompFields);

        if ProdOrderComp.FindSet() then
            repeat
                ProdOrderComp.CalcFields("Reserved Qty. (Base)");
                RemainingQtyBase += ProdOrderComp."Remaining Qty. (Base)";
                ReservedQtyBase += ProdOrderComp."Reserved Qty. (Base)";
            until ProdOrderComp.Next() = 0;

        ProdOrderCompFields."Remaining Qty. (Base)" := RemainingQtyBase;
        ProdOrderCompFields."Reserved Qty. (Base)" := ReservedQtyBase;
    end;

    local procedure createMaterialShortage(var gimMaterialShortage: record gimMaterialShortage temporary; var ProdOrder: record "Production Order"; var ProdOrderLine: record "Prod. Order Line"; var ProdOrderComp: record "Prod. Order Component")
    var
        TempProdOrderLine: Record "Prod. Order Line" temporary;
        TempProdOrderComp: Record "Prod. Order Component" temporary;
        compItem: Record Item;
        skip: boolean;
    begin
        skip := false;
        ProdOrderComp.SetRange("Item No.", ProdOrderComp."Item No.");
        ProdOrderComp.SetRange("Variant Code", ProdOrderComp."Variant Code");
        ProdOrderComp.SetRange("Location Code", ProdOrderComp."Location Code");
        ProdOrderComp.FindLast();
        ProdOrderComp.SetRange("Item No.");
        ProdOrderComp.SetRange("Variant Code");
        ProdOrderComp.SetRange("Location Code");

        CompItem.Get(ProdOrderComp."Item No.");
        if CompItem.IsNonInventoriableType() then
            skip := true;

        CompItem.SetRange("Variant Filter", ProdOrderComp."Variant Code");
        CompItem.SetRange("Location Filter", ProdOrderComp."Location Code");
        CompItem.SetRange(
        "Date Filter", 0D, ProdOrderComp."Due Date" - 1);

        CompItem.CalcFields(
        Inventory, "Reserved Qty. on Inventory",
        "Scheduled Receipt (Qty.)", "Reserved Qty. on Prod. Order",
        "Qty. on Component Lines", "Res. Qty. on Prod. Order Comp.");
        CompItem.Inventory :=
        CompItem.Inventory -
        CompItem."Reserved Qty. on Inventory";
        CompItem."Scheduled Receipt (Qty.)" :=
        CompItem."Scheduled Receipt (Qty.)" -
        CompItem."Reserved Qty. on Prod. Order";
        CompItem."Qty. on Component Lines" :=
        CompItem."Qty. on Component Lines" -
        CompItem."Res. Qty. on Prod. Order Comp.";

        CompItem.SetRange(
        "Date Filter", 0D, ProdOrderComp."Due Date");
        CompItem.CalcFields(
        "Qty. on Sales Order", "Reserved Qty. on Sales Orders",
        "Qty. on Purch. Order", "Reserved Qty. on Purch. Orders");
        CompItem."Qty. on Sales Order" :=
        CompItem."Qty. on Sales Order" -
        CompItem."Reserved Qty. on Sales Orders";
        CompItem."Qty. on Purch. Order" :=
        CompItem."Qty. on Purch. Order" -
        CompItem."Reserved Qty. on Purch. Orders";

        TempProdOrderLine.SetCurrentKey(
        "Item No.", "Variant Code", "Location Code", Status, "Ending Date");

        TempProdOrderLine.SetRange(Status, TempProdOrderLine.Status::Planned, ProdOrderComp.Status.AsInteger() - 1);
        TempProdOrderLine.SetRange("Item No.", ProdOrderComp."Item No.");
        TempProdOrderLine.SetRange("Variant Code", ProdOrderComp."Variant Code");
        TempProdOrderLine.SetRange("Location Code", ProdOrderComp."Location Code");
        TempProdOrderLine.SetRange("Due Date", ProdOrderComp."Due Date");
        CalcProdOrderLineFields(TempProdOrderLine);
        CompItem."Scheduled Receipt (Qty.)" :=
        CompItem."Scheduled Receipt (Qty.)" +
        TempProdOrderLine."Remaining Qty. (Base)" -
        TempProdOrderLine."Reserved Qty. (Base)";

        TempProdOrderLine.SetRange(Status, ProdOrderComp.Status);
        TempProdOrderLine.SetRange("Prod. Order No.", ProdOrderComp."Prod. Order No.");
        CalcProdOrderLineFields(TempProdOrderLine);
        CompItem."Scheduled Receipt (Qty.)" :=
        CompItem."Scheduled Receipt (Qty.)" +
        TempProdOrderLine."Remaining Qty. (Base)" -
        TempProdOrderLine."Reserved Qty. (Base)";

        TempProdOrderComp.SetCurrentKey(
        "Item No.", "Variant Code", "Location Code", Status, "Due Date");

        TempProdOrderComp.SetRange(Status, TempProdOrderComp.Status::Planned, ProdOrderComp.Status.AsInteger() - 1);
        TempProdOrderComp.SetRange("Item No.", ProdOrderComp."Item No.");
        TempProdOrderComp.SetRange("Variant Code", ProdOrderComp."Variant Code");
        TempProdOrderComp.SetRange("Location Code", ProdOrderComp."Location Code");
        TempProdOrderComp.SetRange("Due Date", ProdOrderComp."Due Date");
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
        CompItem."Qty. on Component Lines" +
        TempProdOrderComp."Remaining Qty. (Base)" -
        TempProdOrderComp."Reserved Qty. (Base)";

        TempProdOrderComp.SetRange(Status, ProdOrderComp.Status);
        TempProdOrderComp.SetFilter("Prod. Order No.", '<%1', ProdOrderComp."Prod. Order No.");
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
        CompItem."Qty. on Component Lines" +
        TempProdOrderComp."Remaining Qty. (Base)" -
        TempProdOrderComp."Reserved Qty. (Base)";

        TempProdOrderComp.SetRange("Prod. Order No.", ProdOrderComp."Prod. Order No.");
        TempProdOrderComp.SetRange("Prod. Order Line No.", 0, ProdOrderComp."Prod. Order Line No." - 1);
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
        CompItem."Qty. on Component Lines" +
        TempProdOrderComp."Remaining Qty. (Base)" -
        TempProdOrderComp."Reserved Qty. (Base)";

        TempProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderComp."Prod. Order Line No.");
        TempProdOrderComp.SetRange("Item No.", ProdOrderComp."Item No.");
        TempProdOrderComp.SetRange("Variant Code", ProdOrderComp."Variant Code");
        TempProdOrderComp.SetRange("Location Code", ProdOrderComp."Location Code");
        CalcProdOrderCompFields(TempProdOrderComp);
        CompItem."Qty. on Component Lines" :=
        CompItem."Qty. on Component Lines" +
        TempProdOrderComp."Remaining Qty. (Base)" -
        TempProdOrderComp."Reserved Qty. (Base)";
        gimMaterialShortage.init;
        gimMaterialShortage.ProdOrderStatus := ProdOrder.status;
        gimMaterialShortage.ProdOrderNo := ProdOrder."No.";
        gimMaterialShortage.ProdOrderLine := ProdOrderLine."Line No.";
        gimMaterialShortage.CompItemLine := ProdOrderComp."Line No.";
        gimMaterialShortage.ProdOrderDescription := ProdOrder.Description;
        gimMaterialshortage.ProdOrderDueDate := prodOrder."Due Date";

        gimMaterialShortage.CompItemRemQtyBase :=
        //Remaining Quantity
        TempProdOrderComp."Remaining Qty. (Base)" -
        TempProdOrderComp."Reserved Qty. (Base)";

        gimMaterialShortage.CompItemInvRemQtyBase :=
        //QtyOnHandAfterProd
        CompItem.Inventory -
        TempProdOrderComp."Remaining Qty. (Base)" +
        TempProdOrderComp."Reserved Qty. (Base)";

        gimMaterialShortage.CompItemNeededQty :=
        //NeededQty
        CompItem."Qty. on Component Lines" +
        CompItem."Qty. on Sales Order" -
        CompItem."Qty. on Purch. Order" -
        CompItem."Scheduled Receipt (Qty.)" -
        CompItem.Inventory;

        if gimMaterialShortage.CompItemNeededQty < 0 then
            gimMaterialShortage.CompItemNeededQty := 0;

        if (gimMaterialShortage.CompItemNeededQty = 0) and (gimMaterialShortage.CompItemInvRemQtyBase >= 0) or
        (gimMaterialShortage.CompItemRemQtyBase = 0)
        then
            skip := true;

        if not skip then gimMaterialShortage.INSERT;
    end;
}

