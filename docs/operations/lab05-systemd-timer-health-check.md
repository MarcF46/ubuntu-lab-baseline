# Lab 05 – systemd Timer für geplanten Health-Check

## Ziel

Im Lab wurde ein systemd-Timer eingerichtet, der den Lab04-Health-Check automatisch über eine eigene Service-Unit ausführt.

## Typisches Betriebsszenario

Ein Health-Check soll nicht nur manuell ausgeführt werden, sondern regelmäßig und nachvollziehbar durch das System gestartet werden.

Typische Beispiele im Betrieb:

- regelmäßige Health Checks
- Backup-Prüfungen
- Cleanup-Jobs
- Log- oder Wartungsprüfungen
- einfache Monitoring-Hilfsjobs

## Technischer Nachweis

Erstellte systemd-Dateien:

- configs/systemd/lab05-health-check.service
- configs/systemd/lab05-health-check.timer

Installierte systemd-Units:

- /etc/systemd/system/lab05-health-check.service
- /etc/systemd/system/lab05-health-check.timer

Die Service-Unit führt den bestehenden Lab04-Health-Check aus.

Die Timer-Unit startet die Service-Unit automatisch.

## Beobachteter Zustand

Der Timer wurde aktiviert und befindet sich im Zustand active (waiting).

Der Timer zeigte einen geplanten nächsten Lauf und einen bereits erfolgten letzten Lauf.

Die ausgelöste Service-Unit wurde erfolgreich beendet:

- code=exited
- status=0/SUCCESS
- Lab04 systemd Demo Service Check erfolgreich

## Betriebliche Einordnung

Ein systemd-Timer ersetzt für viele einfache Aufgaben einen klassischen Cronjob. Der Vorteil liegt in der engen Integration mit systemd, journalctl, Unit-Abhängigkeiten und systemctl-list-timers.

Bei Type=oneshot ist inactive (dead) nach erfolgreicher Ausführung normal. Entscheidend ist, dass der Timer active (waiting) ist und der ausgelöste Service mit status=0/SUCCESS beendet wurde.

## Merksätze

- .service = Was soll ausgeführt werden?
- .timer = Wann soll es ausgeführt werden?
- Der Timer stellt den Wecker. Der Service erledigt die Arbeit.
- inactive (dead) ist bei oneshot nach Erfolg normal.
- list-timers zeigt den Dienstplan der systemd-Wecker.

## Nächster professioneller Schritt

Als nächster Schritt sollte ein Runbook entstehen, das Aktivierung, Prüfung, Deaktivierung und Troubleshooting des Timers beschreibt.
