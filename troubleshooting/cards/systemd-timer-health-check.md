# Troubleshooting-Karte – systemd Timer Health-Check

## Zweck

Diese Karte hilft bei der schnellen Diagnose eines systemd-Timers, der einen Health-Check-Service auslösen soll.

## Typisches Szenario

Ein geplanter Health-Check soll regelmäßig laufen. Unklar ist, ob der Timer aktiv ist, ob der Service gestartet wurde oder ob der Service beim Lauf fehlgeschlagen ist.

## Sofortprüfung

- systemctl status lab05-health-check.timer --no-pager -l
- systemctl list-timers --all | grep -E "NEXT|lab05-health-check"
- systemctl status lab05-health-check.service --no-pager -l
- journalctl -u lab05-health-check.service --no-pager -n 40 -o short-iso

## Symptom 1 – Timer ist inactive oder disabled

Bedeutung:

- Der Timer wartet nicht auf den nächsten Lauf.
- Der Health-Check wird nicht automatisch ausgelöst.

Prüfung:

- systemctl status lab05-health-check.timer --no-pager -l
- systemctl is-enabled lab05-health-check.timer

Fix:

- sudo systemctl enable --now lab05-health-check.timer
- systemctl status lab05-health-check.timer --no-pager -l

Erwartung:

- Active: active (waiting)
- enabled

## Symptom 2 – Timer ist aktiv, aber Service-Lauf unklar

Bedeutung:

- Der Timer ist eingeschaltet, aber der letzte Service-Lauf muss geprüft werden.

Prüfung:

- systemctl list-timers --all | grep -E "NEXT|lab05-health-check"
- systemctl status lab05-health-check.service --no-pager -l
- journalctl -u lab05-health-check.service --no-pager -n 40 -o short-iso

Erwartung:

- LAST zeigt einen letzten Lauf.
- ACTIVATES zeigt lab05-health-check.service.
- Service endet mit status=0/SUCCESS.

## Symptom 3 – Service ist inactive (dead)

Bedeutung:

- Bei Type=oneshot ist inactive (dead) nach erfolgreicher Ausführung normal.
- Entscheidend ist der letzte Exit-Status.

Prüfung:

- systemctl status lab05-health-check.service --no-pager -l

Erwartung:

- code=exited
- status=0/SUCCESS
- Lab04 systemd Demo Service Check erfolgreich

## Symptom 4 – Timer-Unit oder Service-Unit ist systemd nicht bekannt

Typische Ursache:

- Unit-Datei wurde nicht nach /etc/systemd/system/ kopiert.
- systemctl daemon-reload wurde nach einer Änderung nicht ausgeführt.

Prüfung:

- systemctl cat lab05-health-check.service
- systemctl cat lab05-health-check.timer
- ls -l /etc/systemd/system/lab05-health-check.service
- ls -l /etc/systemd/system/lab05-health-check.timer

Fix:

- sudo cp configs/systemd/lab05-health-check.service /etc/systemd/system/lab05-health-check.service
- sudo cp configs/systemd/lab05-health-check.timer /etc/systemd/system/lab05-health-check.timer
- sudo systemctl daemon-reload
- sudo systemctl enable --now lab05-health-check.timer

## Symptom 5 – Service schlägt fehl

Bedeutung:

- Der Timer funktioniert, aber der ausgeführte Health-Check-Service endet fehlerhaft.

Prüfung:

- systemctl status lab05-health-check.service --no-pager -l
- journalctl -u lab05-health-check.service --no-pager -n 80 -o short-iso
- sudo ./scripts/check-lab04-systemd-demo.sh

Bewertung:

- Timer-Probleme und Service-Probleme getrennt prüfen.
- Timer aktiv bedeutet nicht automatisch, dass der Service erfolgreich war.

## Betriebliche Einordnung

Ein systemd-Timer ist nur die Planungsebene. Der eigentliche Erfolg hängt vom ausgelösten Service und dessen Exit-Code ab.

In Produktion sollten fehlgeschlagene Timer-Jobs nicht nur geloggt, sondern über Monitoring oder Alerting sichtbar gemacht werden.

## Merksätze

- .timer stellt den Wecker. .service erledigt die Arbeit.
- active (waiting) bedeutet: Der Timer wartet auf den nächsten Lauf.
- inactive (dead) ist bei oneshot nach Erfolg normal.
- Timer aktiv heißt nicht automatisch: Job erfolgreich.
- Erst Timer prüfen, dann Service prüfen, dann Logs lesen.

## Kurze Statusmeldung

Der lab05-health-check.timer ist aktiv und wartet auf den nächsten Lauf. Der Timer löst lab05-health-check.service aus. Der letzte Service-Lauf wurde mit status=0/SUCCESS beendet und der Lab04-Health-Check meldete ein erfolgreiches Ergebnis.
