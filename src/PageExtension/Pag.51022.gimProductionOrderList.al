/// <summary>
/// PageExtension gimProductionOrderList (ID 51022) extends Record Production Order List.
/// </summary>
pageextension 51022 gimProductionOrderList extends "Production Order List"
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
            // field(gimOrderNo; Rec.gimOrderNo)
            // {
            //     applicationArea = all;
            //     Caption = 'Order No.';
            // }
            field(gimProductionLine; rec.gimProductionLine)
            {
                applicationArea = all;
                Caption = 'Production Line';
            }
        }

        addafter(Quantity)
        {
            field(gimQuantityFromPOL; Rec.gimQuantityFromPOL)
            {
                applicationArea = all;

            }
            field(gimFinishedQuantityFromPOL; Rec.gimFinishedQuantityFromPOL)
            {
                applicationArea = all;

            }
            field(gimRemainingQuantityFromPOL; Rec.gimRemainingQuantityFromPOL)
            {
                applicationArea = all;

            }
            field(gimItemDescription2; Rec.gimItemDescription2)
            {
                applicationArea = all;
            }
            field(gimItemBomNo; Rec.gimItemBomNo)
            {
                applicationArea = all;
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

            // action(refreshWorkLine)
            // {
            //     caption = 'Refresh Working Line';
            //     ApplicationArea = all;
            //     trigger OnAction()
            //     var
            //         gimHMREvents: codeunit gimHMREvents;
            //     begin
            //         if rec.findset then
            //             repeat
            //                 gimHMREvents.RefreshWorkLine(rec);
            //             until rec.next = 0;
            //         CurrPage.update(false);
            //     end;
            // }
        }
    }

    trigger OnOpenPage()
    begin
        gimProdOrderMgmt.InitBitmaps();
    end;

    trigger OnAfterGetRecord()
    begin
        //gimProdOrderMgmt.SetLightOnProdOrder(rec);


    end;


    var
        gimProdOrderMgmt: codeunit gimProdOrderManagement;


}
