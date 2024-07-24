pageextension 51017 gimFirmPlannedProdOrders extends "Firm Planned Prod. Order"
{
    layout
    {
        addfirst(content)
        {
            field("gimAvailability Indicator"; Rec."gimAvailability Indicator")
            {
                applicationArea = all;


            }
        }
    }

    trigger OnAfterGetRecord()
    var
        gimProdOrderMgmt: codeunit gimProdOrderManagement;
    begin
        gimProdOrderMgmt.SetLightOnProdOrder(rec);
    end;
}
