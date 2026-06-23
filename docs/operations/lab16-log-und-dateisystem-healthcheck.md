# Lab16b – Log- und Dateisystem-Healthcheck

## Zweck
Dieser Healthcheck prüft, ob das System aus Betriebssicht weiterhin sauber Logs schreiben, speichern, rotieren und analysierbar halten kann.

## Private Nachweisbasis
- Rohdaten-Datei: docs/private/evidence/lab16-logrotate/lab16-log-and-filesystem-healthcheck-raw.txt
- Öffentliche Bewertungsdatei: docs/operations/lab16-log-und-dateisystem-healthcheck.md

## Ergebnisübersicht

| Prüfpunkt | Ergebnis | Bewertung |
|---|---|---|
| Root-Dateisystem / | Größe: 150G, benutzt: 15G, frei: 129G, Belegung: 10% | unkritisch |
| Inodes (Index Nodes, Dateisystem-Verwaltungseinträge) auf / | Belegung: 3% | unkritisch |
| /var/log | Größe: 87M (87 Megabyte im Lab) | unkritisch |
| Dateien unter /var/log | Anzahl: 81 | unkritisch |
| logrotate.timer | Active: active (waiting) since Tue 2026-06-23 10:59:17 CEST; 1h 47min ago | aktiv und eingeplant |
| Gelöschte offene Dateien unter /var/log | 0 Treffer | kein akuter Logdatei-Hinweis |
| memfd (memory file descriptor, speicherbasiertes temporäres Dateiobjekt) | 397 Treffer | auf Desktop-Systemen häufig, separat bewerten |

## Bewertung
Der aktuelle Systemzustand ist aus Log- und Dateisystemsicht unkritisch. Das Root-Dateisystem hat ausreichend freien Speicherplatz, die Inode-Nutzung ist niedrig, /var/log ist klein und der Logrotate-Timer ist aktiv.

Die Ausgabe von lsof +L1 enthält mehrere gelöschte, aber noch offene Speicherobjekte. Viele davon sind memfd (memory file descriptor, speicherbasierte temporäre Dateiobjekte) oder /dev/shm (shared memory, gemeinsam genutzter Arbeitsspeicher). Das ist auf einem Desktop-System nicht automatisch ein Fehler.

Ein kritischer Befund wäre eher eine große gelöschte Datei unter /var/log, die weiterhin von einem Dienst offengehalten wird.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Speicherplatz | Manuelle Prüfung mit df -h | Monitoring mit Schwellwerten und Alarmierung |
| Inodes | Manuelle Prüfung mit df -i | Inode-Monitoring besonders bei vielen kleinen Dateien |
| Logwachstum | /var/log manuell bewerten | Trendanalyse und Alerting auf ungewöhnliches Wachstum |
| Gelöschte offene Dateien | Manuell mit lsof +L1 prüfen | In Incidents gezielt prüfen, bevor Dienste neugestartet werden |
| Logrotate | Timerstatus prüfen | Timer, Exit-Codes, Retention und zentrale Logs überwachen |

## Runbook-Gedanke
Dieser Healthcheck ist die Grundlage für ein späteres Runbook, ein automatisiertes Prüfskript, Monitoring-Regeln, Incident-Karten und spätere Automatisierung mit Ansible (Automatisierungswerkzeug für Konfiguration und Serververwaltung).

## Merksatz
Ein einzelner Befehl zeigt einen Zustand. Ein Healthcheck bewertet mehrere Schichten. Ein Runbook macht die Bewertung wiederholbar. Monitoring macht sie rechtzeitig sichtbar.
