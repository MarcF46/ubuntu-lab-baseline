# Lab17f – Incident-Karte: Service-Monitoring WARNING oder CRITICAL

## Zweck

Diese Incident-Karte beschreibt die erste Reaktion, wenn der Service-Monitoring-Healthcheck aus Lab17d WARNING oder CRITICAL meldet.

## Auslöser

| Auslöser | Bedeutung |
|---|---|
| Status: WARNING | Mindestens ein Dienst, Port, Timer oder Funktionscheck ist auffällig. |
| Status: CRITICAL | Ein kritischer Dienst oder sicherheits-/betriebsrelevanter Check ist ausgefallen. |
| Exit-Code 1 | Maschinenlesbarer WARNING-Status. |
| Exit-Code 2 | Maschinenlesbarer CRITICAL-Status. |

## Sofort nicht tun

- Nicht blind Dienste neustarten.
- Nicht blind Firewall-Regeln ändern.
- Nicht blind sudo-Rechte erweitern.
- Nicht private Rohdaten ungeprüft öffentlich dokumentieren.
- Nicht mehrere Änderungen gleichzeitig durchführen.

## Erste Prüfung

1. Ausgabe des Healthcheck-Skripts vollständig lesen.
2. Abschnitt mit WARNING oder CRITICAL identifizieren.
3. Betroffenen Dienst, Port oder Timer notieren.
4. Service-Auswirkung bewerten: Administration, Logging, Sicherheit, DNS oder Wartung.
5. Passendes Runbook öffnen: docs/runbooks/lab17-service-monitoring-healthcheck-runbook.md.

## Technische Kurzprüfung

| Prüffrage | Beispielbefehl | Zweck |
|---|---|---|
| Läuft der Dienst? | systemctl status DIENST | Prüft den systemd-Dienstzustand. |
| Gibt es Logs? | journalctl -u DIENST | Zeigt Dienstlogs zur Fehleranalyse. |
| Lauscht der Port? | ss -tulpen | Zeigt lauschende TCP/UDP-Ports mit Prozessen. |
| Funktioniert DNS? | getent hosts ubuntu.com | Testet Namensauflösung. |
| Ist logrotate aktiv? | systemctl status logrotate.timer | Prüft die automatische Logrotation. |
| Ist Speicher kritisch? | scripts/lab16-log-filesystem-healthcheck.sh | Nutzt den Lab16-Dateisystem-Check. |

## Bewertung nach Schweregrad

| Schweregrad | Typische Bedeutung | Reaktion |
|---|---|---|
| INFO | Interessanter Zustand ohne akute Störung. | Dokumentieren und beobachten. |
| WARNING | Auffälligkeit mit möglicher Betriebsrelevanz. | Prüfen, bewerten, ggf. Ticket erstellen. |
| CRITICAL | Kritischer Zustand mit möglicher Service- oder Sicherheitsauswirkung. | Sofort prüfen, eskalieren, Maßnahmen dokumentieren. |

## BSI-orientierte Einordnung

Diese Incident-Karte orientiert sich am BSI-IT-Grundschutz-Gedanken: Störungen sollen nachvollziehbar, kontrolliert, minimal-invasiv und dokumentiert behandelt werden.

Es handelt sich nicht um eine BSI-Zertifizierung, sondern um eine fachliche Orientierung an sicherem und nachvollziehbarem Betrieb.

Wichtige Prinzipien:

- Least Privilege: keine unnötige Rechteausweitung.
- Nachvollziehbarkeit: Befunde und Maßnahmen dokumentieren.
- Auditierbarkeit: sicherheitsrelevante Ereignisse später nachvollziehbar halten.
- kontrollierte Änderung: erst prüfen, dann ändern.
- Datenminimierung: private Systemdetails nicht unnötig veröffentlichen.

## Eskalation

Eskalieren, wenn:

- SSH oder Management-Zugang nicht erreichbar ist.
- auditd oder Logging ausgefallen ist.
- mehrere kritische Dienste gleichzeitig betroffen sind.
- Speicherplatz oder Inodes kritisch sind.
- die Ursache nicht innerhalb kurzer Zeit eindeutig eingegrenzt werden kann.

## Kommunikation

Kurze Statusmeldung bei WARNING:

Status: WARNING im Service-Monitoring erkannt. Der betroffene Check wird geprüft. Aktuell erfolgt keine unkontrollierte Änderung am System.

Kurze Statusmeldung bei CRITICAL:

Status: CRITICAL im Service-Monitoring erkannt. Mögliche Service- oder Sicherheitsauswirkung wird geprüft. Eskalation und Dokumentation laufen.

## Bezug zu Lab17

| Baustein | Zweck |
|---|---|
| Lab17c | Service-Monitoring-Matrix. |
| Lab17d | Healthcheck-Skript. |
| Lab17e | Runbook zum Healthcheck-Skript. |
| Lab17f | Incident-Karte für WARNING und CRITICAL. |

## Merksatz

Ein Alarm ist kein Arbeitsauftrag zum wilden Reparieren. Ein Alarm ist der Startpunkt für kontrollierte Prüfung, Bewertung und dokumentierte Reaktion.
