# Runbook – Ressourcen- und Prozessdiagnose

## Zweck

Dieses Runbook beschreibt eine strukturierte Basisprüfung für CPU, Load Average, RAM, Swap und auffällige Prozesse auf einem Linux-System.

## Typisches Betriebsszenario

Ein Server wirkt langsam, Dienste reagieren verzögert oder ein Team meldet instabiles Verhalten. Vor tieferer Fehlersuche wird geprüft, ob ein Ressourcenengpass vorliegt.

## Begriffe

- CPU (Central Processing Unit): Prozessor bzw. Recheneinheit des Systems.
- RAM (Random Access Memory): Arbeitsspeicher für laufende Programme.
- Swap: Auslagerungsspeicher auf Datenträger, wenn RAM knapp wird.
- Load Average: Durchschnittliche Anzahl von Aufgaben, die laufen oder auf Verarbeitung warten.
- Prozess: Laufendes Programm oder laufender Dienst.
- PID (Process ID): Eindeutige Prozessnummer.
- RSS (Resident Set Size): Tatsächlich im RAM belegter Speicher eines Prozesses.
- VSZ (Virtual Memory Size): Virtuell reservierter Speicher, nicht automatisch echter RAM-Verbrauch.

## Sicherer Diagnoseweg

1. Aktuelle Systemlast prüfen.
2. Anzahl der CPU-Kerne einordnen.
3. RAM und Swap prüfen.
4. Auffällige Prozesse nach CPU und RAM identifizieren.
5. Kurzzeitige Peaks von dauerhafter Überlast unterscheiden.
6. Logs und Dienststatus ergänzend prüfen.
7. Erst nach Bewertung eingreifen.

## Basisbefehle

Load und CPU prüfen:

    uptime
    cat /proc/loadavg
    nproc

RAM und Swap prüfen:

    free -h
    LC_ALL=C free -m

Prozesse nach RAM sortieren:

    ps aux --sort=-%mem | head -n 11

Prozesse nach CPU sortieren:

    ps aux --sort=-%cpu | head -n 11

Live-Ansicht starten:

    top

Einmalige top-Momentaufnahme erzeugen:

    top -bn1 | head -n 20

Einen bestimmten Prozess prüfen:

    ps -p <PID> -o pid,ppid,user,stat,%cpu,%mem,rss,vsz,comm,args

Dienststatus ergänzend prüfen:

    systemctl status <dienstname> --no-pager -l
    journalctl -u <dienstname> --since "1 hour ago" --no-pager

## Bewertung von Load Average

Load Average muss immer im Verhältnis zur CPU-Anzahl bewertet werden.

Beispiel:

- 1 CPU-Kern und Load 1.0: System ist ungefähr voll ausgelastet.
- 12 CPU-Kerne und Load 1.0: meist unkritisch.
- 12 CPU-Kerne und Load 12.0: System ist stark ausgelastet.
- Dauerhaft hoher Load ist wichtiger als ein kurzer Peak.

## Bewertung von RAM

Hohe RAM-Nutzung ist nicht automatisch ein Fehler. Linux nutzt freien RAM auch für Cache. Wichtig ist der verfügbare Speicher.

Wichtige Werte:

- total: gesamter Arbeitsspeicher.
- used: aktuell genutzt.
- available: voraussichtlich verfügbarer Speicher für neue Anwendungen.
- swap used: genutzter Auslagerungsspeicher.

## Bewertung von Swap

Swap-Nutzung ist ein Warnsignal, aber nicht automatisch ein Incident.

Kritischer wird es, wenn:

- Swap dauerhaft wächst.
- das System spürbar langsam wird.
- Prozesse hängen.
- Logs Speicher- oder I/O-Probleme zeigen.

## Bewertung von Prozessen

Auffällige Prozesse müssen fachlich eingeordnet werden.

Beispiele:

- Browser-Prozesse können im Desktop-Lab viel RAM nutzen.
- Datenbanken können in Serverumgebungen absichtlich viel RAM nutzen.
- Ein unbekannter Prozess mit dauerhaft hoher CPU-Last ist genauer zu prüfen.
- Ein Dienst in Fehlerloop kann CPU, Logs und Storage gleichzeitig belasten.

## Typische Fehlerbilder

### Hohe CPU-Last

Mögliche Ursachen:

- Prozess hängt in Berechnung.
- Dienst läuft in Fehlerloop.
- Backup, Update, Scan oder Build läuft.
- Desktop- oder Browserprozess erzeugt Last.
- In Produktion: potenziell auch kompromittierter Prozess.

Erste Prüfung:

    uptime
    ps aux --sort=-%cpu | head -n 11
    systemctl --failed --no-pager

### Hohe RAM-Nutzung

Mögliche Ursachen:

- viele Browser-Tabs oder große Anwendungen.
- Speicherleck.
- Datenbank oder Cache nutzt viel RAM.
- Container oder virtuelle Maschine nutzt mehr Speicher als erwartet.

Erste Prüfung:

    free -h
    ps aux --sort=-%mem | head -n 11

### Swap wird genutzt

Mögliche Ursachen:

- RAM war zeitweise knapp.
- große Anwendung oder Prozesspeak.
- System ist lange aktiv.
- Workload passt nicht zur RAM-Größe.

Erste Prüfung:

    free -h
    swapon --show
    ps aux --sort=-%mem | head -n 11

### Hoher Load bei niedriger CPU-Nutzung

Mögliche Ursachen:

- I/O-Wartezeit durch langsame Datenträger.
- blockierte Prozesse.
- Storage-Problem.
- Netzwerkdateisystem oder externer Datenträger langsam.

Erste Prüfung:

    uptime
    top
    df -h
    journalctl -p warning..alert --since "1 hour ago" --no-pager

## Sicheres Verhalten

- Prozesse nicht blind beenden.
- Erst Prozess, Zweck und Auswirkung verstehen.
- Bei produktiven Systemen Nutzerwirkung, Dienstkritikalität und Change-Fenster beachten.
- Bei Incident-Verdacht Logs und Prozesszustand dokumentieren.
- Eingriffe nach Möglichkeit über systemd bzw. Dienststeuerung durchführen, nicht sofort per kill.

## Lab-vs-Production-Einordnung

Im Lab reichen Momentaufnahmen mit uptime, free, top und ps.

In Produktion sollten CPU, RAM, Swap, Load, Prozessanzahl, Dienstzustände und relevante Logs über Monitoring und Alerting überwacht werden.

Professionelle Ergänzungen wären Prometheus Node Exporter, Grafana Dashboards, zentrale Logs, Alert-Regeln und Runbooks für Eskalation.

## Merksätze

- CPU ist die Arbeitskraft.
- RAM ist die Werkbank.
- Swap ist die Notablage.
- Load ist die Warteschlange.
- Ein Peak ist ein Klingeln, Dauerlast ist ein Alarm.
- Erst messen, dann bewerten, dann handeln.
