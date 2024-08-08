pageextension 51017 gimFirmPlannedProdOrders extends "Firm Planned Prod. Orders"
{
    layout
    {
        addafter("No.")
        {
            field("gimAvailability Indicator"; Rec."gimAvailability Indicator")
            {
                applicationArea = all;
                Caption = 'Availability Indicator';
                visible = true;


            }
            field(gimOrderNo; Rec.gimOrderNo)
            {
                applicationArea = all;
                Caption = 'Order No.';
            }
            field(gimProductionLine; rec.gimProductionLine)
            {
                applicationArea = all;
                Caption = 'Production Line';
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
