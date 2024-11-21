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
