table 51007 "gim BDE Entry"
{
    Caption = 'BDE Entry';
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

        field(11; "gim Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }

        // --- Produktion: Header & Line ---

        field(20; "gim Prod. Order Status"; Enum "Production Order Status")
        {
            Caption = 'Prod. Order Status';
        }

        field(21; "gim Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No.";
        }

        field(22; "gim Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No."
                WHERE("Prod. Order No." = FIELD("gim Prod. Order No."),
                      Status = FIELD("gim Prod. Order Status"));
        }

        field(23; "gim Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }

        // --- Routing / Operation / Arbeitsplatz ---

        field(30; "gim Routing Reference No."; Integer)
        {
            Caption = 'Routing Ref. No.';
        }

        field(31; "gim Operation No."; Code[10])
        {
            Caption = 'Operation No.';
        }

        field(32; "gim Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center"."No.";
        }

        field(33; "gim Machine Center No."; Code[20])
        {
            Caption = 'Machine Center No.';
            TableRelation = "Machine Center"."No.";
        }

        // --- Zeit ---

        field(40; "gim Start Date-Time"; DateTime)
        {
            Caption = 'Start Date-Time';
        }

        field(41; "gim End Date-Time"; DateTime)
        {
            Caption = 'End Date-Time';
        }

        field(42; "gim Duration (Minutes)"; Decimal)
        {
            Caption = 'Duration (Minutes)';
            DecimalPlaces = 0 : 5;
        }

        field(43; "gim Is Open"; Boolean)
        {
            Caption = 'Open';
        }

        field(44; "gim Time Type"; Enum "gim BDE Time Type")
        {
            Caption = 'Time Type';
            // Setup vs Run – wird beim Start am Terminal gewählt
        }

        field(50; "gim Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        // --- Mengen ---

        field(60; "gim Quantity Good"; Decimal)
        {
            Caption = 'Quantity Good';
        }

        field(61; "gim Quantity Scrap"; Decimal)
        {
            Caption = 'Quantity Scrap';
        }

        // --- Kostenbuchung / Status ---

        field(70; "gim Posted to Capacity"; Boolean)
        {
            Caption = 'Posted to Capacity';
        }

        field(71; "gim Machine Cap. Entry No."; Integer)
        {
            Caption = 'Machine Capacity Entry No.';
        }

        field(72; "gim Labor Cap. Entry No."; Integer)
        {
            Caption = 'Labor Capacity Entry No.';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }

        key("gim EmployeeOpen"; "gim Employee No.", "gim Is Open") { }

        key("gim ProdOpDate"; "gim Prod. Order Status", "gim Prod. Order No.",
                              "gim Operation No.", "gim Posting Date")
        { }
    }
}
