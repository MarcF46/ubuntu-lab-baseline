# Lab17e – Runbook: Service-Monitoring-Healthcheck

## Zweck

Dieses Runbook beschreibt die sichere Nutzung und Bewertung des Service-Monitoring-Healthcheck-Skripts aus Lab17d.

Das Skript prüft lokale Dienste, Ports und einfache Serviceabhängigkeiten read-only. Es verändert keine Konfiguration und löscht keine Daten.

## Zugehöriges Skript

scripts/lab17-service-monitoring-healthcheck.sh

## BSI-orientierte Einordnung

Dieses Lab orientiert sich am Gedanken des BSI-IT-Grundschutzes: Systeme sollen nachvollziehbar, sicher, minimal berechtigt, protokollierbar und betreibbar sein.

Es handelt sich nicht um eine BSI-Zertifizierung, sondern um eine fachliche Orientierung an professioneller Betriebssicherheit.

Wichtige Prinzipien:

| Prinzip | Bedeutung im Lab |
|---|---|
| Least Privilege | Checks sollen nur die Rechte bekommen, die wirklich notwendig sind. |
| Nachvollziehbarkeit | Ergebnisse müssen verständlich und dokumentierbar sein. |
| Auditierbarkeit | Sicherheitsrelevante Prüfungen sollen später nachvollziehbar protokolliert werden. |
| kontrollierte Ausführung | Automatisierte Checks sollen nicht zufällig oder unkontrolliert laufen. |
| klare Reaktion | Ein Alarm braucht eine sichere nächste Handlung. |

## Was wird geprüft?

| Bereich | Prüfung |
|---|---|
| SSH | Dienstzustand und Port 22 |
| auditd | Auditdienst aktiv |
| Fail2Ban | Schutz gegen wiederholte fehlgeschlagene Logins |
| rsyslog | Systemlogging aktiv |
| systemd-resolved | lokale Namensauflösung |
| logrotate.timer | Logrotation aktiv |
| DNS-Funktion | Namensauflösung gegen ein Testziel |
| Lab16-Dateisystem-Check | Speicherplatz, Inodes, /var/log und Logrotation |

## Normale Ausführung

Befehl:

    cd ~/projects/ubuntu-lab-baseline || exit 1
    scripts/lab17-service-monitoring-healthcheck.sh

## Erwartete Ausgabe bei OK

Am Ende sollte sinngemäß erscheinen:

    == Gesamtbewertung ==
    Status: OK
    Bedeutung: Keine akute Auffälligkeit erkannt.
    Exit-Code: 0 (OK für Monitoring-Systeme)

## Exit-Code-Bedeutung

| Exit-Code | Status | Bedeutung |
|---:|---|---|
| 0 | OK | keine akute Auffälligkeit erkannt |
| 1 | WARNING | mindestens eine Warnung erkannt |
| 2 | CRITICAL | kritischer Zustand erkannt |

## Bewertung bei WARNING

Wenn das Skript WARNING meldet:

1. Abschnitt mit Warnung identifizieren.
2. Dienststatus mit systemctl status DIENST prüfen.
3. Portstatus bei Port-Themen mit ss -tulpen prüfen.
4. Logs mit journalctl -u DIENST prüfen.
5. Bewertung dokumentieren.
6. Bei wiederkehrender Warnung Ticket oder Monitoring-Regel ableiten.

## Bewertung bei CRITICAL

Wenn das Skript CRITICAL meldet:

1. Nicht blind Dienste neustarten.
2. Betroffenen Dienst oder Check identifizieren.
3. Service-Auswirkung bewerten.
4. Logs prüfen.
5. Falls Remote-Zugriff betroffen ist, lokale Konsole oder alternativen Zugang berücksichtigen.
6. Runbook oder Incident-Karte nutzen.
7. Ergebnis und Maßnahmen dokumentieren.

## Bekannte Grenze im Lab

Der Lab16-Untercheck kann sudo benötigen. Im manuellen Lab ist das zulässig.

Für echtes automatisiertes Monitoring ist eine Passwortabfrage ungeeignet. Ein Monitoring-Check darf nicht hängen bleiben, weil er auf ein Passwort wartet.

Dieser Punkt wird in einer späteren eigenen Lerneinheit behandelt:

Lab18 – BSI-orientierter Monitoring-Agent mit systemd, begrenzten Rechten und Auditierbarkeit

## Warum ein späterer Agent sinnvoll ist

Ein Agent ist ein lokaler Prüfer mit kontrollierten Rechten.

Merksatz:

Nicht die Monitoring-Zentrale bekommt den Generalschlüssel. Jeder Server bekommt einen kleinen, kontrollierten Hausmeister.

Ein Agent kann später:

- Checks regelmäßig ausführen.
- Ergebnisse protokollieren.
- Exit-Codes auswertbar machen.
- mit minimal notwendigen Rechten arbeiten.
- über systemd kontrolliert laufen.
- über journalctl nachvollziehbar sein.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Ausführung | manuell im Terminal | automatisiert über Agent, Timer oder Monitoring-System |
| Rechte | sudo bei Bedarf manuell | minimal, dokumentiert und kontrolliert |
| Logging | Terminalausgabe | zentrale Logs und Auditierbarkeit |
| Alarmierung | manuelle Bewertung | Ticket, Alerting und Eskalation |
| Sicherheitsrahmen | BSI-orientiertes Lernmodell | Sicherheitskonzept, Rollen, Verantwortlichkeiten |

## Bezug zu Lab17

| Baustein | Zweck |
|---|---|
| Lab17a | Zielbild serviceorientiertes Monitoring |
| Lab17b | Service- und Port-Baseline |
| Lab17c | Service-Monitoring-Matrix |
| Lab17d | Service-Monitoring-Healthcheck-Skript |
| Lab17e | dieses Runbook |

## Merksatz

Ein Check ist erst dann betrieblich wertvoll, wenn klar ist, wie er ausgeführt, bewertet, protokolliert und sicher weiterbehandelt wird.
