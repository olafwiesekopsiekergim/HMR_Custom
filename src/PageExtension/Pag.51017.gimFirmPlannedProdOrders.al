pageextension 51017 gimFirmPlannedProdOrders extends "Firm Planned Prod. Order"
{
    layout
    {
        addlast(content)
        {
            field("gimAvailability Indicator"; Rec."gimAvailability Indicator")
            {
                applicationArea = all;
                Caption = 'Availability Indicator';
                visible = true;


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
