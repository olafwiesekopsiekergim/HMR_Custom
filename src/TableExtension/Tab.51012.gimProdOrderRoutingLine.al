/// <summary>
/// TableExtension gimProdOrderRoutingLine (ID 51012) extends Record Prod. Order Routing Line.
/// </summary>
tableextension 51012 gimProdOrderRoutingLine extends "Prod. Order Routing Line"
{
    fields
    {
        field(51005; gimIsLine; Boolean)
        {
            Caption = 'gimIsLine';
            FieldClass = flowfield;
            CalcFormula = lookup("work center".gimIsLine WHERE("No." = field("No.")));
            Editable = false;

        }
    }
}
