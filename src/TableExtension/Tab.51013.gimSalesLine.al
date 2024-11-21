/// <summary>
/// TableExtension gimSalesLine (ID 51013) extends Record Sales Line.
/// </summary>
tableextension 51013 gimSalesLine extends "Sales Line"
{
    fields
    {
        field(51005; gimInventoryOn420; Decimal)
        {
            Caption = 'Inventory On 420';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Location Code" = CONST('420')));
            editable = false;

        }
    }
}
