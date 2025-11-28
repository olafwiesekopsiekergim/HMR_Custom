page 51007 "gim BDE Terminal"
{
    Caption = 'BDE Terminal';
    PageType = Card;
    SourceTable = Integer;
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Status)
            {
                Caption = 'Status';

                field(TerminalStateTxt; TerminalStateTxt)
                {
                    Caption = 'Zustand';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentEmployeeNo; CurrentEmployeeNo)
                {
                    Caption = 'Mitarbeiter-Nr.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentEmployeeName; CurrentEmployeeName)
                {
                    Caption = 'Mitarbeiter';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentProdOrderNo; CurrentProdOrderNo)
                {
                    Caption = 'Prod.-Auftrag';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentProdOrderLineNo; CurrentProdOrderLineNo)
                {
                    Caption = 'Prod.-Auftragszeile';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentOperationNo; CurrentOperationNo)
                {
                    Caption = 'Arbeitsgang';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentWorkCenterNo; CurrentWorkCenterNo)
                {
                    Caption = 'Arbeitsplatz';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentTimeTypeTxt; CurrentTimeTypeTxt)
                {
                    Caption = 'Zeitart';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(CurrentStartDT; CurrentStartDT)
                {
                    Caption = 'Gestartet am';
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            group(Scan)
            {
                Caption = 'Scan';

                field(ScanInput; ScanInput)
                {
                    Caption = 'Barcode scannen';
                    ApplicationArea = All;
                    ToolTip = 'Mitarbeiter- oder Fertigungsauftrag-/Arbeitsgang-Barcode scannen.';

                    trigger OnValidate()
                    begin
                        HandleScan(ScanInput);
                        Clear(ScanInput);
                        CurrPage.Update(false);
                    end;
                }
            }

            group(Quantity)
            {
                Caption = 'Mengenmeldung';
                Visible = ShowQuantityGroup;

                field(QtyGood; QtyGood)
                {
                    Caption = 'Menge Gut';
                    ApplicationArea = All;
                }

                field(QtyScrap; QtyScrap)
                {
                    Caption = 'Menge Ausschuss';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(StartSetup)
            {
                Caption = 'Start Rüstzeit';
                ApplicationArea = All;
                Image = Start;

                trigger OnAction()
                begin
                    StartTime(true); // Setup
                end;
            }

            action(StartRun)
            {
                Caption = 'Start Laufzeit';
                ApplicationArea = All;
                Image = Start;

                trigger OnAction()
                begin
                    StartTime(false); // Run
                end;
            }

            action(ShowQuantity)
            {
                Caption = 'Menge melden';
                ApplicationArea = All;
                Image = Quantity;

                trigger OnAction()
                begin
                    if (CurrentEmployeeNo = '') or (not RoutingLineSelected) then
                        Error('Bitte zuerst Mitarbeiter- und Fertigungsauftrag-/Arbeitsgang-Barcode scannen.');

                    ShowQuantityGroup := true;
                    CurrPage.Update(false);
                end;
            }

            action(actPostQuantity)
            {
                Caption = 'Menge buchen';
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                begin
                    PostQuantity();
                end;
            }

            action(ResetTerminal)
            {
                Caption = 'Terminal zurücksetzen';
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                begin
                    InitTerminal();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitTerminal();
    end;

    var
        // Eingabe
        ScanInput: Code[50];

        // Status/State
        TerminalState: Option Idle,EmployeeSelected,OperationSelected;
        TerminalStateTxt: Text[100];

        // Kontext
        CurrentEmployeeNo: Code[20];
        CurrentEmployeeName: Text[100];
        CurrentProdOrderNo: Code[20];
        CurrentProdOrderLineNo: Integer;
        CurrentOperationNo: Code[10];
        CurrentWorkCenterNo: Code[20];
        CurrentTimeTypeTxt: Text[30];
        CurrentStartDT: DateTime;

        // für Mengenerfassung
        ShowQuantityGroup: Boolean;
        QtyGood: Decimal;
        QtyScrap: Decimal;

        // Routing- & Line-Kontext
        CurrRoutingLine: Record "Prod. Order Routing Line";
        CurrProdOrderLine: Record "Prod. Order Line";
        RoutingLineSelected: Boolean;

        // Mgt-Codeunit
        TerminalMgt: Codeunit "gim BDE Terminal Mgt";

    local procedure InitTerminal()
    begin
        TerminalState := TerminalState::Idle;
        UpdateStateText();

        Clear(CurrentEmployeeNo);
        Clear(CurrentEmployeeName);
        Clear(CurrentProdOrderNo);
        Clear(CurrentProdOrderLineNo);
        Clear(CurrentOperationNo);
        Clear(CurrentWorkCenterNo);
        Clear(CurrentTimeTypeTxt);
        Clear(CurrentStartDT);

        Clear(QtyGood);
        Clear(QtyScrap);
        ShowQuantityGroup := false;

        Clear(CurrRoutingLine);
        Clear(CurrProdOrderLine);
        RoutingLineSelected := false;
    end;

    local procedure UpdateStateText()
    begin
        case TerminalState of
            TerminalState::Idle:
                TerminalStateTxt := 'Bitte Mitarbeiter-Barcode scannen (Pause/Ende oder Start).';
            TerminalState::EmployeeSelected:
                TerminalStateTxt := 'Mitarbeiter erkannt – bitte Fertigungsauftrag-/Arbeitsgang-Barcode scannen.';
            TerminalState::OperationSelected:
                TerminalStateTxt := 'Arbeitsgang erkannt – Rüst- oder Laufzeit starten oder Menge melden.';
        end;
    end;

    local procedure HandleScan(ScannedCode: Code[50])
    var
        EmpNo: Code[20];
    begin
        if ScannedCode = '' then
            exit;

        // 1. Versuch: Mitarbeiter?
        EmpNo := TryGetEmployeeFromBarcode(ScannedCode);

        if EmpNo <> '' then begin
            HandleEmployeeScan(EmpNo);
            exit;
        end;

        // 2. Sonst: Fertigungsauftrag-/Arbeitsgang-Barcode
        HandleRoutingScan(ScannedCode);
    end;

    local procedure TryGetEmployeeFromBarcode(Barcode: Code[50]): Code[20]
    var
        Emp: Record Employee;
    begin
        Emp.Reset();
        Emp.SetRange("gim BDE Barcode", Barcode);
        if Emp.FindFirst() then
            exit(Emp."No.");

        exit('');
    end;

    local procedure HandleEmployeeScan(EmployeeNo: Code[20])
    begin
        // Immer: offene Einträge beenden (Pause/Arbeitsende-Fall)
        TerminalMgt.gimStopAllForEmployee(EmployeeNo);

        // Kontext setzen
        CurrentEmployeeNo := EmployeeNo;
        CurrentEmployeeName := TerminalMgt.gimGetEmployeeName(EmployeeNo);

        // Arbeitsgang-Kontext zurücksetzen – der Mitarbeiter kann als nächstes neu scannen
        Clear(CurrentProdOrderNo);
        Clear(CurrentProdOrderLineNo);
        Clear(CurrentOperationNo);
        Clear(CurrentWorkCenterNo);
        Clear(CurrentTimeTypeTxt);
        Clear(CurrentStartDT);
        Clear(CurrRoutingLine);
        Clear(CurrProdOrderLine);
        RoutingLineSelected := false;

        TerminalState := TerminalState::EmployeeSelected;
        UpdateStateText();
    end;

    local procedure HandleRoutingScan(Barcode: Code[50])
    var
        Found: Boolean;
    begin
        if CurrentEmployeeNo = '' then begin
            Error('Bitte zuerst den Mitarbeiter-Barcode scannen.');
        end;

        CurrRoutingLine.Reset();
        // Codeunit nutzen, um Routing zu ermitteln
        TerminalMgt.gimGetRoutingFromBarcode(Barcode, CurrRoutingLine);

        // passende Prod. Order Line über Routing Reference No. suchen
        Found := gimGetProdOrderLineFromRouting(CurrRoutingLine, CurrProdOrderLine);
        if not Found then
            Error(
              'Zu diesem Arbeitsgang wurde keine passende Auftragszeile gefunden. Prod.-Auftrag %1, Routing Ref. %2.',
              CurrRoutingLine."Prod. Order No.", CurrRoutingLine."Routing Reference No.");

        // Kontext setzen
        CurrentProdOrderNo := CurrRoutingLine."Prod. Order No.";
        CurrentProdOrderLineNo := CurrProdOrderLine."Line No.";
        CurrentOperationNo := CurrRoutingLine."Operation No.";
        CurrentWorkCenterNo := CurrRoutingLine."Work Center No.";

        RoutingLineSelected := true;
        TerminalState := TerminalState::OperationSelected;
        UpdateStateText();
    end;

    local procedure StartTime(IsSetup: Boolean)
    var
        TimeType: Enum "gim BDE Time Type";
    begin
        if CurrentEmployeeNo = '' then
            Error('Bitte zuerst einen Mitarbeiter scannen.');

        if not RoutingLineSelected then
            Error('Bitte zuerst den Fertigungsauftrag-/Arbeitsgang-Barcode scannen.');

        if IsSetup then
            TimeType := TimeType::Setup
        else
            TimeType := TimeType::Run;

        TerminalMgt.gimStartTime(CurrentEmployeeNo, CurrRoutingLine, TimeType);

        CurrentTimeTypeTxt := Format(TimeType);
        CurrentStartDT := CurrentDateTime();

        TerminalState := TerminalState::OperationSelected;
        UpdateStateText();
    end;

    local procedure PostQuantity()
    begin
        if not ShowQuantityGroup then
            exit;

        if CurrentEmployeeNo = '' then
            Error('Bitte zuerst einen Mitarbeiter scannen.');

        if not RoutingLineSelected then
            Error('Bitte zuerst den Fertigungsauftrag-/Arbeitsgang-Barcode scannen.');

        if (QtyGood = 0) and (QtyScrap = 0) then
            Error('Bitte eine Gutmenge oder Ausschussmenge angeben.');

        TerminalMgt.gimPostQuantity(CurrentEmployeeNo, CurrRoutingLine, QtyGood, QtyScrap);

        Message(
          'Mengenmeldung erfasst: %1 Gut / %2 Ausschuss für Auftrag %3, Zeile %4, Arbeitsgang %5.',
          QtyGood, QtyScrap, CurrentProdOrderNo, CurrentProdOrderLineNo, CurrentOperationNo);

        Clear(QtyGood);
        Clear(QtyScrap);
        ShowQuantityGroup := false;
        CurrPage.Update(false);
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
