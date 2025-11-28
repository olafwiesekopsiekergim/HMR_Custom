tableextension 51011 gimWorkcenter extends "Work Center"
{
    fields
    {
        field(51005; gimIsLine; Boolean)
        {
            Caption = 'Is Line';
            DataClassification = SystemMetadata;
        }
        field(51000; "gim Machine Cost per Hour"; Decimal)
        {
            Caption = 'Machine Cost per Hour';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }

        field(51001; "gim Labor Cost per Hour"; Decimal)
        {
            Caption = 'Labor Cost per Hour';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
    }
}
