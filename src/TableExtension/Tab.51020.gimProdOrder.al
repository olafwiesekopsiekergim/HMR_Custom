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
            Caption = 'Availability Indicator';
            DataClassification = CustomerContent;
            Subtype = Bitmap;
        }
        field(50002; "gimAvailability Status"; enum gimAvailibityStatus)
        {
            caption = 'Availibility Status';
            DataClassification = SystemMetadata;
        }
        field(50003; gimOrderNo; code[30])
        {
            caption = 'Order No.';
            DataClassification = SystemMetadata;
        }
    }


}
