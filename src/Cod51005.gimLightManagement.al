codeunit 51005 gimLightManagement
{
    TableNo = gimBitmap;

    trigger OnRun()
    begin

    end;

    procedure getRedLight(var instr: InStream)
    var
        Bitmap: record gimBitmap;
    begin
        Bitmap.get(0);
        Bitmap.Bitmap.CreateInStream(instr);
    end;

    procedure getOrangeLight(var instr: InStream)
    var
        Bitmap: record gimBitmap;
    begin
        Bitmap.get(1);
        Bitmap.Bitmap.CreateInStream(instr);
    end;

    procedure getGreenLight(var instr: InStream)
    var
        Bitmap: record gimBitmap;
    begin
        Bitmap.get(3);
        Bitmap.Bitmap.CreateInStream(instr);
    end;




}
