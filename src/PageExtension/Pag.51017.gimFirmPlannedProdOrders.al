pageextension 51017 gimFirmPlannedProdOrders extends "Firm Planned Prod. Orders"
{
    layout
    {
        addfirst(Control1)
        {
            field("gimAvailability Indicator"; Rec."gimAvailability Indicator")
            {
                applicationArea = all;
                Caption = 'Availability Indicator';
                visible = true;


            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        gimProdOrderMgmt: codeunit gimProdOrderManagement;
    begin
        gimProdOrderMgmt.SetLightOnProdOrder(rec);
        Currpage.uPDATE(true);
    end;
}
