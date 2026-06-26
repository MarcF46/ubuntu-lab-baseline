# Incident-Karte – Lab18 Monitoring-Agent oder Timer gestört

## Zweck

Diese Incident-Karte beschreibt die Erstreaktion, wenn der Lab18-Monitoring-Agent, der systemd-User-Service oder der systemd-User-Timer nicht erwartungsgemäß funktioniert.

## Geltungsbereich

| Baustein | Pfad oder Befehl | Rolle |
|---|---|---|
| Agent-Skript | scripts/lab18-monitoring-agent-safe.sh | führt read-only Checks aus |
| Service | lab18-monitoring-agent.service | startet das Agent-Skript |
| Timer | lab18-monitoring-agent.timer | startet den Service regelmäßig |
| Logs | journalctl --user -u lab18-monitoring-agent.service | zeigt Agent-Ergebnisse |

## Sofortbewertung

| Symptom | Priorität | Bedeutung |
|---|---|---|
| Timer inactive (dead), obwohl Test erwartet wird | WARNING | automatische Ausführung läuft nicht |
| Service failed | WARNING bis CRITICAL | Agent-Ausführung fehlgeschlagen |
| Keine neuen journalctl-Einträge | WARNING | Timer oder Service startet nicht |
| Status: WARNING | WARNING | Prüfung erforderlich, kein direkter Ausfall bewiesen |
| Status: CRITICAL | CRITICAL | kritischer Zustand im geprüften Systembereich |
| sudo-Fehler im Journal | WARNING | Agent ist nicht mehr sudo-frei oder falsches Skript wird ausgeführt |
| Permission denied | WARNING | Skript oder Unit-Rechte prüfen |

## Erste Diagnosebefehle

```bash
systemctl --user status lab18-monitoring-agent.timer --no-pager -l  # Prüft den vollständigen Zustand des User-Timers.
systemctl --user status lab18-monitoring-agent.service --no-pager -l  # Prüft den vollständigen Zustand des User-Services.
systemctl --user list-timers --all | grep lab18-monitoring-agent || true  # Prüft, ob ein nächster Timerlauf geplant ist.
journalctl --user -u lab18-monitoring-agent.service -n 100 --no-pager -l  # Zeigt die letzten 100 vollständigen Agent-Logzeilen.
systemctl --user cat lab18-monitoring-agent.service  # Zeigt die tatsächlich geladene Service-Unit.
systemctl --user cat lab18-monitoring-agent.timer  # Zeigt die tatsächlich geladene Timer-Unit.
```

## Entscheidungsbaum

| Frage | Wenn ja | Wenn nein |
|---|---|---|
| Gibt es neue Agent-Logs? | Ergebnisstatus prüfen | Timer und Service prüfen |
| Ist der Timer aktiv oder geplant? | nächsten Lauf abwarten oder Service prüfen | Timer starten oder Unit prüfen |
| Ist der Service failed? | journalctl und Exit-Code prüfen | Timer-Kopplung prüfen |
| Meldet der Agent WARNING? | betroffenen Check prüfen | Normalbetrieb möglich |
| Meldet der Agent CRITICAL? | Incident priorisieren | weiter nach Fehlerbild suchen |
| Gibt es sudo-Fehler? | ExecStart und Skript prüfen | Agent bleibt sudo-frei |

## Häufige Fehlerbilder und Erstmaßnahmen

| Fehlerbild | Wahrscheinliche Ursache | Erstmaßnahme |
|---|---|---|
| Unit nicht gefunden | Service oder Timer nicht nach ~/.config/systemd/user kopiert | Unit-Dateien kopieren und daemon-reload ausführen |
| Timer startet nicht | Timer nicht gestartet oder nicht geladen | systemctl --user start lab18-monitoring-agent.timer ausführen |
| Kein nächster Timerlauf | Timer inaktiv | Timer-Status und list-timers prüfen |
| Permission denied | Skript nicht ausführbar | chmod +x scripts/lab18-monitoring-agent-safe.sh prüfen |
| sudo-Fehler | falsches Skript wird gestartet | ExecStart muss auf lab18-monitoring-agent-safe.sh zeigen |
| WARNING bei DNS | Namensauflösung gestört | getent hosts ubuntu.com und systemd-resolved prüfen |
| CRITICAL bei SSH | ssh.service oder Port 22 gestört | ssh.service und ss -tln prüfen |
| Keine Logs | Service wurde nicht ausgelöst | Timer, Service und journalctl-Zeitraum prüfen |

## Kontrollierter Neustart im Lab

```bash
systemctl --user daemon-reload  # Lädt systemd-User-Units neu, nachdem Unit-Dateien geändert oder kopiert wurden.
systemctl --user stop lab18-monitoring-agent.timer  # Stoppt den Timer kontrolliert.
systemctl --user start lab18-monitoring-agent.service  # Startet den Agent-Service einmal manuell zur Einzelprüfung.
journalctl --user -u lab18-monitoring-agent.service -n 80 --no-pager -l  # Prüft die letzten Agent-Logs nach dem manuellen Start.
systemctl --user start lab18-monitoring-agent.timer  # Startet den Timer erneut, wenn der Einzeltest erfolgreich war.
```

## Stop-Regel

Wenn der Timer wiederholt fehlerhafte oder unerwartete Logs erzeugt, wird im Lab zuerst der Timer gestoppt. Danach erfolgt die Diagnose über Service, Skript und Journal.

```bash
systemctl --user stop lab18-monitoring-agent.timer  # Stoppt weitere automatische Agent-Läufe während der Diagnose.
systemctl --user status lab18-monitoring-agent.timer --no-pager -l  # Prüft, ob der Timer wirklich gestoppt ist.
```

## BSI-orientierte Einordnung

Die Incident-Reaktion orientiert sich am BSI-IT-Grundschutz-Gedanken, ohne eine Zertifizierung zu behaupten. Im Vordergrund stehen kontrolliertes Vorgehen, minimale Rechte, Nachvollziehbarkeit, geordnete Fehlerdiagnose und Vermeidung unkontrollierter Änderungen.

Wichtige Prinzipien:

- Erst prüfen, dann ändern.
- Timer bei unklarem Verhalten kontrolliert stoppen.
- Keine pauschalen sudo-Rechte vergeben, nur um einen Agenten bequem lauffähig zu machen.
- Logs prüfen, bevor Service- oder Timer-Dateien angepasst werden.
- Änderungen am Agenten dokumentieren und versionieren.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Reaktion | manuell über Terminal | Incident-Prozess mit Rollen und Eskalation |
| Timer | manuell startbar und stoppbar | kontrolliert ausgerollt und überwacht |
| Logs | lokales User-Journal | zentrale Logplattform oder SIEM |
| Rechte | keine sudo-Aufrufe | dediziertes Servicekonto und minimale Rechte |
| Dokumentation | Git-Repo und Runbook | Betriebsdokumentation, Change- und Incident-System |

## Eskalationshinweis

Ein CRITICAL-Status des Agenten bedeutet nicht automatisch, dass der Agent selbst defekt ist. Häufig meldet der Agent einen kritischen Zustand eines überwachten Systembestandteils. Deshalb wird zuerst zwischen Agent-Störung und erkanntem Systemproblem unterschieden.

## Merksatz

Bei Agent-Störungen wird nicht blind repariert. Erst wird geklärt, ob der Melder defekt ist oder ob er korrekt ein echtes Problem meldet.
