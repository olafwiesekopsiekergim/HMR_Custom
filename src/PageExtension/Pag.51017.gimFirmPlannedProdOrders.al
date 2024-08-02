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

    actions
    {
        addlast(processing)
        {
            action(getAvailStatus)

            {
                caption = 'Set Light';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    gimProdOrderMgmt.SetLightOnProdOrder(rec);
                    CurrPage.update(false);
                end;

            }
        }
    }


    trigger OnOpenPage()
    begin
        gimProdOrderMgmt.InitBitmaps();
    end;

    trigger OnAfterGetRecord()
    begin
        gimProdOrderMgmt.SetLightOnProdOrder(rec);


    end;


    var
        gimProdOrderMgmt: codeunit gimProdOrderManagement;




}
