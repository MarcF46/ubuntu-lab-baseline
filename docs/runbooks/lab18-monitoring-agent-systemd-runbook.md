# Runbook – Lab18 Monitoring-Agent mit systemd-User-Service und Timer

## Zweck

Dieses Runbook beschreibt Betrieb, Prüfung, Start, Stopp, Logauswertung und Fehlerdiagnose des Lab18-Monitoring-Agenten.

Der Agent ist ein lokaler read-only Monitoring-Baustein. Er läuft ohne sudo-Aufrufe, wird über systemd kontrolliert ausgeführt und schreibt seine Ergebnisse in das User-Journal.

## Bausteine

| Baustein | Pfad oder Befehl | Aufgabe |
|---|---|---|
| Agent-Skript | scripts/lab18-monitoring-agent-safe.sh | führt read-only Checks aus |
| systemd-Service | systemd/user/lab18-monitoring-agent.service | startet das Skript kontrolliert |
| systemd-Timer | systemd/user/lab18-monitoring-agent.timer | startet den Service regelmäßig |
| aktive User-Units | ~/.config/systemd/user/ | lokal installierte Testkopien |
| Logs | journalctl --user -u lab18-monitoring-agent.service | zeigt Agent-Läufe und Ergebnisse |

## Standardprüfung

Für eine schnelle Prüfung des Agent-Zustands werden folgende Befehle genutzt:

```bash
systemctl --user status lab18-monitoring-agent.service --no-pager -l
systemctl --user status lab18-monitoring-agent.timer --no-pager -l
journalctl --user -u lab18-monitoring-agent.service -n 80 --no-pager -l
```

## Service manuell starten

Der Service kann einmalig manuell gestartet werden:

```bash
systemctl --user start lab18-monitoring-agent.service
echo "$?"
journalctl --user -u lab18-monitoring-agent.service -n 50 --no-pager -l
```

Erwartung bei gesundem System:

- systemctl-Start liefert Exit-Code 0.
- journalctl zeigt Status OK.
- Es erscheinen keine sudo-Fehler.
- Der Service steht danach bei Type=oneshot erwartbar auf inactive (dead).

## Timer starten

Der Timer startet den Service regelmäßig:

```bash
systemctl --user start lab18-monitoring-agent.timer
systemctl --user status lab18-monitoring-agent.timer --no-pager -l
systemctl --user list-timers --all | grep lab18-monitoring-agent
```

Hinweis: Im Lab wird der Timer manuell gestartet und nicht dauerhaft aktiviert.

## Timer stoppen

Der Timer wird im Lab nach Tests kontrolliert gestoppt:

```bash
systemctl --user stop lab18-monitoring-agent.timer
systemctl --user status lab18-monitoring-agent.timer --no-pager -l
systemctl --user list-timers --all | grep lab18-monitoring-agent || true
```

Erwartung nach Stopp:

- Timer steht auf inactive (dead).
- Es ist kein nächster Lab18-Timerlauf geplant.

## Logauswertung

Die wichtigste Diagnosequelle ist das User-Journal:

```bash
journalctl --user -u lab18-monitoring-agent.service -n 100 --no-pager -l
journalctl --user -u lab18-monitoring-agent.service --since "today" --no-pager -l
```

Wichtige Suchmuster:

| Muster | Bedeutung | Bewertung |
|---|---|---|
| Status: OK | Agent sieht keine akute Auffälligkeit | Normalzustand |
| Status: WARNING | Prüfung erforderlich | Runbook und Matrix nutzen |
| Status: CRITICAL | Kritischer Zustand | Incident-Karte nutzen |
| sudo: interactive authentication is required | Agent ist nicht sudo-frei | Rechtemodell oder Skript prüfen |
| Failed with result | systemd bewertet Ausführung als fehlgeschlagen | Exit-Code und Log prüfen |

## Fehlerdiagnose

| Symptom | Mögliche Ursache | Erste Prüfung |
|---|---|---|
| Timer startet nicht | Unit nicht geladen | systemctl --user daemon-reload ausführen |
| Service nicht gefunden | Unit nicht nach ~/.config/systemd/user kopiert | systemctl --user cat prüfen |
| Permission denied | Skript nicht ausführbar | chmod +x und Dateirechte prüfen |
| sudo-Fehler im Journal | falsches Skript oder privilegierter Check | ExecStart und Skriptinhalt prüfen |
| Status WARNING | Dienst oder Basischeck auffällig | journalctl-Ausgabe und Monitoring-Matrix prüfen |
| Status CRITICAL | kritischer Dienst oder Port auffällig | Incident-Karte nutzen |

## BSI-orientierte Einordnung

Das Runbook orientiert sich am BSI-IT-Grundschutz-Gedanken, ohne eine Zertifizierung zu behaupten. Im Fokus stehen kontrollierte Ausführung, minimale Rechte, Nicht-Interaktivität, Nachvollziehbarkeit und dokumentierte Reaktion.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Timer | manuell gestartet und gestoppt | kontrolliert aktiviert, überwacht und dokumentiert |
| Benutzer | normaler Benutzer | dediziertes Servicekonto |
| Logs | lokales User-Journal | zentrale Logplattform oder SIEM |
| Rechte | keine sudo-Aufrufe | minimale Rechte nach Freigabeprozess |
| Alarmierung | manuelle Logprüfung | Monitoring-System mit Alarmregeln |

## Merksatz

Ein Agent ist erst betreibbar, wenn Start, Stopp, Logs, Fehlerbilder und Zuständigkeiten dokumentiert sind.
