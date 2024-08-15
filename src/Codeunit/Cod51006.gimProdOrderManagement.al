/// <summary>
/// Codeunit gimProdOrderManagement (ID 51006).
/// </summary>
codeunit 51006 gimProdOrderManagement
{
    TableNo = "Production Order";

    trigger OnRun()
    begin

    end;

    /// <summary>
    /// getAvailibityStatus.
    /// </summary>
    /// <param name="ProdOrder">record "Production Order".</param>
    /// <returns>Return variable availState of type enum gimAvailibityStatus.</returns>
    procedure getAvailibityStatus(ProdOrder: record "Production Order") availState: enum gimAvailibityStatus
    var
        r: integer;
        gimMaterialShortage: record gimMaterialShortage temporary;
        gimMaterialShortageMgmt: Codeunit gimMaterialShortageMgmt;
    begin

        gimMaterialShortageMgmt.getMaterialShortage(gimMaterialShortage, ProdOrder);

        if gimmaterialShortage.count > 0 THEN
            availstate := availstate::"Not Available"
        else
            availstate := availstate::Available;


        // case r of
        //     1:
        //         availState := availstate::"Not Available";
        //     2:
        //         availState := availstate::"In Order";
        //     3:
        //         availState := availstate::"Available";
        // end;
    end;

    /// <summary>
    /// SetLightOnProdOrder.
    /// </summary>
    /// <param name="ProdOrder">VAR record "Production Order".</param>
    procedure SetLightOnProdOrder(var ProdOrder: record "Production Order")
    var
        inStr: Instream;
        outStr: outStream;
        gimLightManagement: codeunit gimLightManagement;
        availState: enum gimAvailibityStatus;
    begin
        availstate := getAvailibityStatus(ProdOrder);
        case availState of
            availState::"Not Available":
                ProdOrder."gimAvailability Indicator" := BitmapRed.bitmap;
            availState::"In Order":
                ProdOrder."gimAvailability Indicator" := BitmapOrange.bitmap;
            availState::Available:
                ProdOrder."gimAvailability Indicator" := BitmapGreen.bitmap;
        end;

        prodorder."gimAvailability Status" := availstate;


    end;

    /// <summary>
    /// InitBitmaps.
    /// </summary>
    procedure InitBitmaps()
    begin
        BitmapRed.get(0);
        BitmapOrange.get(1);
        BitmapGreen.Get(3);
        BitmapRed.CalcFields(Bitmap);
        BitmapOrange.CalcFields(Bitmap);
        BitmapGreen.CalcFields(Bitmap);
    end;


    /// <summary>
    /// RefreshAvailabilityStatusOnProdOrders.
    /// </summary>
    /// <param name="ProdOrder">VAR record "Production Order".</param> 
    procedure RefreshAvailabilityStatusOnProdOrders(var ProdOrder: record "Production Order")
    var
        gimLightManagement: Codeunit gimLightManagement;
    begin
        IF ProdOrder.Findset() then
            repeat
                initbitmaps;
                SetLightOnProdOrder(ProdOrder);
                ProdOrder.MODIFY;
            until ProdOrder.next = 0;



    end;



    var
        BitmapRed: record gimBitmap;
        BitmapOrange: record gimBitmap;
        BitmapGreen: record gimBitmap;

}
