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
                gimLightManagement.getRedLight(inStr);
            availState::"In Order":
                gimLightManagement.getOrangeLight(inStr);
            availState::Available:
                gimLightManagement.getgreenLight(inStr);

        end;

        ProdOrder."gimAvailability Indicator".CreateOutStream(outStr);
        CopyStream(outstr, instr);

    end;


}
