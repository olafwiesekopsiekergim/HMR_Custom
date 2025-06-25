pageextension 51025 gimFPProdOrderCard extends "Firm Planned Prod. Order"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field(gimOpenQualityIssues; Rec.gimOpenQualityIssues)
            {
                applicationArea = all;
            }
            field(gimQualityIssuesComment; Rec.gimQualityIssuesComment)
            {
                applicationArea = all;
            }
        }
    }
}
