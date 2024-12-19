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
            action(refreshAvailStatus)

            {
                caption = 'Refresh Avaliability Status';
                ApplicationArea = all;
                trigger OnAction()
                begin

                    gimProdOrderMgmt.RefreshAvailabilityStatusOnProdOrders(rec);
                    CurrPage.update(false);
                end;

            }
            action(refreshWorkLine)
            {
                caption = 'Refresh Working Line';
                ApplicationArea = all;
                trigger OnAction()
                var
                    gimHMREvents: codeunit gimHMREvents;
                begin
                    if rec.findset then
                        repeat
                            gimHMREvents.RefreshWorkLine(rec);
                        until rec.next = 0;
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
        // gimProdOrderMgmt.SetLightOnProdOrder(rec);


    end;


    var
        gimProdOrderMgmt: codeunit gimProdOrderManagement;




}
