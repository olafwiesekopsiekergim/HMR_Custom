codeunit 51011 "gim BDE Terminal Mgt"
{

    Subtype = Normal;

    // -------------------------
    // Mitarbeiter per Barcode ermitteln
    // -------------------------
    procedure gimGetEmployeeFromBarcode(Barcode: Code[50]): Code[20]
    var
        Emp: Record Employee;
    begin
        Emp.Reset();
        Emp.SetRange("gim BDE Barcode", Barcode);
        if Emp.FindFirst() then
            exit(Emp."No.");

        Error('Unbekannter Mitarbeiter-Barcode: %1', Barcode);
    end;

    // -------------------------
    // Routing/Arbeitsgang per Barcode ermitteln
    // -------------------------
    procedure gimGetRoutingFromBarcode(Barcode: Code[50]; var ProdRoutingLine: Record "Prod. Order Routing Line")
    begin
        ProdRoutingLine.Reset();
        ProdRoutingLine.SetRange("gim BDE Barcode", Barcode);
        ProdRoutingLine.SetRange("gim BDE Enabled", true);

        if ProdRoutingLine.FindFirst() then
            exit
        else
            Error('Unbekannter Fertigungs-/Arbeitsgang-Barcode: %1', Barcode);
    end;

    // -------------------------
    // Start einer Zeitbuchung (Setup oder Run)
    // -------------------------
    procedure gimStartTime(EmployeeNo: Code[20]; ProdRoutingLine: Record "Prod. Order Routing Line"; TimeType: Enum "gim BDE Time Type")
    var
        BDE: Record "gim BDE Entry";
        ProdLine: Record "Prod. Order Line";
    begin
        // offene Einträge des Mitarbeiters schließen
        gimStopAllForEmployee(EmployeeNo);

        if not gimGetProdOrderLineFromRouting(ProdRoutingLine, ProdLine) then
            Error('Zu diesem Arbeitsgang wurde keine passende Prod. Order Line gefunden (Order %1, Routing Ref. %2).',
                  ProdRoutingLine."Prod. Order No.", ProdRoutingLine."Routing Reference No.");

        BDE.Init();
        BDE."Entry No." := gimNextNo(BDE);
        BDE."gim Employee No." := EmployeeNo;
        BDE."gim Employee Name" := gimGetEmployeeName(EmployeeNo);

        BDE."gim Prod. Order Status" := ProdRoutingLine.Status;
        BDE."gim Prod. Order No." := ProdRoutingLine."Prod. Order No.";
        BDE."gim Prod. Order Line No." := ProdLine."Line No.";
        BDE."gim Routing Reference No." := ProdRoutingLine."Routing Reference No.";
        BDE."gim Operation No." := ProdRoutingLine."Operation No.";
        BDE."gim Work Center No." := ProdRoutingLine."Work Center No.";
        BDE."gim Machine Center No." := ProdRoutingLine."No.";
        BDE."gim Item No." := ProdLine."Item No.";

        BDE."gim Time Type" := TimeType;
        BDE."gim Start Date-Time" := CurrentDateTime();
        BDE."gim Posting Date" := Today();
        BDE."gim Is Open" := true;

        BDE.Insert();
    end;

    // -------------------------
    // Alle offenen Buchungen eines Mitarbeiters stoppen
    // (Pause, Unterbrechung, Arbeitsende etc.)
    // -------------------------
    procedure gimStopAllForEmployee(EmployeeNo: Code[20])
    var
        BDE: Record "gim BDE Entry";
    begin
        BDE.Reset();
        BDE.SetRange("gim Employee No.", EmployeeNo);
        BDE.SetRange("gim Is Open", true);

        if BDE.FindSet(true) then
            repeat
                BDE."gim End Date-Time" := CurrentDateTime();
                BDE."gim Duration (Minutes)" := (BDE."gim End Date-Time" - BDE."gim Start Date-Time") / (1000 * 60);
                BDE."gim Is Open" := false;
                BDE."gim Posting Date" := Today();
                BDE.Modify();
            until BDE.Next() = 0;
    end;

    // -------------------------
    // Mengen melden (delegiert an CU 51010)
    // -------------------------
    procedure gimPostQuantity(EmployeeNo: Code[20]; ProdRoutingLine: Record "Prod. Order Routing Line"; QtyGood: Decimal; QtyScrap: Decimal)
    var
        QtyMgt: Codeunit "gim BDE Qty Posting Mgt";
        ProdLine: Record "Prod. Order Line";
    begin
        if not gimGetProdOrderLineFromRouting(ProdRoutingLine, ProdLine) then
            Error('Zu diesem Arbeitsgang wurde keine passende Prod. Order Line gefunden.');

        QtyMgt.gimRegisterQuantity(
            EmployeeNo,
            ProdRoutingLine.Status,
            ProdRoutingLine."Prod. Order No.",
            ProdLine."Line No.",
            ProdRoutingLine."Routing Reference No.",
            ProdRoutingLine."Operation No.",
            ProdRoutingLine."Work Center No.",
            QtyGood,
            QtyScrap);
    end;
    // -------------------------
    // Hilfsfunktionen
    // -------------------------
    local procedure gimNextNo(var Rec: Record "gim BDE Entry"): Integer
    begin
        Rec.Reset();
        if Rec.FindLast() then
            exit(Rec."Entry No." + 1);
        exit(1);
    end;

    procedure gimGetEmployeeName(EmployeeNo: Code[20]): Text[100]
    var
        Emp: Record Employee;
    begin
        if Emp.Get(EmployeeNo) then
            exit(Emp.FullName());
        exit('');
    end;

    local procedure gimGetItemNo(ProdRoutingLine: Record "Prod. Order Routing Line"): Code[20]
    var
        ProdLine: Record "Prod. Order Line";
    begin
        if ProdLine.Get(ProdRoutingLine.Status, ProdRoutingLine."Prod. Order No.", ProdRoutingLine."Routing Reference No.") then
            exit(ProdLine."Item No.");
        exit('');
    end;

    local procedure gimGetProdOrderLineFromRouting(ProdRoutingLine: Record "Prod. Order Routing Line"; var ProdOrderLine: Record "Prod. Order Line"): Boolean
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange(Status, ProdRoutingLine.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdRoutingLine."Prod. Order No.");
        ProdOrderLine.SetRange("Routing Reference No.", ProdRoutingLine."Routing Reference No.");

        exit(ProdOrderLine.FindFirst());
    end;
}
