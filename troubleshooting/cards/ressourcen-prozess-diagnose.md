# Troubleshooting-Karte – Ressourcen- und Prozessdiagnose

## Zweck

Diese Karte hilft bei typischen Ressourcenproblemen auf Linux-Systemen: hohe CPU-Last, hoher Load Average, knapper RAM, Swap-Nutzung und auffällige Prozesse.

## Sofortprüfung

- uptime
- nproc
- free -h
- ps aux --sort=-%cpu | head -n 11
- ps aux --sort=-%mem | head -n 11
- systemctl --failed --no-pager
- journalctl -p warning..alert --since "1 hour ago" --no-pager

## Symptom 1 – System wirkt langsam

Mögliche Ursachen:

- hohe CPU-Last
- RAM knapp
- Swap wird genutzt
- I/O-Wartezeit durch Datenträger
- einzelner Prozess blockiert Ressourcen
- Desktop- oder Browserprozess erzeugt Last
- Hintergrundaufgabe läuft, zum Beispiel Update, Backup, Indexierung oder Scan

Prüfung:

- uptime
- free -h
- top
- ps aux --sort=-%cpu | head -n 11
- ps aux --sort=-%mem | head -n 11

Bewertung:

- Erst prüfen, ob die Last dauerhaft oder nur kurzzeitig ist.
- Einzelne Peaks sind normal.
- Dauerhafte Überlast mit Nutzerwirkung ist ein Incident-Kandidat.

## Symptom 2 – Load Average ist hoch

Mögliche Ursachen:

- viele laufende oder wartende Prozesse
- CPU-Engpass
- I/O-Wartezeit
- blockierte Prozesse
- langsamer Datenträger
- externer Datenträger oder Netzwerkdateisystem reagiert träge

Prüfung:

- uptime
- cat /proc/loadavg
- nproc
- top

Bewertung:

- Load immer im Verhältnis zur CPU-Anzahl bewerten.
- Load 1.0 auf einem 1-Core-System ist deutlich relevanter als Load 1.0 auf einem 12-Core-System.
- Hoher Load bei niedriger CPU-Nutzung kann auf I/O-Wartezeit oder blockierte Prozesse hinweisen.

## Symptom 3 – CPU-Last ist hoch

Mögliche Ursachen:

- ein Prozess rechnet dauerhaft
- ein Dienst läuft in einer Fehlerschleife
- Browser, IDE, Build, Scan, Backup oder Update erzeugt Last
- ein Prozess ist hängen geblieben
- in Produktion: auch potenziell kompromittierter Prozess möglich

Prüfung:

- ps aux --sort=-%cpu | head -n 11
- top
- systemctl --failed --no-pager

Einen Prozess genauer prüfen:

- ps -p <PID> -o pid,ppid,user,stat,%cpu,%mem,rss,vsz,comm,args

Bewertung:

- Prozessname und Zweck prüfen.
- Prüfen, ob der Prozess zu einer erwarteten Anwendung gehört.
- Nicht sofort per kill beenden.
- Bei Diensten bevorzugt systemctl status und journalctl prüfen.

## Symptom 4 – RAM wird knapp

Mögliche Ursachen:

- viele Programme oder Browser-Tabs
- große Anwendung
- Datenbank oder Cache
- Container oder virtuelle Maschine
- Speicherleck
- dauerhaft wachsender Prozess

Prüfung:

- free -h
- LC_ALL=C free -m
- ps aux --sort=-%mem | head -n 11

Bewertung:

- Linux nutzt RAM auch als Cache.
- Wichtig ist der Wert available.
- Hoher used-Wert allein ist nicht automatisch kritisch.
- Kritisch wird es bei wenig available RAM, Swap-Nutzung und verlangsamtem System.

## Symptom 5 – Swap wird genutzt

Mögliche Ursachen:

- RAM war zeitweise knapp
- großer Prozesspeak
- lange Systemlaufzeit
- Workload passt nicht zur RAM-Größe
- Speicherleck

Prüfung:

- free -h
- swapon --show
- ps aux --sort=-%mem | head -n 11

Bewertung:

- 0 MiB Swap-Nutzung ist unauffällig.
- Kleine Swap-Nutzung ist nicht automatisch kritisch.
- Steigende Swap-Nutzung mit langsamem System ist ernst zu nehmen.

## Symptom 6 – Einzelner Prozess dominiert CPU oder RAM

Mögliche Ursachen:

- normale Last durch aktive Anwendung
- hängender Prozess
- falsch konfigurierte Anwendung
- Fehlerloop
- ungewöhnlicher oder unbekannter Prozess

Prüfung:

- ps -p <PID> -o pid,ppid,user,stat,%cpu,%mem,rss,vsz,comm,args
- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager

Bewertung:

- Erst verstehen, was der Prozess ist.
- Parent-Prozess prüfen.
- Dienstlogs prüfen.
- Nutzerwirkung prüfen.
- Eingriff dokumentieren.

## Typischer Anfängerfehler

Ein auffälliger Prozess wird sofort beendet, ohne Zweck, Ursache oder Auswirkung zu prüfen. Dadurch kann ein Dienst ungeplant ausfallen, ein Datenverlust entstehen oder ein wichtiger Diagnosehinweis verloren gehen.

## Sicherer Diagnoseweg

1. Symptom beschreiben.
2. CPU, RAM, Swap und Load prüfen.
3. Auffällige Prozesse identifizieren.
4. Dienststatus und Logs ergänzend prüfen.
5. Kurzzeitigen Peak von Dauerproblem unterscheiden.
6. Risiko und Nutzerwirkung bewerten.
7. Maßnahme planen.
8. Änderung verifizieren.

## Sichere Maßnahmen

- Bei Dienstproblemen zuerst systemctl status prüfen.
- Bei Diensten möglichst kontrolliert über systemctl restart arbeiten.
- Vor harten Eingriffen Logs sichern.
- Bei unbekannten Prozessen nicht blind handeln.
- Bei Produktionssystemen Eskalationsweg und Change-Regeln beachten.

## Lab-vs-Production-Einordnung

Im Lab reicht die manuelle Analyse mit uptime, free, top und ps.

In Produktion sollten Ressourcenwerte über Monitoring überwacht werden. Sinnvoll sind Metriken für CPU, RAM, Swap, Load Average, Prozessanzahl, I/O-Wartezeit, Dienstzustände und relevante Logmuster.

## Merksätze

- CPU ist die Arbeitskraft.
- RAM ist die Werkbank.
- Swap ist die Notablage.
- Load ist die Warteschlange.
- Ein Peak ist ein Klingeln, Dauerlast ist ein Alarm.
- Erst messen, dann bewerten, dann handeln.
- Nicht jeder hohe Wert ist ein Fehler, aber jeder dauerhaft hohe Wert ist eine Frage.
