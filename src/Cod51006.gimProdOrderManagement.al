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
    begin
        r := random(3);
        case r of
            1:
                availState := availstate::"Not Available";
            2:
                availState := availstate::"In Order";
            3:
                availState := availstate::"Available";
        end;
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


    end;

    procedure InitBitmaps()
    begin
        BitmapRed.get(0);
        BitmapOrange.get(1);
        BitmapGreen.Get(3);
        BitmapRed.CalcFields(Bitmap);
        BitmapOrange.CalcFields(Bitmap);
        BitmapGreen.CalcFields(Bitmap);
    end;

    var
        BitmapRed: record gimBitmap;
        BitmapOrange: record gimBitmap;
        BitmapGreen: record gimBitmap;

}
