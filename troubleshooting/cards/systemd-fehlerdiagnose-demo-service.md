# Troubleshooting-Karte – systemd-Fehlerdiagnose Demo-Service

## Zweck

Diese Karte hilft bei der schnellen Diagnose eines fehlgeschlagenen systemd-Dienstes anhand des Lab04-Demo-Service.

## Typisches Szenario

Ein Dienst startet nach einer Änderung nicht mehr. Der Status zeigt failed, aber die eigentliche Ursache muss über Status, Exit-Code und Logs eingegrenzt werden.

## Sofortprüfung

- systemctl status lab04-demo.service --no-pager -l
- systemctl show lab04-demo.service -p ActiveState -p SubState -p Result -p ExecMainStatus --no-pager
- journalctl -u lab04-demo.service --no-pager -n 40 -o short-iso
- systemctl is-failed lab04-demo.service

## Symptom 1 – Dienst ist failed

Typische Anzeige:

- Active: failed (Result: exit-code)
- Result=exit-code
- ExecMainStatus=42

Bedeutung:

- systemd konnte den Dienstlauf nicht erfolgreich abschließen.
- Der Demo-Service hat absichtlich mit Exit-Code 42 beendet.
- Die Ursache steht in diesem Lab meist in der Zeile Current mode: fail.

Prüfung:

- cat /tmp/lab04-demo-service-mode
- journalctl -u lab04-demo.service --no-pager -n 40 -o short-iso

Fix im Lab:

- echo ok | sudo tee /tmp/lab04-demo-service-mode
- sudo systemctl reset-failed lab04-demo.service
- sudo systemctl start lab04-demo.service

Verifikation:

- systemctl show lab04-demo.service -p Result -p ExecMainStatus --no-pager
- sudo ./scripts/check-lab04-systemd-demo.sh

## Symptom 2 – Dienst ist inactive (dead)

Bedeutung:

- Bei Type=oneshot ist inactive (dead) nach erfolgreicher Ausführung normal.
- Entscheidend sind Result=success und ExecMainStatus=0.

Prüfung:

- systemctl show lab04-demo.service -p ActiveState -p SubState -p Result -p ExecMainStatus --no-pager

## Symptom 3 – Unit ist systemd nicht bekannt

Typische Ursache:

- Unit-Datei wurde nicht nach /etc/systemd/system/ kopiert.
- systemctl daemon-reload wurde nach Änderung nicht ausgeführt.

Prüfung:

- systemctl cat lab04-demo.service
- ls -l /etc/systemd/system/lab04-demo.service

Fix im Lab:

- sudo cp configs/systemd/lab04-demo.service /etc/systemd/system/lab04-demo.service
- sudo systemctl daemon-reload
- systemctl cat lab04-demo.service

## Symptom 4 – Skript nicht ausführbar oder Pfad falsch

Typische Ursache:

- ExecStart zeigt auf einen falschen Pfad.
- Das Skript hat keine Ausführungsrechte.

Prüfung:

- systemctl cat lab04-demo.service
- ls -l scripts/lab04-demo-service.sh
- test -x scripts/lab04-demo-service.sh && echo OK || echo FEHLT

Fix im Lab:

- chmod +x scripts/lab04-demo-service.sh
- sudo systemctl daemon-reload
- sudo systemctl start lab04-demo.service

## Betriebliche Einordnung

Ein failed-Status ist nur ein Warnschild. Die Diagnose entsteht aus der Kombination von Dienststatus, Exit-Code und Logauswertung.

In Produktion können ähnliche Symptome entstehen durch:

- fehlerhafte Konfiguration
- fehlende Dateien
- falsche Berechtigungen
- ungültige Secrets
- volle Dateisysteme
- nicht erreichbare Datenbanken oder APIs
- fehlgeschlagene Updates

## Merksätze

- failed ist nicht die Diagnose. failed ist nur das Warnschild.
- systemctl zeigt den Zustand. journalctl zeigt die Geschichte.
- Exit-Code 0 bedeutet Erfolg. Alles andere braucht Bewertung.
- Ein gutes Log erzählt: vorher, Fehler, danach.
- Erst Ursache finden, dann Fix setzen, dann verifizieren.

## Kurze Statusmeldung

Der Demo-Service wurde kontrolliert in einen Fehlerzustand versetzt. systemd meldete Result=exit-code und ExecMainStatus=42. Die Logauswertung zeigte Current mode: fail als Ursache. Nach Rückstellung auf ok, reset-failed und erneutem Start wurde Result=success mit ExecMainStatus=0 verifiziert.
