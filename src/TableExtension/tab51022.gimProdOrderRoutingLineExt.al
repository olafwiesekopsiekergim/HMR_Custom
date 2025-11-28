tableextension 51022 "gim ProdOrderRoutingLine Ext" extends "Prod. Order Routing Line"
{
    fields
    {
        field(51000; "gim BDE Barcode"; Code[50])
        {
            Caption = 'BDE Barcode';
            DataClassification = CustomerContent;
        }

        field(51001; "gim BDE Enabled"; Boolean)
        {
            Caption = 'BDE Enabled';
            DataClassification = CustomerContent;
        }
    }
}
