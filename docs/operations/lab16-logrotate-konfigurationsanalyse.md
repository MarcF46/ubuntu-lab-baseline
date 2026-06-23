# Lab16 – Logrotate-Konfigurationsanalyse

## Zweck
Diese Analyse bewertet die vorhandene Logrotate-Konfiguration im Lab. Die privaten Rohdaten bleiben bewusst außerhalb der öffentlichen Dokumentation.

## Nachweisbasis
- Private Rohdaten: docs/private/evidence/lab16-logrotate/lab16-logrotate-config-analysis-raw.txt
- Öffentlicher Report: docs/operations/lab16-logrotate-konfigurationsanalyse.md
- Erstellt am: 2026-06-23T12:33:20+02:00

## Erkannte Konfigurationsindikatoren

| Prüfpunkt | Ergebnis |
|---|---|
| Hauptkonfiguration | erkannt |
| Drop-in-Verzeichnis | erkannt |
| Erkannte Drop-in-Hinweise | 20 |
| Rotationsrhythmus | weekly |
| Aufbewahrungsregel | rotate 4 |
| Kompression | Hinweis erkannt |
| Systemd-Timer | nicht eindeutig erkannt |
| Logrotate-Statusdatei | erkannt |

## Betriebliche Bewertung
Logrotate ist ein Basismechanismus für kontrollierte Log-Aufbewahrung. Die Rotation verhindert, dass Logdateien unbegrenzt wachsen und dadurch Speicherplatz, Dienste oder Monitoring beeinträchtigen.

Die Trennung zwischen privaten Rohdaten und öffentlicher Bewertung ist bewusst gewählt. Rohdaten können Pfade, Dienstnamen, Zeitmuster oder sicherheitsrelevante Details enthalten. Die öffentliche Dokumentation beschreibt deshalb nur die fachliche Bewertung.

## Lab-vs-Production-Einordnung

| Bereich | Lab-Bewertung | Production-Bewertung |
|---|---|---|
| Speicherplatzschutz | Rotation reicht als Grundschutz | Zusätzlich Monitoring auf Disk Usage, Inodes und Logwachstum nötig |
| Nachvollziehbarkeit | Lokale Prüfung ausreichend | Aufbewahrung muss zu Audit-, Security- und Compliance-Anforderungen passen |
| Kompression | Sinnvoll zur Platzersparnis | Mit SIEM, Suche und Incident Response abstimmen |
| Löschfristen | Technisch bewertet | Fachlich, rechtlich und sicherheitlich festlegen |
| Fehlererkennung | Manuelle Prüfung möglich | Alerts bei fehlgeschlagener Rotation oder volllaufenden Logs erforderlich |

## Risikoanalyse
- Zu kurze Aufbewahrung kann Fehlersuche und Incident-Analyse erschweren.
- Zu lange Aufbewahrung kann Speicherplatzprobleme und Datenschutzrisiken erzeugen.
- Fehlende Rotation kann zu volllaufenden Dateisystemen führen.
- Ungeprüfte Regeln können wichtige Logs zu früh entfernen oder gar nicht rotieren.

## Diagnoseanker
Bei Logrotate-Problemen schichtweise prüfen: Timerzustand, Konfiguration, Pfade, Rechte, Statusdatei, Speicherplatz, Git-Zustand und Dokumentation.

Merksatz: Logrotate ist die Müllabfuhr für Logs. Sie räumt nicht blind auf, sondern nach Regeln, Zeitplan und Aufbewahrungsvorgaben.

## Ergebnis
Die Logrotate-Konfigurationsanalyse wurde aus privaten Rohdaten in eine öffentliche, portfolio-taugliche Bewertung überführt. Rohdaten bleiben privat; die öffentliche Dokumentation beschreibt Zweck, erkannte Indikatoren, Risiken und Lab-vs-Production-Unterschiede.
