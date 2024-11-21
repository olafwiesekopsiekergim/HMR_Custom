pageextension 51023 gimSalesLines extends "Sales Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field(gimInventoryOn420; Rec.gimInventoryOn420)
            {
                applicationArea = all;
            }
        }
    }
}
