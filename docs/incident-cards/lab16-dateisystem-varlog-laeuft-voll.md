# Lab16e – Incident-Karte: Dateisystem oder /var/log läuft voll

## Zweck
Diese Incident-Karte beschreibt die Erstreaktion, wenn ein Linux-System meldet, dass Speicherplatz, Inodes oder Logdateien kritisch werden.

Sie ist für Situationen gedacht, in denen die zuständige Fachperson nicht vor Ort ist und eine andere Person sicher angeleitet werden muss.

## Typische Auslöser

| Auslöser | Bedeutung |
|---|---|
| No space left on device | Kein Speicherplatz oder keine Inodes mehr verfügbar. |
| Monitoring meldet Disk kritisch | Dateisystembelegung überschreitet einen Schwellwert. |
| Monitoring meldet Inodes kritisch | Sehr viele Dateien verbrauchen Dateisystem-Verwaltungseinträge. |
| Dienste schreiben keine Logs mehr | /var/log, Rechte oder Logrotate können betroffen sein. |
| System reagiert langsam | Große Logs, viele Dateien oder hohe I/O-Last (Input/Output, Lese-/Schreiblast) möglich. |

## Sofortverbote

- Keine Logs blind löschen.
- Keine Dienste ohne Freigabe neu starten.
- Keine Security- oder Audit-Logs entfernen.
- Keine Retention (Aufbewahrungsdauer) spontan verkürzen.
- Keine privaten Rohdaten öffentlich weitergeben.

## Erste Einschätzung

| Frage | Warum wichtig |
|---|---|
| Welcher Server ist betroffen? | Ohne Systemname keine gezielte Diagnose. |
| Welche Meldung steht exakt im Monitoring? | Wortlaut entscheidet über Speicherplatz, Inodes oder Dienstfehler. |
| Seit wann besteht das Problem? | Zeitfenster hilft bei Log-Sturm oder geänderter Konfiguration. |
| Welche Dienste sind betroffen? | Priorisierung nach Service-Wichtigkeit. |
| Können Benutzer noch arbeiten? | Einordnung der Auswirkung auf den Betrieb. |

## Technische Kurzprüfung

| Schritt | Befehl | Zweck |
|---|---|---|
| 1 | df -h | Speicherplatz prüfen. df bedeutet Disk Free, -h bedeutet human-readable, also menschenlesbare Größen. |
| 2 | df -i | Inodes prüfen. Inodes sind Index Nodes, also Dateisystem-Verwaltungseinträge. |
| 3 | sudo du -xh /var/log \| sort -h \| tail -20 | Größte Logbereiche finden. du bedeutet Disk Usage, also Speicherbelegung. |
| 4 | sudo find /var/log -type f \| wc -l | Anzahl der Logdateien zählen. wc -l zählt Zeilen. |
| 5 | systemctl status logrotate.timer --no-pager | Prüfen, ob Logrotate regelmäßig läuft. |
| 6 | sudo lsof +L1 | Gelöschte, aber noch offene Dateien finden. lsof bedeutet List Open Files. |

## Bewertung

| Befund | Bewertung |
|---|---|
| / über 90 Prozent belegt | kritisch prüfen. |
| / über 95 Prozent belegt | Incident, schnelle kontrollierte Maßnahme nötig. |
| Inodes über 90 Prozent belegt | viele kleine Dateien wahrscheinlich. |
| /var/log wächst stark | möglicher Log-Sturm. |
| logrotate.timer inactive oder failed | Rotation läuft möglicherweise nicht. |
| große gelöschte Datei unter /var/log | Dienst hält Datei offen, Neustart nur kontrolliert. |

## Sichere Maßnahmen

- Größte Verzeichnisse ermitteln.
- Betroffenen Dienst identifizieren.
- Logrotate-Status und Timer prüfen.
- Bei Log-Sturm Log-Level und fehlerhaften Dienst prüfen.
- Bei gelöschter offener Datei Prozess identifizieren.
- Dienstneustart nur nach Auswirkungsprüfung.

## Mitarbeiter-Anweisung am Telefon

### Nicht-technische Person

1. Keine Dateien löschen.
2. Keine Programme oder Dienste neu starten.
3. Monitoring-Meldung offen lassen.
4. Fehlermeldung exakt vorlesen oder fotografieren.
5. Servername, Uhrzeit und betroffene Anwendung nennen.
6. Auf weitere Anweisung warten.

### Technischere Person

1. df -h ausführen und die Zeile mit / melden.
2. df -i ausführen und die Zeile mit / melden.
3. systemctl status logrotate.timer --no-pager ausführen.
4. Keine Löschung und kein Neustart ohne Freigabe.

## Eskalation

Sofort eskalieren, wenn:

- Root-Dateisystem / kritisch voll ist.
- Inodes sind fast oder vollständig verbraucht.
- Security- oder Audit-Logs betroffen sind.
- Produktionsdienste keine Logs mehr schreiben.
- Ursache unklar ist und Speicherverbrauch weiter steigt.
- ein Dienstneustart nötig wäre.

## Monitoring-Zuordnung

| Monitoring-Meldung | Passende Karte |
|---|---|
| Disk usage critical | Diese Incident-Karte verwenden. |
| Inodes critical | Diese Incident-Karte verwenden. |
| /var/log growth abnormal | Diese Incident-Karte verwenden. |
| logrotate.timer failed | Diese Incident-Karte plus Logrotate-Runbook verwenden. |
| Service cannot write logs | Diese Incident-Karte plus Service-Runbook verwenden. |

## Statusmeldung A – Chat/Teamlead

Speicher-/Logproblem wird geprüft. Aktuell werden Speicherplatz, Inodes, /var/log, Logrotate-Timer und offene gelöschte Dateien bewertet. Keine Lösch- oder Neustartmaßnahme ohne Freigabe.

## Statusmeldung B – Ticket-Kommentar

Erste Analyse gestartet. Fokus liegt auf Dateisystembelegung, Inode-Nutzung, Logwachstum unter /var/log, Zustand von logrotate.timer und möglichen gelöschten, aber noch offenen Dateien. Kritische Änderungen wie Löschungen oder Dienstneustarts werden erst nach Bewertung durchgeführt.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Reaktion | Geführt und lernorientiert | Kurz, sicher, priorisiert und dokumentiert |
| Kommunikation | Lernnotiz ausreichend | Teamlead, Ticket, Monitoring und ggf. Management informieren |
| Maßnahmen | kontrolliert testbar | Change-, Incident- und Eskalationsprozess beachten |
| Beweise | Terminalausgabe reicht | Logs, Screenshots, Zeitpunkte und Entscheidungen dokumentieren |

## Merksatz
Im Incident zählt nicht der schnellste Befehl, sondern die sicherste nächste Entscheidung.

## Verweis
- Runbook: docs/runbooks/lab16-log-und-dateisystem-healthcheck-runbook.md
- Grundlagen: docs/operations/lab16-dateisystem-grundlagen-serverbetrieb.md
- Healthcheck: docs/operations/lab16-log-und-dateisystem-healthcheck.md
