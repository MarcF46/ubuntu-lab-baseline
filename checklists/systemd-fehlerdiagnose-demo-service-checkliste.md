# Checkliste – systemd-Fehlerdiagnose Demo-Service

## Zweck

Diese Checkliste dient zur schnellen, wiederholbaren Prüfung der systemd-Fehlerdiagnose mit dem Lab04-Demo-Service.

## Typisches Betriebsszenario

Ein Dienst startet nach einer Änderung nicht mehr. Die Aufgabe besteht darin, den Zustand zu prüfen, Logs auszuwerten, den Exit-Code zu bewerten, die Ursache zu erkennen, einen Fix zu setzen und den Erfolg anschließend zu verifizieren.

## Vorbereitung

- Repository-Pfad prüfen: ~/projects/ubuntu-lab-baseline
- Arbeitsstand prüfen: git status --short
- Demo-Skript vorhanden: scripts/lab04-demo-service.sh
- systemd-Unit vorhanden: configs/systemd/lab04-demo.service
- Unit installiert unter: /etc/systemd/system/lab04-demo.service
- systemd neu geladen: sudo systemctl daemon-reload

## Normalzustand prüfen

- Steuerdatei auf ok setzen: echo ok | sudo tee /tmp/lab04-demo-service-mode
- failed-Zustand zurücksetzen: sudo systemctl reset-failed lab04-demo.service
- Dienst starten: sudo systemctl start lab04-demo.service
- Status prüfen: systemctl status lab04-demo.service --no-pager -l
- Detailstatus prüfen: systemctl show lab04-demo.service -p ActiveState -p SubState -p Result -p ExecMainStatus --no-pager

Erwartung:

- Result=success
- ExecMainStatus=0
- inactive (dead) ist bei Type=oneshot nach erfolgreichem Lauf normal

## Fehlerzustand prüfen

- Steuerdatei auf fail setzen: echo fail | sudo tee /tmp/lab04-demo-service-mode
- failed-Zustand zurücksetzen: sudo systemctl reset-failed lab04-demo.service
- Dienst starten: sudo systemctl start lab04-demo.service
- Status prüfen: systemctl status lab04-demo.service --no-pager -l
- Logs prüfen: journalctl -u lab04-demo.service --no-pager -n 40 -o short-iso
- failed-State prüfen: systemctl is-failed lab04-demo.service

Erwartung:

- Active: failed (Result: exit-code)
- ExecMainStatus=42
- Current mode: fail
- Simulated failure: mode is fail

## Wiederherstellung prüfen

- Steuerdatei auf ok setzen: echo ok | sudo tee /tmp/lab04-demo-service-mode
- failed-Zustand zurücksetzen: sudo systemctl reset-failed lab04-demo.service
- Dienst erneut starten: sudo systemctl start lab04-demo.service
- Detailstatus prüfen: systemctl show lab04-demo.service -p ActiveState -p SubState -p Result -p ExecMainStatus --no-pager

Erwartung:

- Result=success
- ExecMainStatus=0
- Dienst wurde nach Fehlerzustand erfolgreich wiederhergestellt

## Wiederholbarer Health-Check

- Health-Check ausführen: sudo ./scripts/check-lab04-systemd-demo.sh
- Exit-Code prüfen: echo $?

Erwartung:

- Normalzustand erfolgreich
- erwarteter Fehlerzustand korrekt erkannt
- Wiederherstellung erfolgreich
- Exit-Code 0

## Dokumentationsnachweise

- docs/operations/lab04-systemd-fehlerdiagnose-demo-service.md
- docs/operations/lab04-systemd-demo-health-check-output.txt
- runbooks/systemd-fehlerdiagnose-demo-service.md
- troubleshooting/cards/systemd-fehlerdiagnose-demo-service.md

## Betriebliche Bewertung

Die Checkliste zeigt, dass ein Service-Fehler nicht nur beobachtet, sondern systematisch diagnostiziert, reproduziert und behoben wurde.

## Merksätze

- failed ist nicht die Diagnose. failed ist nur das Warnschild.
- systemctl zeigt den Zustand. journalctl zeigt die Geschichte.
- Ein gutes Log erzählt: vorher, Fehler, danach.
- Erst Ursache finden, dann Fix setzen, dann verifizieren.
- Checklisten sind Sicherheitsgurte für wiederholbare Betriebsarbeit.
