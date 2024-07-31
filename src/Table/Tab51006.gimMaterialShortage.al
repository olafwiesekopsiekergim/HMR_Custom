/// <summary>
/// Table gimMaterialShortage (ID 51006).
/// </summary>
table 51006 gimMaterialShortage
{
    Caption = 'gimMaterialShortage';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ProdOrderStatus; Enum "Production Order Status")
        {
            Caption = 'ProdOrderStatus';
        }
        field(2; ProdOrderNo; Code[30])
        {
            Caption = 'ProdOrderNo';
        }
        Field(3; ProdOrderLine; Integer)
        {
            caption = 'ProdOrderLine';
        }
        Field(4; CompItemLine; integer)
        {
            caption = 'CompitemLine';
        }
        field(10; ProdOrderDescription; Text[100])
        {
            Caption = 'ProdOrderDescription';
        }
        field(11; ProdOrderDueDate; Date)
        {
            Caption = 'ProdOrderDueDate';
        }
        field(12; CompItemInventory; Decimal)
        {
            Caption = 'CompItemInventory';
        }
        field(13; CompItemSchdNeedQty; Decimal)
        {
            Caption = 'CompItemSchdNeedQty';
        }
        field(14; CompItemNeededQty; Decimal)
        {
            Caption = 'CompItemNeededQty';
        }
        field(15; CompItemNo; Code[30])
        {
            Caption = 'CompItemNo';
        }
        field(16; CompItemInvRemQtyBase; Decimal)
        {
            Caption = 'CompItemInvRemQtyBase';
        }
        field(17; CompItemSchdRcptQty; Decimal)
        {
            Caption = 'CompItemSchdRcptQty';
        }
        field(18; CompItemQtyOnPurchOrder; Decimal)
        {
            Caption = 'CompItemQtyOnPurchOrder';
        }
        field(19; CompItemQtyOnSalesOrder; Decimal)
        {
            Caption = 'CompItemQtyOnSalesOrder';
        }
        field(20; CompItemRemQtyBase; Decimal)
        {
            Caption = 'CompItemRemQtyBase';
        }
    }
    keys
    {
        key(PK; ProdOrderStatus, ProdOrderNo, ProdOrderLine, CompItemLine)
        {
            Clustered = true;
        }
    }
}
