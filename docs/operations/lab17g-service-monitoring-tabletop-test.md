# Lab17g – Tabletop-Test: Service-Monitoring WARNING/CRITICAL

## Zweck

Dieser Tabletop-Test beschreibt eine kontrollierte Übung für den Fall, dass der Service-Monitoring-Healthcheck WARNING oder CRITICAL meldet.

Es werden keine echten Dienste gestoppt und keine produktionsähnlichen Änderungen durchgeführt.

## BSI-orientierte Einordnung

Die Übung orientiert sich am BSI-IT-Grundschutz-Gedanken: Störungen sollen kontrolliert, nachvollziehbar, dokumentiert und mit minimalem Risiko behandelt werden.

Es handelt sich nicht um eine BSI-Zertifizierung, sondern um eine fachliche Orientierung an sicherem Betrieb.

## Übungsszenario 1 – WARNING

| Punkt | Beschreibung |
|---|---|
| Auslöser | Der Healthcheck meldet WARNING. |
| Beispiel | logrotate.timer ist nicht aktiv oder ein nicht kritischer Dienst ist auffällig. |
| Ziel | Ursache eingrenzen, ohne blind Dienste neu zu starten. |
| Erste Reaktion | Runbook öffnen, betroffenen Abschnitt identifizieren, Logs prüfen. |
| Dokumentation | Befund und Bewertung notieren. |

## Übungsszenario 2 – CRITICAL

| Punkt | Beschreibung |
|---|---|
| Auslöser | Der Healthcheck meldet CRITICAL. |
| Beispiel | ssh.service ist nicht aktiv oder ein sicherheitsrelevanter Dienst ist ausgefallen. |
| Ziel | Service-Auswirkung und Eskalationsbedarf bewerten. |
| Erste Reaktion | Nicht blind reparieren, sondern Dienststatus, Logs und Zugriffslage prüfen. |
| Dokumentation | Zeitpunkt, Befund, Bewertung und nächste Maßnahme festhalten. |

## Verbotene Abkürzungen im Test

- Keine echten Dienste stoppen, nur um einen Alarm zu erzeugen.
- Keine Firewall-Regeln ändern, ohne Rollbackplan.
- Keine sudo-Rechte erweitern, nur damit ein Check bequemer läuft.
- Keine privaten Rohdaten in öffentliche Dokumente übernehmen.

## Zu nutzende Dokumente

| Dokument | Zweck |
|---|---|
| docs/runbooks/lab17-service-monitoring-healthcheck-runbook.md | Schrittweise Prüfung und Bewertung. |
| docs/incident-cards/lab17-service-monitoring-warning-critical.md | Kurzreaktion bei WARNING oder CRITICAL. |
| docs/operations/lab17c-service-monitoring-matrix.md | Zuordnung von Dienst, Auswirkung und Reaktion. |
| scripts/lab17-service-monitoring-healthcheck.sh | Technischer Healthcheck. |

## Ergebnis des Tabletop-Tests

Der Tabletop-Test zeigt, dass WARNING und CRITICAL nicht als Aufforderung zum wilden Reparieren verstanden werden dürfen.

Ein Alarm ist der Startpunkt für kontrollierte Prüfung, Bewertung, Dokumentation und bei Bedarf Eskalation.

## Nächster Schritt

Der nächste sinnvolle Baustein ist eine Lab17-Abschlussübersicht oder später ein eigenes Lab18 zum BSI-orientierten Monitoring-Agenten mit systemd, begrenzten Rechten und Auditierbarkeit.

## Merksatz

Störungen übt man nicht durch Chaos, sondern durch kontrollierte Szenarien mit klarer Reaktion.
