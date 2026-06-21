# Runbook – systemd Timer für geplanten Health-Check

## Ziel

Dieses Runbook beschreibt die Einrichtung, Prüfung und Deaktivierung eines systemd-Timers, der einen Health-Check automatisch ausführt.

## Typisches Betriebsszenario

Ein Health-Check, Backup-Prüfjob, Cleanup-Skript oder Wartungsjob soll nicht manuell gestartet werden, sondern regelmäßig und nachvollziehbar durch das System laufen.

## Grundprinzip

- Die .service-Datei beschreibt, was ausgeführt wird.
- Die .timer-Datei beschreibt, wann es ausgeführt wird.
- Der Timer startet die zugehörige Service-Unit.
- Bei Type=oneshot beendet sich der Service nach erfolgreicher Ausführung wieder.

## Relevante Dateien

- configs/systemd/lab05-health-check.service
- configs/systemd/lab05-health-check.timer
- /etc/systemd/system/lab05-health-check.service
- /etc/systemd/system/lab05-health-check.timer
- scripts/check-lab04-systemd-demo.sh

## Installation der Units

- sudo cp configs/systemd/lab05-health-check.service /etc/systemd/system/lab05-health-check.service
- sudo cp configs/systemd/lab05-health-check.timer /etc/systemd/system/lab05-health-check.timer
- sudo systemctl daemon-reload

## Timer aktivieren

- sudo systemctl enable --now lab05-health-check.timer

Erwartung:

- Der Timer ist enabled.
- Der Timer ist active (waiting).
- Ein nächster Lauf wird angezeigt.

## Timer prüfen

- systemctl status lab05-health-check.timer --no-pager -l
- systemctl list-timers --all | grep -E "NEXT|lab05-health-check"

Wichtige Anzeige:

- Active: active (waiting)
- NEXT zeigt den nächsten geplanten Lauf.
- LAST zeigt den letzten ausgeführten Lauf.
- ACTIVATES zeigt die gestartete Service-Unit.

## Service-Lauf prüfen

- systemctl status lab05-health-check.service --no-pager -l
- journalctl -u lab05-health-check.service --no-pager -n 40 -o short-iso

Erwartung:

- code=exited
- status=0/SUCCESS
- Lab04 systemd Demo Service Check erfolgreich

## Timer manuell testen

Der Timer kann indirekt geprüft werden, indem der Service manuell gestartet wird:

- sudo systemctl start lab05-health-check.service
- echo $?
- systemctl status lab05-health-check.service --no-pager -l

Erwartung:

- Exit-Code 0
- Service endet erfolgreich
- Bei Type=oneshot ist inactive (dead) nach erfolgreichem Lauf normal

## Timer deaktivieren

- sudo systemctl disable --now lab05-health-check.timer
- systemctl status lab05-health-check.timer --no-pager -l
- systemctl list-timers --all | grep -E "NEXT|lab05-health-check"

## Betriebliche Einordnung

systemd-Timer sind für viele einfache geplante Aufgaben eine moderne Alternative zu Cronjobs. Sie sind gut mit systemctl, journalctl, Unit-Abhängigkeiten und list-timers integrierbar.

In Produktion wären zusätzlich sinnvoll:

- klare Laufintervalle passend zum Risiko
- Logging mit begrenzter Lautstärke
- Alerting bei fehlgeschlagenen Läufen
- zentrale Logsammlung
- dokumentierte Deaktivierung und Wiederaktivierung
- Change- und Rollback-Prozess für kritische Jobs

## Merksätze

- .service = Was soll ausgeführt werden?
- .timer = Wann soll es ausgeführt werden?
- Der Timer stellt den Wecker. Der Service erledigt die Arbeit.
- active (waiting) bedeutet: Der Timer wartet auf den nächsten Lauf.
- list-timers zeigt den Dienstplan der systemd-Wecker.
