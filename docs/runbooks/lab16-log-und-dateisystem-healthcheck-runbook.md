# Lab16d – Runbook: Log- und Dateisystem-Healthcheck

## Zweck
Dieses Runbook beschreibt eine wiederholbare Prüfung für Log- und Dateisystem-Probleme auf einem Linux-System.

Es dient als Grundlage für manuelle Administration, Monitoring, Incident-Karten, Mitarbeiter-Anweisungen und spätere Automatisierung mit Ansible (Automatisierungswerkzeug für Konfiguration und Serververwaltung).

## Typische Symptome

| Symptom | Mögliche Ursache |
|---|---|
| No space left on device | Speicherplatz voll oder Inodes verbraucht |
| Dienste schreiben keine Logs mehr | /var/log voll, Rechteproblem oder Logrotate-Problem |
| System wirkt langsam | sehr große Logs, viele kleine Dateien oder hohe I/O-Last |
| Logdatei wurde gelöscht, Speicher bleibt aber belegt | Prozess hält gelöschte Datei noch offen |
| Monitoring meldet Disk-Warnung | Dateisystem, Inodes oder Logwachstum kritisch |

## Voraussetzungen

- Zugriff per Terminal oder SSH (Secure Shell, verschlüsselter Fernzugriff).
- sudo-Rechte (Superuser Do, Ausführen mit erhöhten Rechten) für bestimmte Prüfungen.
- Keine blinden Löschaktionen ohne vorherige Analyse.
- In Produktion: Auswirkungen auf Dienste, Benutzer und Geschäftsprozesse beachten.

## Prüfablauf

### 1. Speicherplatz prüfen

Befehl:

df -h

Bedeutung: df (Disk Free, Dateisystembelegung anzeigen) mit -h (human-readable, menschenlesbare Größen wie MB oder GB).

Bewertung:

- Unter 80 Prozent: meistens unkritisch.
- Ab 80 Prozent: beobachten.
- Ab 90 Prozent: prüfen und bereinigen.
- Ab 95 Prozent: kritisch, Incident möglich.

### 2. Inodes prüfen

Befehl:

df -i

Bedeutung: zeigt Inodes (Index Nodes, Dateisystem-Verwaltungseinträge). Jede Datei benötigt mindestens einen Inode.

Bewertung:

- Niedrige Nutzung: unkritisch.
- Hohe Nutzung trotz freiem Speicherplatz: Hinweis auf sehr viele kleine Dateien.
- 100 Prozent Inode-Nutzung: neue Dateien können nicht mehr angelegt werden.

### 3. Größe von /var/log prüfen

Befehl:

sudo du -xh /var/log | sort -h | tail -20

Bedeutung: du (Disk Usage, Speicherbelegung anzeigen), -x (auf einem Dateisystem bleiben), -h (menschenlesbar), sort -h (nach Größen sortieren), tail -20 (letzte 20 Einträge anzeigen).

Bewertung:

- Kleine Loggröße: unkritisch.
- Einzelne große Logs: Ursache prüfen.
- Viele wachsende Logs: Log-Sturm oder falsches Logging möglich.

### 4. Anzahl der Logdateien prüfen

Befehl:

sudo find /var/log -type f | wc -l

Bedeutung: find sucht Dateien, -type f bedeutet normale Dateien, wc -l zählt Zeilen und damit hier die Anzahl der Dateien.

Bewertung:

- Wenige Dateien: unkritisch.
- Sehr viele Dateien: mögliche Belastung für Backup, Monitoring, Suche und Security-Scanner.

### 5. Logrotate-Timer prüfen

Befehl:

systemctl status logrotate.timer --no-pager

Bedeutung: systemctl prüft systemd-Dienste und Timer. --no-pager verhindert die Anzeige in einem Scrollprogramm.

Bewertung:

- active/waiting: Timer ist aktiv und wartet auf die nächste Ausführung.
- inactive/failed: Logrotate-Ausführung prüfen.

### 6. Gelöschte, aber offene Dateien prüfen

Befehl:

sudo lsof +L1

Bedeutung: lsof (List Open Files, offene Dateien anzeigen), +L1 zeigt Dateien mit weniger als einem Link, häufig gelöschte, aber noch offene Dateien.

Bewertung:

- Kleine memfd-Einträge (memory file descriptor, speicherbasierte temporäre Dateiobjekte) sind auf Desktop-Systemen häufig.
- Große gelöschte Dateien unter /var/log sind kritisch zu prüfen.
- Neustart eines Dienstes kann Speicher freigeben, darf in Produktion aber nicht blind erfolgen.

## Sichere Erstmaßnahmen

| Situation | Sichere Maßnahme |
|---|---|
| Speicherplatz fast voll | Größte Verzeichnisse ermitteln, nicht blind löschen. |
| Inodes fast voll | Anzahl kleiner Dateien prüfen, betroffene Verzeichnisse identifizieren. |
| Einzelne Logdatei sehr groß | Dienst, Log-Level und Logrotate-Regel prüfen. |
| Gelöschte Logdatei bleibt offen | Prozess identifizieren, Neustart nur kontrolliert durchführen. |
| logrotate.timer fehlgeschlagen | Timer, Service, Konfiguration und letzte Fehler prüfen. |

## Was nicht blind getan werden darf

- Keine Logs ohne Bewertung löschen.
- Keine Dienste ohne Auswirkungsprüfung neustarten.
- Keine Retention (Aufbewahrungsdauer) ohne fachliche Vorgabe verkürzen.
- Keine privaten Rohdaten öffentlich dokumentieren.
- Keine Security- oder Audit-Logs entfernen, wenn ein Incident vermutet wird.

## Eskalation

Eskalieren, wenn einer dieser Punkte zutrifft:

- Root-Dateisystem / ist kritisch voll.
- Inodes sind fast oder vollständig verbraucht.
- Wichtige Dienste können keine Logs mehr schreiben.
- Security- oder Audit-Logs sind betroffen.
- Ursache ist unklar und Speicherverbrauch steigt weiter.
- Neustart eines produktiven Dienstes wäre nötig.

## Mitarbeiter-Anweisung bei telefonischem Incident

Kurzform für eine nicht-technische Person vor Ort:

1. Keine Dateien löschen.
2. Keine Dienste neu starten.
3. Monitoring-Ansicht offen lassen oder Screenshot erstellen.
4. Fehlermeldung exakt vorlesen oder fotografieren.
5. Prüfen, welcher Server oder Dienst betroffen ist.
6. Rückmeldung geben: Uhrzeit, Systemname, Fehlermeldung, sichtbarer Status.

Kurzform für eine technischere Person vor Ort:

1. df -h ausführen und Ergebnis melden.
2. df -i ausführen und Ergebnis melden.
3. systemctl status logrotate.timer --no-pager ausführen.
4. Keine Löschung oder Neustarts ohne Freigabe.

## Monitoring-Idee

| Monitoring-Prüfung | Zweck | Beispielschwelle |
|---|---|---|
| Speicherplatzbelegung | Volllaufen verhindern | Warnung ab 80 Prozent, kritisch ab 90 Prozent |
| Inode-Belegung | Probleme durch viele kleine Dateien erkennen | Warnung ab 80 Prozent, kritisch ab 90 Prozent |
| /var/log Wachstum | Log-Sturm erkennen | ungewöhnlicher Anstieg im Zeitverlauf |
| logrotate.timer Zustand | Ausfall der Rotation erkennen | Alarm bei failed oder inactive |
| große gelöschte offene Dateien | versteckte Speicherbelegung erkennen | Alarm bei großen Dateien unter /var/log |

## Automatisierungspfad

1. Manuelle Befehle stabilisieren.
2. Healthcheck-Skript unter scripts/ erstellen.
3. Exit-Codes definieren.
4. Monitoring-Ausgabe ergänzen.
5. Ansible-Task zur Installation und Prüfung vorbereiten.
6. Später Terraform (Infrastructure as Code, Infrastruktur als Code) für Infrastruktur-Bereitstellung ergänzen.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Prüfung | Manuell ausführbar | Automatisiert, überwacht und dokumentiert |
| Maßnahmen | Lernorientiert | Change-, Incident- und Eskalationsprozess beachten |
| Logs | Lokal analysiert | Zentrale Logplattform und SIEM (Security Information and Event Management, zentrale Sicherheitslog- und Alarmplattform) beachten |
| Neustarts | Im Lab meist unkritisch | Nur mit Auswirkungsprüfung und Freigabe |
| Dokumentation | Lernnachweis | Betriebs-, Audit- und Übergabedokumentation |

## Abschlusskriterium

Der Healthcheck ist abgeschlossen, wenn Speicherplatz, Inodes, /var/log, Logrotate-Timer und offene gelöschte Dateien geprüft und bewertet wurden.

## Merksatz
Ein voller Datenträger ist ein Symptom. Ein gutes Runbook zeigt, welche Schicht betroffen ist und welche Maßnahme sicher ist.
