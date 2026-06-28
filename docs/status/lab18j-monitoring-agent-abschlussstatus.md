# Lab18j – Abschlussstatus Monitoring-Agent, Timer, Incident-Kette und Quality Gates

## Zusammenfassung

Lab18 behandelt den Aufbau eines lokalen Monitoring-Agenten mit systemd-User-Service, systemd-User-Timer, Rechtebetrachtung, Runbook, Incident-Karte, betriebsnaher Fehlerkette und Quality-Gate-Konzept.

Der Schwerpunkt liegt nicht nur auf technischer Funktion, sondern auf produktionsnahem Betrieb: Fehler erkennen, Ursache eingrenzen, Recovery durchführen und den Normalzustand nachweisen.

## Umgesetzte Bausteine

| Baustein | Status | Ergebnis |
|---|---:|---|
| Rechte-Vorprüfung | abgeschlossen | Agent muss ohne pauschales sudo geplant werden |
| Zielbild und Rechtemodell | abgeschlossen | Agent als begrenzter lokaler Messfühler definiert |
| systemd-User-Service | abgeschlossen | Agent läuft als Type=oneshot |
| Agent-Skript ohne erhöhte Rechte | abgeschlossen | Service-Checks, Port-Check, DNS-Check und Dateisystem-Basischecks funktionieren |
| systemd-User-Timer | abgeschlossen | Timer kann den Agenten regelmäßig auslösen |
| Runbook | abgeschlossen | Bedienung, Logs und Fehlerdiagnose dokumentiert |
| Incident-Karte | abgeschlossen | Erstreaktion bei Agent-/Timer-Störungen dokumentiert |
| Betriebsnahe Incident-Kette | abgeschlossen | typische Fehler A–D geprüft und bewertet |
| Quality-Gate-Konzept | vorbereitet | Schutzstufen für Betrieb und Commit definiert |
| Offline-Notfallkarte | vorbereitet | schnelle Diagnose ohne KI oder Internet möglich |

## Wichtige technische Ergebnisse

Der Agent prüft ohne erhöhte Rechte:

- kritische und wichtige Services,
- ssh.service,
- auditd.service,
- fail2ban.service,
- rsyslog.service,
- systemd-resolved.service,
- logrotate.timer,
- TCP-Port 22,
- DNS-Auflösung,
- Root-Dateisystem-Belegung,
- Root-Inode-Belegung.

Ein erfolgreicher Lauf endet mit:

- Status: OK
- Exit-Code: 0

## Wichtige systemd-Erkenntnisse

Type=oneshot bedeutet:

- Der Service startet.
- Das Skript läuft einmal.
- Danach beendet sich der Service.
- inactive (dead) ist nach erfolgreichem Lauf normal.

Der Timer ist getrennt vom Service zu betrachten:

- Service = Aufgabe.
- Timer = Auslöser.
- Journal = Nachweis.

## Betriebsnahe Fehlerbilder

### Incident A – Timer läuft nicht

Erkenntnis:

- Kein Timer bedeutet keine automatischen neuen Agent-Läufe.
- Trigger: n/a ist ein wichtiger Diagnosehinweis.

Recovery:

- Timer starten.
- nächsten Trigger prüfen.
- Agent-Lauf im Journal nachweisen.

### Incident B – Skript nicht ausführbar

Erkenntnis:

- Fehlendes Execute-Bit erzeugt Permission denied und status=203/EXEC.

Recovery:

- chmod +x
- Service erneut starten.
- Journal prüfen.

### Incident C – falscher ExecStart-Pfad

Erkenntnis:

- Ein falscher Pfad in der aktiven Unit erzeugt No such file or directory und status=203/EXEC.

Recovery:

- aktive Unit aus Repository-Sollzustand wiederherstellen.
- daemon-reload
- Service erneut starten.
- Journal prüfen.

### Incident D – Bash-Syntaxfehler

Erkenntnis:

- bash -n kann Fehler erkennen, die ein grüner Service-Lauf nicht zwingend sichtbar macht.
- Ein grüner Service-Start ersetzt keine statische Prüfung.

Recovery:

- Skript per Git zurücksetzen oder korrigieren.
- bash -n erneut ausführen.
- Service erneut starten.
- Journal prüfen.

## BSI-orientierte Bewertung

Lab18 stärkt mehrere grundlegende Betriebsprinzipien:

- Nachvollziehbarkeit von Änderungen.
- Trennung von Rohdaten und Bewertung.
- Minimale Rechte für technische Agenten.
- Dokumentierte Diagnosepfade.
- Nachweisbare Recovery.
- Kontrollierte Fehlerbehandlung.
- Vorbereitung auf Offline-Betrieb ohne externe Hilfsmittel.

## Lab-vs-Production

Im Lab läuft der Agent als systemd-User-Service. Das ist für Lernzwecke gut geeignet, weil Rechte, systemd-Verhalten, Journal-Auswertung und Timer-Mechanik sichtbar werden.

In produktionsnahen Umgebungen wären zusätzlich zu prüfen:

- Betrieb als dedizierter Service-User,
- zentrale Logsammlung,
- Alerting über Monitoring-System,
- CI/CD-Quality-Gates,
- Staging vor Produktion,
- definierte Eskalationsketten,
- Backup- und Restore-Konzept,
- Härtung nach etablierten Sicherheitsstandards,
- Dokumentations- und Freigabeprozess.

## Portfolio-Wert

Lab18 zeigt folgende Kompetenzen:

- systemd-Service- und Timer-Verständnis,
- Linux-Rechtemodell im Agent-Kontext,
- Monitoring-Grundlagen,
- Exit-Code-Logik,
- Journal-Auswertung,
- Incident-Diagnose,
- Recovery-Nachweis,
- Git-basierte Rückkehr zu bekannt gutem Zustand,
- betriebsnahe Dokumentation,
- Quality-Gate-Denken,
- Offline-taugliche Runbook-Logik.

## Offene nächste Schritte

Empfohlene nächste Erweiterungen:

1. Quality-Gate-Skript final erstellen und testen.
2. Offline-Notfallkarte als Repository-Datei ablegen.
3. Abschlussstatus committen.
4. Optional: Agent um maschinenlesbare Ausgabe erweitern.
5. Optional: Agent-Ergebnisse an ein zentrales Monitoring-System anbinden.
6. Optional: Produktionsmodell mit dediziertem Service-User entwerfen.

## Abschlussbewertung

Lab18 ist ein deutlicher Schritt von einem einfachen Skript zu einem betriebsnahen Monitoring-Baustein. Der Agent wurde nicht nur erstellt, sondern mit Rechtemodell, Timer, Runbook, Incident-Karte, Fehlerkette, Recovery-Nachweis und Quality-Gate-Konzept in einen professionelleren Betriebskontext eingeordnet.

## Merksätze

- Ein Agent ist kein Admin-Ersatz, sondern ein kontrollierter Messfühler.
- Der Service ist die Aufgabe, der Timer ist der Wecker, das Journal ist der Nachweis.
- Produktionsreifer Betrieb beginnt dort, wo typische Fehler erwartet und beherrscht werden.
- Ein System ist erst dann gut betreibbar, wenn auch Störungen dokumentiert und wiederholbar lösbar sind.
