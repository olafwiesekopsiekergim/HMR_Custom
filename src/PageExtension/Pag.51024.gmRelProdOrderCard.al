pageextension 51027 gmRelProdOrderCard extends "Released Production Order"
{
    layout
    {
        addafter("Parent Order No. HMR")
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
