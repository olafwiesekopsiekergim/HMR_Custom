table 51005 gimBitmap
{
    Caption = 'Bitmap';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Integer)
        {
            DataClassification = SystemMetadata;

        }
        field(2; Bitmap; Blob)
        {
            Caption = 'Bitmap';
            DataClassification = SystemMetadata;
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
