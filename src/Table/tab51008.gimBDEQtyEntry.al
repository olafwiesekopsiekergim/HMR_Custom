table 51008 "gim BDE Qty Entry"
{
    Caption = 'BDE Quantity Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }

        // --- Mitarbeiter ---
        field(10; "gim Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }

        // --- Produktion / Operation ---
        field(20; "gim Prod. Order Status"; Enum "Production Order Status") { Caption = 'Prod. Order Status'; }
        field(21; "gim Prod. Order No."; Code[20]) { Caption = 'Prod. Order No.'; TableRelation = "Production Order"."No."; }
        field(22; "gim Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No."
                WHERE("Prod. Order No." = FIELD("gim Prod. Order No."),
                      Status = FIELD("gim Prod. Order Status"));
        }
        field(23; "gim Item No."; Code[20]) { Caption = 'Item No.'; TableRelation = Item."No."; }

        field(30; "gim Routing Reference No."; Integer) { Caption = 'Routing Ref. No.'; }
        field(31; "gim Operation No."; Code[10]) { Caption = 'Operation No.'; }
        field(32; "gim Work Center No."; Code[20]) { Caption = 'Work Center No.'; TableRelation = "Work Center"."No."; }

        // --- Mengen ---
        field(40; "gim Quantity Good"; Decimal) { Caption = 'Quantity Good'; }
        field(41; "gim Quantity Scrap"; Decimal) { Caption = 'Quantity Scrap'; }

        // --- Zeitstempel / Systeminfo ---
        field(50; "gim Entry Date-Time"; DateTime) { Caption = 'Entry Date-Time'; }
        field(51; "gim Posting Date"; Date) { Caption = 'Posting Date'; }

        // --- Status / Ist-Buchung ---
        field(60; "gim Posted to Output"; Boolean) { Caption = 'Posted to Output'; }
        field(61; "gim Output Entry No."; Integer) { Caption = 'Output Entry No.'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }

        key("gim ProdOp"; "gim Prod. Order Status", "gim Prod. Order No.",
                          "gim Prod. Order Line No.", "gim Operation No.")
        { }
    }
}
