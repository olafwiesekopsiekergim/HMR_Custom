codeunit 51009 "gim BDE Posting Mgt"
{
    Subtype = Normal;

    procedure gimPostUnpostedEntries()
    var
        BDE: Record "gim BDE Entry";
        CurrStatus: Enum "Production Order Status";
        CurrProdNo: Code[20];
        CurrLineNo: Integer;
        CurrOpNo: Code[10];
        CurrWCNo: Code[20];
        CurrPostingDate: Date;
        First: Boolean;
        GroupChanged: Boolean;
    begin
        BDE.Reset();
        BDE.SetRange("gim Is Open", false);
        BDE.SetRange("gim Posted to Capacity", false);

        BDE.SetCurrentKey(
            "gim Prod. Order Status",
            "gim Prod. Order No.",
            "gim Prod. Order Line No.",
            "gim Operation No.",
            "gim Work Center No.",
            "gim Posting Date");

        if not BDE.FindSet(false, false) then
            exit;

        First := true;

        repeat
            if First then begin
                CurrStatus := BDE."gim Prod. Order Status";
                CurrProdNo := BDE."gim Prod. Order No.";
                CurrLineNo := BDE."gim Prod. Order Line No.";
                CurrOpNo := BDE."gim Operation No.";
                CurrWCNo := BDE."gim Work Center No.";
                CurrPostingDate := BDE."gim Posting Date";
                First := false;
                GroupChanged := false;
            end else begin
                GroupChanged :=
                    (CurrStatus <> BDE."gim Prod. Order Status") or
                    (CurrProdNo <> BDE."gim Prod. Order No.") or
                    (CurrLineNo <> BDE."gim Prod. Order Line No.") or
                    (CurrOpNo <> BDE."gim Operation No.") or
                    (CurrWCNo <> BDE."gim Work Center No.") or
                    (CurrPostingDate <> BDE."gim Posting Date");

                if GroupChanged then begin
                    gimPostMachineForGroup(CurrStatus, CurrProdNo, CurrLineNo, CurrOpNo, CurrWCNo, CurrPostingDate);
                    gimPostLaborForGroup(CurrStatus, CurrProdNo, CurrLineNo, CurrOpNo, CurrWCNo, CurrPostingDate);
                    gimMarkGroupAsPosted(CurrStatus, CurrProdNo, CurrLineNo, CurrOpNo, CurrWCNo, CurrPostingDate);

                    CurrStatus := BDE."gim Prod. Order Status";
                    CurrProdNo := BDE."gim Prod. Order No.";
                    CurrLineNo := BDE."gim Prod. Order Line No.";
                    CurrOpNo := BDE."gim Operation No.";
                    CurrWCNo := BDE."gim Work Center No.";
                    CurrPostingDate := BDE."gim Posting Date";
                end;
            end;
        until BDE.Next() = 0;

        // letzte Gruppe
        gimPostMachineForGroup(CurrStatus, CurrProdNo, CurrLineNo, CurrOpNo, CurrWCNo, CurrPostingDate);
        gimPostLaborForGroup(CurrStatus, CurrProdNo, CurrLineNo, CurrOpNo, CurrWCNo, CurrPostingDate);
        gimMarkGroupAsPosted(CurrStatus, CurrProdNo, CurrLineNo, CurrOpNo, CurrWCNo, CurrPostingDate);
    end;

    // ---------- Maschinenkosten: einmal pro Gruppe ----------
    local procedure gimPostMachineForGroup(ProdStatus: Enum "Production Order Status"; ProdNo: Code[20]; ProdLineNo: Integer; OperationNo: Code[10]; WorkCenterNo: Code[20]; PostingDate: Date)
    var
        BDE: Record "gim BDE Entry";
        WC: Record "Work Center";
        MinStartDT: DateTime;
        MaxEndDT: DateTime;
        First: Boolean;
        Hours: Decimal;
    begin
        if WorkCenterNo = '' then
            exit;

        BDE.Reset();
        BDE.SetRange("gim Prod. Order Status", ProdStatus);
        BDE.SetRange("gim Prod. Order No.", ProdNo);
        BDE.SetRange("gim Prod. Order Line No.", ProdLineNo);
        BDE.SetRange("gim Operation No.", OperationNo);
        BDE.SetRange("gim Work Center No.", WorkCenterNo);
        BDE.SetRange("gim Posting Date", PostingDate);
        BDE.SetRange("gim Is Open", false);
        BDE.SetRange("gim Posted to Capacity", false);

        if not BDE.FindSet(false, false) then
            exit;

        First := true;
        repeat
            if First then begin
                MinStartDT := BDE."gim Start Date-Time";
                MaxEndDT := BDE."gim End Date-Time";
                First := false;
            end else begin
                if (BDE."gim Start Date-Time" <> 0DT) and (BDE."gim Start Date-Time" < MinStartDT) then
                    MinStartDT := BDE."gim Start Date-Time";
                if (BDE."gim End Date-Time" <> 0DT) and (BDE."gim End Date-Time" > MaxEndDT) then
                    MaxEndDT := BDE."gim End Date-Time";
            end;
        until BDE.Next() = 0;

        Hours := gimCalcHours(MinStartDT, MaxEndDT);
        if Hours <= 0 then
            exit;

        if not WC.Get(WorkCenterNo) then
            Error('Work Center %1 not found.', WorkCenterNo);

        gimCreateMachineCostEntry(
            ProdNo, ProdLineNo, OperationNo, WorkCenterNo, PostingDate,
            Hours, WC."gim Machine Cost per Hour");
    end;

    // ---------- Mitarbeiterkosten: je Mitarbeiter ----------
    local procedure gimPostLaborForGroup(ProdStatus: Enum "Production Order Status"; ProdNo: Code[20]; ProdLineNo: Integer; OperationNo: Code[10]; WorkCenterNo: Code[20]; PostingDate: Date)
    var
        BDE: Record "gim BDE Entry";
        WC: Record "Work Center";
        LastEmp: Code[20];
        CurrEmp: Code[20];
        EmpHours: Decimal;
        First: Boolean;
    begin
        BDE.Reset();
        BDE.SetRange("gim Prod. Order Status", ProdStatus);
        BDE.SetRange("gim Prod. Order No.", ProdNo);
        BDE.SetRange("gim Prod. Order Line No.", ProdLineNo);
        BDE.SetRange("gim Operation No.", OperationNo);
        BDE.SetRange("gim Work Center No.", WorkCenterNo);
        BDE.SetRange("gim Posting Date", PostingDate);
        BDE.SetRange("gim Is Open", false);
        BDE.SetRange("gim Posted to Capacity", false);

        BDE.SetCurrentKey(
            "gim Prod. Order Status",
            "gim Prod. Order No.",
            "gim Prod. Order Line No.",
            "gim Operation No.",
            "gim Work Center No.",
            "gim Posting Date",
            "gim Employee No.");

        if not BDE.FindSet(false, false) then
            exit;

        if not WC.Get(WorkCenterNo) then
            Error('Work Center %1 not found.', WorkCenterNo);

        First := true;
        EmpHours := 0;

        repeat
            CurrEmp := BDE."gim Employee No.";

            if First then begin
                LastEmp := CurrEmp;
                EmpHours := 0;
                First := false;
            end;

            if CurrEmp <> LastEmp then begin
                if (LastEmp <> '') and (EmpHours > 0) then
                    gimCreateLaborCostEntry(
                        ProdNo, ProdLineNo, OperationNo, WorkCenterNo,
                        PostingDate, LastEmp, EmpHours, WC."gim Labor Cost per Hour");

                LastEmp := CurrEmp;
                EmpHours := 0;
            end;

            EmpHours += gimCalcHours(BDE."gim Start Date-Time", BDE."gim End Date-Time");
        until BDE.Next() = 0;

        if (LastEmp <> '') and (EmpHours > 0) then
            gimCreateLaborCostEntry(
                ProdNo, ProdLineNo, OperationNo, WorkCenterNo,
                PostingDate, LastEmp, EmpHours, WC."gim Labor Cost per Hour");
    end;

    // ---------- Gruppe als gebucht markieren ----------
    local procedure gimMarkGroupAsPosted(ProdStatus: Enum "Production Order Status"; ProdNo: Code[20]; ProdLineNo: Integer; OperationNo: Code[10]; WorkCenterNo: Code[20]; PostingDate: Date)
    var
        BDE: Record "gim BDE Entry";
    begin
        BDE.Reset();
        BDE.SetRange("gim Prod. Order Status", ProdStatus);
        BDE.SetRange("gim Prod. Order No.", ProdNo);
        BDE.SetRange("gim Prod. Order Line No.", ProdLineNo);
        BDE.SetRange("gim Operation No.", OperationNo);
        BDE.SetRange("gim Work Center No.", WorkCenterNo);
        BDE.SetRange("gim Posting Date", PostingDate);
        BDE.SetRange("gim Is Open", false);
        BDE.SetRange("gim Posted to Capacity", false);

        if BDE.FindSet(true) then
            repeat
                BDE."gim Posted to Capacity" := true;
                BDE.Modify();
            until BDE.Next() = 0;
    end;

    // ---------- Hilfsfunktionen ----------
    local procedure gimCalcHours(StartDT: DateTime; EndDT: DateTime): Decimal
    begin
        if (StartDT = 0DT) or (EndDT = 0DT) or (EndDT <= StartDT) then
            exit(0);

        exit((EndDT - StartDT) / (1000 * 60 * 60));
    end;

    // ---------- Platzhalter für reale Kosteneinträge ----------
    local procedure gimCreateMachineCostEntry(ProdNo: Code[20]; ProdLineNo: Integer; OperationNo: Code[10]; WorkCenterNo: Code[20]; PostingDate: Date; Hours: Decimal; CostPerHour: Decimal)
    begin
        // TODO: Kapazitätsjournal oder eigene Kostentabelle schreiben
    end;

    local procedure gimCreateLaborCostEntry(ProdNo: Code[20]; ProdLineNo: Integer; OperationNo: Code[10]; WorkCenterNo: Code[20]; PostingDate: Date; EmployeeNo: Code[20]; Hours: Decimal; CostPerHour: Decimal)
    begin
        // TODO: Mitarbeiterkosten verbuchen (z.B. ebenfalls über Kapazitätsjournal)
    end;
}
