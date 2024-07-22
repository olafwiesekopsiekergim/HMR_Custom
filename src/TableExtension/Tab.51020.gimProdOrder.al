tableextension 51020 gimProdOrder extends "Production Order"
{
    fields
    {
        field(50000; "gimSchedule Indicator"; Blob)
        {
            Caption = 'Terminampel';
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
        field(50001; "gimAvailability Indicator"; Blob)
        {
            Caption = 'Verfügbarkeitsampel';
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
    }


}
