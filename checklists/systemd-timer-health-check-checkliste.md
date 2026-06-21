# Checkliste – systemd Timer für geplanten Health-Check

## Zweck

Diese Checkliste dient zur schnellen Prüfung eines systemd-Timers, der einen Health-Check automatisch ausführt.

## Typisches Betriebsszenario

Ein Health-Check, Backup-Prüfjob, Cleanup-Skript oder Wartungsjob soll regelmäßig laufen. Die Aufgabe besteht darin, Timer, Service, letzten Lauf, nächsten Lauf und Logs nachvollziehbar zu prüfen.

## Grundprinzip

- .service beschreibt, was ausgeführt wird.
- .timer beschreibt, wann es ausgeführt wird.
- Der Timer startet die Service-Unit.
- Bei Type=oneshot beendet sich der Service nach erfolgreichem Lauf wieder.

## Relevante Dateien

- configs/systemd/lab05-health-check.service
- configs/systemd/lab05-health-check.timer
- /etc/systemd/system/lab05-health-check.service
- /etc/systemd/system/lab05-health-check.timer
- scripts/check-lab04-systemd-demo.sh

## Timer prüfen

- systemctl status lab05-health-check.timer --no-pager -l
- systemctl list-timers --all | grep -E "NEXT|lab05-health-check"

Erwartung:

- Timer ist loaded
- Timer ist enabled
- Timer ist active (waiting)
- NEXT zeigt den nächsten geplanten Lauf
- LAST zeigt den letzten Lauf
- ACTIVATES zeigt lab05-health-check.service

## Service-Lauf prüfen

- systemctl status lab05-health-check.service --no-pager -l
- journalctl -u lab05-health-check.service --no-pager -n 40 -o short-iso

Erwartung:

- Service wurde durch Timer ausgelöst
- code=exited
- status=0/SUCCESS
- Lab04 systemd Demo Service Check erfolgreich
- inactive (dead) ist bei Type=oneshot nach Erfolg normal

## Manuelle Service-Prüfung

- sudo systemctl start lab05-health-check.service
- echo $?
- systemctl status lab05-health-check.service --no-pager -l

Erwartung:

- Exit-Code 0
- Service-Lauf erfolgreich
- Health-Check erfolgreich

## Timer deaktivieren

- sudo systemctl disable --now lab05-health-check.timer
- systemctl status lab05-health-check.timer --no-pager -l

Erwartung:

- Timer ist deaktiviert
- Timer löst keine neuen Läufe mehr aus

## Timer wieder aktivieren

- sudo systemctl enable --now lab05-health-check.timer
- systemctl status lab05-health-check.timer --no-pager -l
- systemctl list-timers --all | grep -E "NEXT|lab05-health-check"

Erwartung:

- Timer ist wieder active (waiting)
- Nächster Lauf ist geplant

## Betriebliche Bewertung

Ein aktiver Timer allein reicht nicht aus. Entscheidend ist, ob der Timer tatsächlich den erwarteten Service startet und ob dieser Service erfolgreich beendet wird.

## Merksätze

- .service = Was soll ausgeführt werden?
- .timer = Wann soll es ausgeführt werden?
- Der Timer stellt den Wecker. Der Service erledigt die Arbeit.
- active (waiting) bedeutet: Der Timer wartet auf den nächsten Lauf.
- list-timers zeigt den Dienstplan der systemd-Wecker.
