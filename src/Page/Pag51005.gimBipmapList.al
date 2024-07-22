page 51005 gimBipmapList

{
    ApplicationArea = All;
    Caption = 'Bitmap List';
    PageType = List;
    SourceTable = gimBitmap;
    UsageCategory = administration;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Bitmap; rec.Bitmap)
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Bilder")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    ImportFromDevice();
                end;
            }
        }
    }
    /// <summary>
    /// ImportFromDevice.
    /// </summary>
    procedure ImportFromDevice()
    var

        Bitmap: Record gimBitmap;
        inStr: Instream;
        outstr: Outstream;
        tempBlob: Codeunit "Temp Blob";
    begin

        bitmap.get(rec.code);

        UploadIntoStream('', inStr);
        bitmap.bitmap.createoutstream(outstr);
        copyStream(outstr, instr);
        if not bitmap.insert() then bitmap.modify();


    end;






}
