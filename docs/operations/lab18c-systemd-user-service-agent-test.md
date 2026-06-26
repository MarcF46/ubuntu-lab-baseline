# Lab18c – systemd-User-Service für Monitoring-Agent

## Zweck

Dieses Dokument beschreibt den ersten kontrollierten systemd-User-Service für den lokalen Monitoring-Agenten. Ziel ist die nicht-interaktive, nachvollziehbare und agent-saubere Ausführung eines read-only Healthchecks ohne sudo-Aufrufe.

## Ergebnis

Der Monitoring-Agent wurde als systemd-User-Service vorbereitet, installiert und manuell getestet. Der Testlauf wurde erfolgreich abgeschlossen.

| Prüfpunkt | Ergebnis | Bewertung |
|---|---|---|
| systemd-User-Unit vorhanden | ja | Service ist im Repository dokumentiert |
| aktiver User-Service-Test | erfolgreich | systemctl start lieferte Exit-Code 0 |
| Servicezustand nach Lauf | inactive (dead) | korrekt für Type=oneshot |
| journalctl-Ausgabe | vorhanden | Agent-Ausführung ist nachvollziehbar |
| sudo-Aufrufe im Agent-Skript | keine | agent-sauber für User-Kontext |
| Passwortabfragen | keine neuen im Agent-Testlauf | geeignet für Automatisierung |

## Technische Bausteine

| Baustein | Pfad | Aufgabe |
|---|---|---|
| Agent-Skript | scripts/lab18-monitoring-agent-safe.sh | führt read-only Checks ohne sudo aus |
| systemd-User-Unit | systemd/user/lab18-monitoring-agent.service | startet das Agent-Skript kontrolliert |
| aktive User-Unit | ~/.config/systemd/user/lab18-monitoring-agent.service | lokal installierte Testkopie für systemctl --user |
| Logs | journalctl --user -u lab18-monitoring-agent.service | macht Ausführung und Ergebnis nachvollziehbar |

## systemd-Einordnung

Der Service verwendet Type=oneshot. Ein oneshot-Service führt eine Aufgabe einmalig aus und beendet sich danach. Der Zustand inactive (dead) ist nach erfolgreicher Ausführung deshalb erwartbar und kein Fehler.

Die erfolgreiche Ausführung wurde über systemctl --user start, systemctl --user status und journalctl --user geprüft.

## Agent-Sicherheit

Das Agent-Skript ist bewusst von den sudo-nahen Prüfungen aus Lab16/Lab17 getrennt. Dadurch entstehen keine interaktiven Passwortabfragen und keine wiederholten sudo-Fehler im Journal.

Der Agent prüft nur Zustände, die ohne erhöhte Rechte lesbar sind:

- Dienstzustände über systemctl is-active.
- SSH-Port 22 über ss ohne Prozessdetails.
- DNS-Auflösung über getent hosts.
- Root-Dateisystembelegung über df.
- Root-Inode-Belegung über df -i.

## BSI-orientierte Einordnung

Die Umsetzung orientiert sich am BSI-IT-Grundschutz-Gedanken, ohne eine Zertifizierung zu behaupten. Der Schwerpunkt liegt auf minimalen Rechten, kontrollierter Ausführung, Nachvollziehbarkeit und Datenminimierung.

Wichtige Prinzipien:

- Least Privilege: Der Agent läuft ohne Root-Rechte.
- Kontrollierte Ausführung: Der Agent wird über systemd gestartet.
- Nachvollziehbarkeit: Ergebnisse erscheinen im User-Journal.
- Nicht-Interaktivität: Es gibt keine Passwortabfrage.
- Trennung: manuelle tiefe Prüfungen bleiben von automatisierten Agent-Checks getrennt.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Unit-Typ | systemd-User-Service | meist System-Service oder professioneller Monitoring-Agent |
| Benutzerkontext | normaler Benutzer marc | dediziertes Servicekonto |
| Rechte | keine sudo-Aufrufe | minimal definierte Rechte, falls nötig |
| Logs | lokales User-Journal | zentrale Logs, SIEM oder Monitoring-Plattform |
| Ausführung | manuell getestet | Timer, Scheduler oder zentrale Orchestrierung |

## Bekannter Nebenbefund

Bei der systemd-Analyse erscheint eine Warnung aus einer vorhandenen spice-vdagent-User-Unit. Diese Warnung stammt nicht aus der Lab18-Unit und wurde für Lab18c als Fremdbefund eingeordnet.

## Nächster Schritt

Der nächste Schritt ist ein systemd-User-Timer, der den Agent-Service regelmäßig ausführt. Dadurch wird aus dem manuell startbaren Agenten ein wiederkehrender lokaler Monitoring-Baustein.

## Merksatz

Ein guter Agent ist nicht mächtig. Ein guter Agent ist zuverlässig, begrenzt, nachvollziehbar und automatisierbar.
