# Checkliste – Ressourcen- und Prozessdiagnose

## Zweck

Diese Checkliste dient zur schnellen Prüfung von CPU, Load Average, RAM, Swap und auffälligen Prozessen.

## Basisprüfung

- uptime ausführen.
- nproc ausführen.
- free -h ausführen.
- LC_ALL=C free -m ausführen.
- ps aux --sort=-%mem | head -n 11 ausführen.
- ps aux --sort=-%cpu | head -n 11 ausführen.
- Bei Bedarf top starten.

## Load bewerten

- Load Average 1/5/15 Minuten notieren.
- Anzahl der CPU-Kerne prüfen.
- Load im Verhältnis zur CPU-Anzahl bewerten.
- Kurzen Peak von dauerhafter Last unterscheiden.

## RAM bewerten

- Gesamten RAM prüfen.
- Genutzten RAM prüfen.
- Verfügbaren RAM prüfen.
- Cache-Nutzung nicht vorschnell als Fehler bewerten.
- Auffällige Prozesse nach RAM prüfen.

## Swap bewerten

- Swap-Gesamtgröße prüfen.
- Genutzten Swap prüfen.
- Swap-Nutzung als Warnsignal bewerten.
- Bei Swap-Nutzung Prozesse und Logs zusätzlich prüfen.

## Prozesse bewerten

- Höchste CPU-Verbraucher prüfen.
- Höchste RAM-Verbraucher prüfen.
- Prozessnamen fachlich einordnen.
- Bei unbekannten Prozessen PID genauer prüfen.
- Nicht blind Prozesse beenden.

## Ergänzende Prüfungen

- systemctl --failed --no-pager ausführen.
- journalctl -p warning..alert --since "1 hour ago" --no-pager prüfen.
- Bei Dienstverdacht systemctl status <dienstname> prüfen.
- Bei Dienstverdacht journalctl -u <dienstname> prüfen.

## Typische Fehlerbilder

- Dauerhaft hohe CPU-Last.
- Dauerhaft hoher Load.
- RAM wird knapp.
- Swap wird genutzt.
- Einzelner Prozess dominiert CPU oder RAM.
- Hoher Load bei niedriger CPU-Nutzung.
- System wirkt langsam trotz scheinbar niedriger Auslastung.

## Sicheres Verhalten

- Erst messen.
- Dann bewerten.
- Dann handeln.
- Prozess nicht ohne Zweckprüfung beenden.
- Bei produktiven Systemen Dienstkritikalität und Nutzerwirkung beachten.
- Bei Incident-Verdacht Zustand dokumentieren.

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Prüfung. In Produktion sollten CPU, RAM, Swap, Load, Prozessanzahl und Dienstzustände über Monitoring, Alerting und zentrale Logs überwacht werden.

## Merksätze

- CPU ist die Arbeitskraft.
- RAM ist die Werkbank.
- Swap ist die Notablage.
- Load ist die Warteschlange.
- Ein Peak ist ein Klingeln, Dauerlast ist ein Alarm.
