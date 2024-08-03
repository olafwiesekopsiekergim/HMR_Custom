/// <summary>
/// Codeunit gimHMREvents (ID 51008).
/// </summary>
codeunit 51008 gimHMREvents
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", 'OnAfterCreateProdOrder', '', false, false)]

    local procedure OnAfterCreateProdOrderFromSalesLine(var ProdOrder: Record "Production Order"; var SalesLine: Record "Sales Line")
    begin
        ProdOrder.gimOrderNo := Salesline."Document No.";

    end;
}
