# Lab18d – systemd-User-Timer für Monitoring-Agent

## Zweck

Dieses Dokument beschreibt den ersten systemd-User-Timer für den lokalen Monitoring-Agenten. Ziel ist die regelmäßige, nicht-interaktive und nachvollziehbare Ausführung des Agent-Services.

## Ergebnis

Der systemd-User-Timer wurde erstellt, installiert, gestartet und erfolgreich getestet. Der Timer hat den Agent-Service mehrfach automatisch ausgeführt.

| Prüfpunkt | Ergebnis | Bewertung |
|---|---|---|
| Timer-Unit vorhanden | ja | Timer ist im Repository dokumentiert |
| Timer syntaktisch geprüft | ja | Unit wurde mit systemd-analyze verify geprüft |
| Timer manuell gestartet | erfolgreich | systemctl --user start lieferte Exit-Code 0 |
| Timer-Zustand während Test | active (waiting) | korrekt für wartenden Timer |
| Agent-Ausführung durch Timer | erfolgreich | journalctl zeigt automatische Agent-Läufe |
| Agent-Ergebnis | Status OK, Exit-Code 0 | keine akute Auffälligkeit erkannt |
| sudo-Fehler | keine neuen im Timer-Test | Agent bleibt nicht-interaktiv und sudo-frei |
| Timer nach Test | kontrolliert stoppbar | Lab-Betrieb bleibt beherrschbar |

## Technische Bausteine

| Baustein | Pfad | Aufgabe |
|---|---|---|
| Agent-Skript | scripts/lab18-monitoring-agent-safe.sh | führt read-only Checks ohne sudo aus |
| Agent-Service | systemd/user/lab18-monitoring-agent.service | startet das Agent-Skript kontrolliert |
| Agent-Timer | systemd/user/lab18-monitoring-agent.timer | startet den Service regelmäßig |
| User-Journal | journalctl --user -u lab18-monitoring-agent.service | dokumentiert automatische Agent-Läufe |

## Timer-Konfiguration

| Einstellung | Bedeutung | Bewertung |
|---|---|---|
| OnActiveSec=30s | erster Lauf 30 Sekunden nach Timer-Start | gut für Lab-Test |
| OnUnitActiveSec=5min | weitere Läufe 5 Minuten nach dem letzten Service-Start | gut sichtbar im Lab |
| AccuracySec=10s | systemd darf den Lauf leicht bündeln | normal und effizient |
| Unit=lab18-monitoring-agent.service | Timer startet den Agent-Service | klare Service-Timer-Kopplung |
| Persistent=false | verpasste Läufe werden nicht nachgeholt | passend für kontrollierten Lab-Betrieb |

## Beobachtete Timer-Läufe

Im Test wurden automatische Agent-Läufe über journalctl nachvollzogen. Sichtbare Läufe erfolgten um 18:24:09, 18:29:19 und 18:34:29. Jeder Lauf meldete Status OK und Exit-Code 0.

## systemd-Einordnung

Der Timer ist der zeitliche Auslöser. Der Service bleibt die eigentliche Aufgabe. Dadurch sind Zeitplanung und Ausführung sauber getrennt.

Der Service verwendet Type=oneshot. Nach erfolgreicher Ausführung beendet er sich wieder. Der Timer bleibt aktiv wartend und löst den nächsten Service-Lauf aus.

## BSI-orientierte Einordnung

Die Umsetzung orientiert sich am BSI-IT-Grundschutz-Gedanken, ohne eine Zertifizierung zu behaupten. Der Schwerpunkt liegt auf kontrollierter Ausführung, minimalen Rechten, Nachvollziehbarkeit und geordnetem Betrieb.

Wichtige Prinzipien:

- Least Privilege: Der Agent läuft ohne Root-Rechte.
- Nicht-Interaktivität: Der Timer erzeugt keine Passwortabfragen.
- Nachvollziehbarkeit: Jeder Lauf ist im User-Journal sichtbar.
- Trennung der Zuständigkeiten: Timer plant, Service führt aus, Skript prüft.
- Kontrollierbarkeit: Der Timer wurde im Lab gestartet und danach kontrolliert stoppbar gehalten.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Timer-Kontext | systemd-User-Timer | häufig systemweiter Timer oder professioneller Agent-Scheduler |
| Intervall | 5 Minuten für sichtbaren Test | abhängig von Kritikalität, Last und Monitoring-Konzept |
| Benutzer | normaler Benutzer marc | dediziertes Servicekonto |
| Logging | lokales User-Journal | zentrale Logplattform, SIEM oder Monitoring-System |
| Aktivierung | manuell im Lab gestartet | kontrolliert ausgerollt, dokumentiert und überwacht |

## Betriebsbewertung

Mit Lab18d ist aus einem manuell startbaren Healthcheck ein regelmäßig ausführbarer lokaler Monitoring-Baustein geworden. Der Agent läuft ohne sudo, schreibt nachvollziehbare Logs und kann über systemd kontrolliert gestartet und gestoppt werden.

## Nächster Schritt

Der nächste Schritt ist ein Runbook für Betrieb, Prüfung, Stoppen, Starten, Logauswertung und Fehlerdiagnose des Lab18-Agenten.

## Merksatz

Der Service ist die Aufgabe. Der Timer ist der Wecker. Das Journal ist der Nachweis.
