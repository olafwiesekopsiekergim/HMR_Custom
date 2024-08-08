/// <summary>
/// PageExtension gimWorkCenterCard (ID 51018) extends Record Work Center Card.
/// </summary>
pageextension 51018 gimWorkCenterCard extends "Work Center Card"
{
    layout
    {
        addlast(General)
        {
            field(gimIsLine; rec.gimIsLine)
            {
                ApplicationArea = All;
            }
        }
    }
}
