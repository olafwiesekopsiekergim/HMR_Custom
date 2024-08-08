/// <summary>
/// Codeunit gimHMREvents (ID 51008).
/// </summary>
codeunit 51008 gimHMREvents
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", 'OnAfterCreateProdOrderFromSalesLine', '', false, false)]

    local procedure OnAfterCreateProdOrderFromSalesLine(var ProdOrder: Record "Production Order"; var SalesLine: Record "Sales Line")
    begin
        ProdOrder.gimOrderNo := Salesline."Document No.";


    end;

    [EventSubscriber(ObjectType::table, database::"Prod. Order Routing Line", 'OnAfterWorkCenterTransferFields', '', false, false)]

    local procedure OnAfterWorkCenterTransferFields(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; WorkCenter: Record "Work Center")
    begin
        ProdOrderRoutingLine.Validate(gimIsLine, WorkCenter.gimisLine);
    end;

    [EventSubscriber(ObjectType::table, database::"Prod. Order Routing Line", 'OnAfterCopyFromRoutingLine', '', false, false)]

    local procedure OnAfterCopyFromRoutingLine(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; RoutingLine: Record "Routing Line")
    var
        workcenter: Record "Work Center";
    begin
        if ProdOrderRoutingline.Type = ProdOrderRoutingLine.type::"Work Center" then
            if Workcenter.get(ProdOrderRoutingLine."Work Center No.") then BEGIN
                ProdOrderRoutingLine.Validate(gimIsLine, WorkCenter.gimisLine);
                // ProdOrderRoutingLine.modify;
            End;

    end;

    [EventSubscriber(ObjectType::Report, report::"Refresh Production Order", 'OnAfterRefreshProdOrder', '', false, false)]

    local procedure OnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    var
        ProdOrderRoutingLine: record "Prod. Order Routing Line";
        WorkCenter: record "Work Center";
    begin
        if Not ErrorOccured then begin
            ProdOrderRoutingline.Setrange(Status, ProductionOrder.Status);
            ProdOrderRoutingLine.Setrange("Prod. Order No.", ProductionOrder."No.");
            ProdOrderRoutingLine.Setrange(gimIsLine, true);
            IF ProdOrderRoutingLine.findFirst() Then
                If Workcenter.get(ProdOrderRoutingLine."Work Center No.") then
                    ProductionOrder.gimProductionLine := workcenter.name;

        end;
    end;
}
