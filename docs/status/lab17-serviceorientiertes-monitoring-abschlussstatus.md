# Lab17 – Abschlussstatus: Serviceorientiertes Monitoring

## Kurzstatus

Lab17 wurde als Einstieg in serviceorientiertes Monitoring aufgebaut. Der Fokus lag auf dem Übergang von technischen Einzelchecks zu bewertbaren Servicezuständen mit Runbook, Incident-Karte und kontrollierter Reaktion.

## Entstandene Artefakte

| Lab | Artefakt | Zweck |
|---|---|---|
| Lab17a | docs/work-orders/lab17-serviceorientiertes-monitoring-arbeitsauftrag.md | Zielbild und Arbeitsauftrag. |
| Lab17b | docs/operations/lab17b-service-port-baseline-bewertung.md | Öffentliche Bewertung der Service- und Port-Baseline. |
| Lab17c | docs/operations/lab17c-service-monitoring-matrix.md | Zuordnung von Dienst, Auswirkung, Alarmstufe und Reaktion. |
| Lab17d | scripts/lab17-service-monitoring-healthcheck.sh | Read-only Healthcheck-Skript mit OK, WARNING und CRITICAL. |
| Lab17e | docs/runbooks/lab17-service-monitoring-healthcheck-runbook.md | Runbook zur sicheren Nutzung und Bewertung des Skripts. |
| Lab17f | docs/incident-cards/lab17-service-monitoring-warning-critical.md | Incident-Karte für WARNING und CRITICAL. |
| Lab17g | docs/operations/lab17g-service-monitoring-tabletop-test.md | Tabletop-Test für kontrollierte Reaktion ohne echte Störung. |

## Fachlicher Fortschritt

Lab17 zeigt den Unterschied zwischen technischem Monitoring und serviceorientiertem Monitoring.

| Sicht | Typische Frage |
|---|---|
| Host-Sicht | Ist das System erreichbar? |
| Dienst-Sicht | Läuft der relevante Dienst? |
| Port-Sicht | Lauscht der erwartete Port? |
| Funktions-Sicht | Funktioniert die erwartete Servicefunktion? |
| Betriebs-Sicht | Gibt es Runbook, Incident-Karte und Eskalation? |

## BSI-orientierte Einordnung

Lab17 orientiert sich am Gedanken des BSI-IT-Grundschutzes. Es wird keine Zertifizierung behauptet. Die Orientierung liegt auf sicherem, nachvollziehbarem und betreibbarem Systembetrieb.

Wichtige Prinzipien in Lab17:

- Erst prüfen, dann ändern.
- Keine blinden Neustarts bei Alarmen.
- Keine unnötige Rechteausweitung.
- Private Rohdaten bleiben privat.
- Alarme brauchen Bedeutung, Reaktion und Dokumentation.
- Agenten und sudo-Rechte werden später gesondert betrachtet.

## Aktueller Stand

Das Service-Monitoring-Healthcheck-Skript wurde erstellt, getestet und committed. Runbook, Incident-Karte und Tabletop-Test sind vorhanden.

Der bekannte offene Punkt ist die sudo-Passwortabfrage im Lab16-Untercheck. Dieser Punkt wird bewusst nicht schnell umgangen, sondern später in einem eigenen Agent- und Rechtemodell-Lab behandelt.

## Nächster sinnvoller Lernblock

Der nächste größere Lernblock ist Lab18: BSI-orientierter Monitoring-Agent mit systemd, begrenzten Rechten, Logging und Auditierbarkeit.

## Merksatz

Serviceorientiertes Monitoring endet nicht beim Alarm. Es endet erst bei kontrollierter Prüfung, dokumentierter Bewertung und sicherer Reaktion.
