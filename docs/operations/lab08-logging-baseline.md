# Lab 08 – Logging Baseline

## Ziel

Im Lab wurde eine erste Logging-Baseline erstellt. Geprüft wurden systemd-journald, Journal-Speicherverbrauch, Warnmeldungen, /var/log, Logrotate-Konfiguration und rsyslog-Verfügbarkeit.

## Typisches Betriebsszenario

Ein Linux-System zeigt Servicefehler, Updateprobleme oder unerklärliches Verhalten. Für die Diagnose werden Logs benötigt. Gleichzeitig können stark wachsende Logs selbst zu Storage-Problemen führen.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab08-logging/lab08-logging-baseline-raw.txt

## Beobachteter Zustand

- systemd-journald Zustand: active
- Journal Speicherverbrauch:  Archived and active journals take up 54.7M in the file system.
- /var/log Größe: 65M
- Größter direkter Eintrag unter /var/log: nicht ermittelt
- Warn-/kritische Journal-Einträge der letzten 2 Stunden: 145
- Logrotate.d Konfigurationsdateien: 19
- rsyslog Zustand: active

## Betriebliche Bewertung

Logging ist für Diagnose und Nachvollziehbarkeit zentral. Gleichzeitig dürfen Logs nicht unkontrolliert wachsen, weil volle Dateisysteme Folgefehler bei Updates, Services und Anwendungen auslösen können.

Die Baseline verbindet daher zwei Blickwinkel: Logs als Diagnosequelle und Logs als mögliches Storage-Risiko.

## Nächster professioneller Schritt

Als nächster Schritt wird ein Runbook für Journal-, Logdatei- und Logrotationsprüfung erstellt.

## Merksätze

- Logs sind der Flugschreiber des Systems.
- journalctl zeigt die Geschichte von systemd-Diensten.
- /var/log ist der klassische Log-Aktenordner.
- Logrotation verhindert, dass Aktenordner endlos wachsen.
- Erst Logs sichern und bewerten, dann bereinigen.
