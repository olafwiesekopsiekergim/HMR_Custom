/// <summary>
/// Page gimMaterialShortageList (ID 51006).
/// </summary>
page 51006 gimMaterialShortageList
{
    ApplicationArea = All;
    Caption = 'gimMaterialShortageList';
    PageType = List;
    SourceTable = gimMaterialShortage;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ProdOrderStatus; Rec.ProdOrderStatus)
                {
                    ToolTip = 'Specifies the value of the ProdOrderStatus field.', Comment = '%';
                }
                field(ProdOrderNo; Rec.ProdOrderNo)
                {
                    ToolTip = 'Specifies the value of the ProdOrderNo field.', Comment = '%';
                }
                field(ProdOrderLine; Rec.ProdOrderLine)
                {
                    ToolTip = 'Specifies the value of the ProdOrderLine field.', Comment = '%';
                }
                field(CompItemLine; Rec.CompItemLine)
                {
                    ToolTip = 'Specifies the value of the CompitemLine field.', Comment = '%';
                }
                field(CompItemNo; Rec.CompItemNo)
                {
                    ToolTip = 'Specifies the value of the CompItemNo field.', Comment = '%';
                }
                field(ProdOrderDueDate; Rec.ProdOrderDueDate)
                {
                    ToolTip = 'Specifies the value of the ProdOrderDueDate field.', Comment = '%';
                }
                field(ProdOrderDescription; Rec.ProdOrderDescription)
                {
                    ToolTip = 'Specifies the value of the ProdOrderDescription field.', Comment = '%';
                }
                field(CompItemInventory; Rec.CompItemInventory)
                {
                    ToolTip = 'Specifies the value of the CompItemInventory field.', Comment = '%';
                }
                field(CompItemSchdNeedQty; Rec.CompItemSchdNeedQty)
                {
                    ToolTip = 'Specifies the value of the CompItemSchdNeedQty field.', Comment = '%';
                }
                field(CompItemInvRemQtyBase; Rec.CompItemInvRemQtyBase)
                {
                    ToolTip = 'Specifies the value of the CompItemInvRemQtyBase field.', Comment = '%';
                }
                field(CompItemNeededQty; Rec.CompItemNeededQty)
                {
                    ToolTip = 'Specifies the value of the CompItemNeededQty field.', Comment = '%';
                }
                field(CompItemQtyOnPurchOrder; Rec.CompItemQtyOnPurchOrder)
                {
                    ToolTip = 'Specifies the value of the CompItemQtyOnPurchOrder field.', Comment = '%';
                }
                field(CompItemQtyOnSalesOrder; Rec.CompItemQtyOnSalesOrder)
                {
                    ToolTip = 'Specifies the value of the CompItemQtyOnSalesOrder field.', Comment = '%';
                }
                field(CompItemRemQtyBase; Rec.CompItemRemQtyBase)
                {
                    ToolTip = 'Specifies the value of the CompItemRemQtyBase field.', Comment = '%';
                }
                field(CompItemSchdRcptQty; Rec.CompItemSchdRcptQty)
                {
                    ToolTip = 'Specifies the value of the CompItemSchdRcptQty field.', Comment = '%';
                }
            }
        }
    }
}
