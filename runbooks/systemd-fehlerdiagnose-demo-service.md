# Runbook – systemd-Fehlerdiagnose mit Demo-Service

## Ziel

Dieses Runbook beschreibt die kontrollierte Diagnose eines systemd-Dienstes anhand eines ungefährlichen Demo-Service.

Trainiert wird der Ablauf:

- Dienststatus prüfen
- Logs auswerten
- Exit-Code interpretieren
- Ursache ableiten
- Fix setzen
- Zustand erneut verifizieren

## Typisches Betriebsszenario

Ein Dienst, Wartungsskript, Backupjob oder Importprozess startet nach einer Änderung nicht mehr. Im Betrieb reicht die Meldung Service failed nicht aus. Erwartet wird eine nachvollziehbare Diagnose mit Status, Logauszug, Ursache, Maßnahme und erfolgreicher Nachprüfung.

## Voraussetzungen

- Die systemd-Unit lab04-demo.service ist unter /etc/systemd/system/lab04-demo.service installiert.
- Das Skript scripts/lab04-demo-service.sh ist ausführbar.
- systemd kennt die Unit nach sudo systemctl daemon-reload.
- Für Start, Reset und Diagnose werden sudo-Rechte benötigt.

## Relevante Dateien

- configs/systemd/lab04-demo.service
- scripts/lab04-demo-service.sh
- scripts/check-lab04-systemd-demo.sh
- docs/operations/lab04-systemd-demo-health-check-output.txt
- /tmp/lab04-demo-service-mode

## Normalzustand prüfen

Die Steuerdatei wird auf ok gesetzt. Danach wird der Dienst gestartet und ausgewertet.

Befehle:

- echo ok | sudo tee /tmp/lab04-demo-service-mode
- sudo systemctl reset-failed lab04-demo.service
- sudo systemctl start lab04-demo.service
- systemctl status lab04-demo.service --no-pager -l
- systemctl show lab04-demo.service -p ActiveState -p SubState -p Result -p ExecMainStatus --no-pager

Erwartung:

- Result=success
- ExecMainStatus=0
- Bei Type=oneshot ist inactive (dead) nach erfolgreicher Ausführung normal.

## Fehlerzustand erzeugen

Die Steuerdatei wird auf fail gesetzt. Der Dienst beendet sich absichtlich mit Exit-Code 42.

Befehle:

- echo fail | sudo tee /tmp/lab04-demo-service-mode
- sudo systemctl reset-failed lab04-demo.service
- sudo systemctl start lab04-demo.service
- systemctl status lab04-demo.service --no-pager -l
- journalctl -u lab04-demo.service --no-pager -n 40 -o short-iso
- systemctl is-failed lab04-demo.service

Erwartung:

- Active: failed (Result: exit-code)
- status=42
- Current mode: fail
- Simulated failure: mode is fail

## Ursache bewerten

Die Ursache ergibt sich aus der Kombination von systemd-Status, Service-Exit-Code und journalctl-Logausgabe.

Bewertung:

- systemctl start liefert Exit-Code 1, weil systemd den Startauftrag nicht erfolgreich abschließen konnte.
- Der Dienst selbst liefert ExecMainStatus=42, weil das Demo-Skript absichtlich mit Fehler beendet wurde.
- Die Logzeile Current mode: fail beschreibt die konkrete Ursache im Lab.

## Wiederherstellung

Die Steuerdatei wird zurück auf ok gesetzt. Danach wird der failed-Zustand gelöscht und der Dienst erneut gestartet.

Befehle:

- echo ok | sudo tee /tmp/lab04-demo-service-mode
- sudo systemctl reset-failed lab04-demo.service
- sudo systemctl start lab04-demo.service
- systemctl show lab04-demo.service -p ActiveState -p SubState -p Result -p ExecMainStatus --no-pager

Erwartung:

- Result=success
- ExecMainStatus=0
- Der Dienst ist nach erfolgreicher Ausführung wieder inactive (dead), weil es ein oneshot-Dienst ist.

## Wiederholbarer Health-Check

Der gesamte Ablauf kann mit folgendem Skript geprüft werden:

- sudo ./scripts/check-lab04-systemd-demo.sh

Erwartung:

- Normalzustand erfolgreich
- erwarteter Fehlerzustand mit ExecMainStatus=42
- Wiederherstellung erfolgreich
- Lab04-Health-Check Exit-Code: 0

## Risiko und Sicherheit

Der Demo-Service wurde bewusst gewählt, weil er keinen produktiven Zugang und keinen echten Dienst gefährdet. Kritische Dienste wie ssh.service sollten nicht leichtfertig in Fehlerzustände gebracht werden.

Bei echten Diensten gilt:

- zweiten Zugangspfad sicherstellen
- bestehende Sitzung offen lassen
- Konfiguration vor Neustart prüfen
- Logs vor und nach Änderung sichern
- Änderung dokumentieren
- Rollback-Möglichkeit kennen

## Lab-vs-Production-Einordnung

Im Lab wird der Fehler kontrolliert über eine temporäre Datei simuliert. In Produktion entstehen ähnliche Fehler durch fehlerhafte Konfigurationen, Updates, fehlende Dateien, Berechtigungsprobleme, falsche Secrets, volle Dateisysteme oder externe Abhängigkeiten.

Produktionsnah wären zusätzlich:

- Monitoring auf failed Units
- Alerting bei wiederholten Startfehlern
- zentrale Logsammlung
- Runbook mit Eskalationspfad
- Change-Freigabe für kritische Dienste
- Rollback-Plan

## Merksätze

- failed ist nicht die Diagnose. failed ist nur das Warnschild.
- Die Ursache steht meistens im Log.
- systemctl zeigt den Zustand. journalctl zeigt die Geschichte.
- Ein gutes Log erzählt: vorher, Fehler, danach.
- Erst am Dummy üben, dann an echten Diensten arbeiten.
