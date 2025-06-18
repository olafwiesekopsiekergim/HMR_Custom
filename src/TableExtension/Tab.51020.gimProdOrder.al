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
            editable = false;
        }
        field(50003; gimOrderNo; code[30])
        {
            caption = 'Order No.';
            DataClassification = SystemMetadata;
            editable = false;
        }
        field(50004; gimProductionLine; text[80])
        {
            caption = 'Production Line';
            DataClassification = SystemMetadata;
            editable = false;
        }

        field(50010; gimQuantityFromPOL; decimal)
        {
            caption = 'Qty of POL';
            editable = false;
            fieldclass = FlowField;
            CalcFormula = lookup("Prod. Order Line".Quantity WHERE(Status = Field(status), "Prod. Order No." = field("No.")));
        }
        field(50011; gimFinishedQuantityFromPOL; decimal)
        {
            caption = 'Finished Qty of POL';
            editable = false;
            fieldclass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Finished Quantity" WHERE(Status = Field(status), "Prod. Order No." = field("No.")));
        }

        field(50012; gimRemainingQuantityFromPOL; decimal)
        {
            caption = 'Remaining Qty of POL';
            editable = false;
            fieldclass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Remaining Quantity" WHERE(Status = Field(status), "Prod. Order No." = field("No.")));
        }
        field(50020; gimItemDescription2; text[200])
        {
            caption = 'Item Desc. 2';
            DataClassification = SystemMetadata;
            editable = false;

        }
        field(50021; gimItemBomNo; code[50])
        {
            caption = 'Item BOM No.';
            DataClassification = SystemMetadata;
            editable = false;

        }

    }


}
