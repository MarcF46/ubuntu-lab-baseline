# Lab16g – Monitoring- und Automatisierungsübergabe

## Zweck
Diese Übergabe beschreibt, wie der Log- und Dateisystem-Healthcheck aus Lab16 später in Monitoring, Incident-Prozesse und Automatisierung überführt werden kann.

## Ausgangspunkt

| Baustein | Datei | Zweck |
|---|---|---|
| Healthcheck-Skript | scripts/lab16-log-filesystem-healthcheck.sh | Wiederholbare technische Prüfung. |
| Runbook | docs/runbooks/lab16-log-und-dateisystem-healthcheck-runbook.md | Manuelle Betriebsanleitung. |
| Incident-Karte | docs/incident-cards/lab16-dateisystem-varlog-laeuft-voll.md | Kurzreaktion im Störungsfall. |
| Grundlagen | docs/operations/lab16-dateisystem-grundlagen-serverbetrieb.md | Fachliche Einordnung von Dateisystemen. |

## Exit-Codes des Skripts

| Exit-Code | Bedeutung | Betriebliche Bewertung |
|---:|---|---|
| 0 | OK | Keine akute Auffälligkeit. |
| 1 | WARNING | Beobachten, prüfen oder Ticket erstellen. |
| 2 | CRITICAL | Incident oder sofortige Eskalation möglich. |

Exit-Code bedeutet Rückgabewert eines Programms. Monitoring-Systeme können diesen Wert auswerten und daraus Statusmeldungen erzeugen.

## Monitoring-Mapping

| Prüfung | Monitoring-Ziel | Beispielreaktion |
|---|---|---|
| Speicherplatz / | Volllaufen des Root-Dateisystems verhindern | Warnung ab 80 Prozent, kritisch ab 90 Prozent. |
| Inodes / | Probleme durch viele kleine Dateien erkennen | Warnung ab 80 Prozent, kritisch ab 90 Prozent. |
| /var/log Größe | Logwachstum sichtbar machen | Trend beobachten, ungewöhnliches Wachstum melden. |
| Anzahl Logdateien | viele kleine Dateien erkennen | auffällige Zunahme untersuchen. |
| logrotate.timer | Ausfall der Logrotation erkennen | Alarm bei inactive oder failed. |
| gelöschte offene Dateien unter /var/log | versteckte Speicherbelegung erkennen | Warnung bei Treffern. |

## Spätere Monitoring-Integration

Das Skript kann später als Grundlage für verschiedene Monitoring-Ansätze dienen:

- lokaler Cronjob oder systemd-Timer für regelmäßige Prüfungen.
- Monitoring-Plugin mit Exit-Code-Auswertung.
- Prometheus Node Exporter Textfile Collector.
- zentrale Log- oder Alerting-Plattform.
- SIEM (Security Information and Event Management, zentrale Sicherheitslog- und Alarmplattform) bei Security-relevanten Logereignissen.

## Ansible-Pfad

Ansible (Automatisierungswerkzeug für Konfiguration und Serververwaltung) könnte später genutzt werden, um:

- das Skript auf Zielsysteme zu kopieren.
- Dateirechte korrekt zu setzen.
- benötigte Pakete wie lsof zu installieren.
- systemd-Timer oder Cronjob einzurichten.
- Monitoring-Konfiguration auszurollen.
- Runbook- und Incident-Verweise konsistent zu dokumentieren.

## Terraform-Einordnung

Terraform (Infrastructure as Code, Infrastruktur als Code) ist hier nicht für das Skript selbst zuständig. Terraform wäre später relevant, wenn Infrastruktur bereitgestellt wird, zum Beispiel virtuelle Maschinen, Netzwerke, Security Groups oder Monitoring-Ressourcen.

Merksatz: Terraform stellt Infrastruktur bereit. Ansible konfiguriert Systeme. Monitoring bewertet den laufenden Betrieb.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Skriptausführung | manuell im Terminal | automatisiert, überwacht und versioniert. |
| Schwellwerte | einfache Standardwerte | serviceabhängig festlegen und dokumentieren. |
| Alarmierung | Lernbewertung | Bereitschaft, Ticket, Eskalation und Priorität definieren. |
| Beweise | private Terminalausgabe | Auditierbare Nachweise, Zeitpunkte und Entscheidungen. |
| Automatisierung | einzelnes Skript | Rollen, Templates, Tests und kontrollierter Rollout. |

## Ergebnis
Lab16 ist damit nicht nur eine Logrotate-Übung, sondern ein kleiner betrieblicher Ablauf: technische Prüfung, Bewertung, Dokumentation, Incident-Reaktion und späterer Automatisierungspfad.

## Merksatz
Kompetenz entsteht nicht durch einen einzelnen Befehl, sondern durch ein System aus Prüfung, Bewertung, Dokumentation, Reaktion und Automatisierung.
