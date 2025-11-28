tableextension 51021 "gim Employee Ext" extends Employee
{
    fields
    {
        field(51000; "gim BDE Barcode"; Code[50])
        {
            Caption = 'BDE Barcode';
            DataClassification = CustomerContent;
        }
    }
}
