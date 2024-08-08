/// <summary>
/// PageExtension gimProdOrderRouting (ID 51019) extends Record Prod. Order Routing.
/// </summary>
pageextension 51019 gimProdOrderRouting extends "Prod. Order Routing"
{
    layout
    {
        addlast(Control1)
        {
            field(gimIsLine; rec.gimIsLine)
            {
                ApplicationArea = all;
            }
        }
    }
}
