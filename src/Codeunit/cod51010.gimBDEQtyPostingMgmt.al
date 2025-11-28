codeunit 51010 "gim BDE Qty Posting Mgt"
{
    Subtype = Normal;

    procedure gimRegisterQuantity(
        EmployeeNo: Code[20];
        ProdStatus: Enum "Production Order Status";
        ProdOrderNo: Code[20];
        ProdOrderLineNo: Integer;
        RoutingRefNo: Integer;
        OperationNo: Code[10];
        WorkCenterNo: Code[20];
        QtyGood: Decimal;
        QtyScrap: Decimal)
    var
        QtyEntry: Record "gim BDE Qty Entry";
        IsLastOp: Boolean;
    begin
        QtyEntry.Init();
        QtyEntry."Entry No." := gimNextNo(QtyEntry);
        QtyEntry."gim Employee No." := EmployeeNo;
        QtyEntry."gim Prod. Order Status" := ProdStatus;
        QtyEntry."gim Prod. Order No." := ProdOrderNo;
        QtyEntry."gim Prod. Order Line No." := ProdOrderLineNo;
        QtyEntry."gim Routing Reference No." := RoutingRefNo;
        QtyEntry."gim Operation No." := OperationNo;
        QtyEntry."gim Work Center No." := WorkCenterNo;
        QtyEntry."gim Quantity Good" := QtyGood;
        QtyEntry."gim Quantity Scrap" := QtyScrap;
        QtyEntry."gim Entry Date-Time" := CurrentDateTime();
        QtyEntry."gim Posting Date" := Today();
        QtyEntry."gim Posted to Output" := false;
        QtyEntry.Insert();

        // Prüfen, ob das der letzte Arbeitsgang der Zeile ist
        IsLastOp := gimIsLastOperation(ProdStatus, ProdOrderNo, ProdOrderLineNo, OperationNo);

        if IsLastOp then
            gimPostOutputForLine(ProdStatus, ProdOrderNo, ProdOrderLineNo);
    end;

    // Prüft, ob OperationNo die letzte Operation der Prod. Order Line ist
    local procedure gimIsLastOperation(ProdStatus: Enum "Production Order Status"; ProdOrderNo: Code[20]; ProdOrderLineNo: Integer; OperationNo: Code[10]): Boolean
    var
        RL: Record "Prod. Order Routing Line";
    begin
        RL.Reset();
        RL.SetRange(Status, ProdStatus);
        RL.SetRange("Prod. Order No.", ProdOrderNo);
        RL.SetRange("Routing Reference No.", ProdOrderLineNo);

        if RL.FindLast() then
            exit(RL."Operation No." = OperationNo);

        exit(false);
    end;

    // Bucht Output für die komplette Prod. Order Line (basierend auf allen offenen Qty-Einträgen)
    local procedure gimPostOutputForLine(ProdStatus: Enum "Production Order Status"; ProdOrderNo: Code[20]; ProdOrderLineNo: Integer)
    var
        QtyEntry: Record "gim BDE Qty Entry";
        TotalGood: Decimal;
        TotalScrap: Decimal;
    begin
        QtyEntry.Reset();
        QtyEntry.SetRange("gim Prod. Order Status", ProdStatus);
        QtyEntry.SetRange("gim Prod. Order No.", ProdOrderNo);
        QtyEntry.SetRange("gim Prod. Order Line No.", ProdOrderLineNo);
        QtyEntry.SetRange("gim Posted to Output", false);

        if QtyEntry.FindSet() then
            repeat
                TotalGood += QtyEntry."gim Quantity Good";
                TotalScrap += QtyEntry."gim Quantity Scrap";
            until QtyEntry.Next() = 0;

        if (TotalGood <> 0) or (TotalScrap <> 0) then
            gimCreateAndPostOutput(ProdStatus, ProdOrderNo, ProdOrderLineNo, TotalGood, TotalScrap);

        // Alle als gebucht markieren
        QtyEntry.Reset();
        QtyEntry.SetRange("gim Prod. Order Status", ProdStatus);
        QtyEntry.SetRange("gim Prod. Order No.", ProdOrderNo);
        QtyEntry.SetRange("gim Prod. Order Line No.", ProdOrderLineNo);
        QtyEntry.SetRange("gim Posted to Output", false);

        if QtyEntry.FindSet(true) then
            repeat
                QtyEntry."gim Posted to Output" := true;
                QtyEntry.Modify();
            until QtyEntry.Next() = 0;
    end;

    local procedure gimNextNo(var Rec: Record "gim BDE Qty Entry"): Integer
    begin
        Rec.Reset();
        if Rec.FindLast() then
            exit(Rec."Entry No." + 1);
        exit(1);
    end;

    local procedure gimCreateAndPostOutput(ProdStatus: Enum "Production Order Status"; ProdOrderNo: Code[20]; ProdOrderLineNo: Integer; QtyGood: Decimal; QtyScrap: Decimal)
    begin
        // TODO:
        // Hier Output-Journal/-Buchung aufsetzen, z.B.:
        // - Production Journal oder Output Journal füllen
        // - Codeunit "Output Jnl.-Post" aufrufen
    end;
}
