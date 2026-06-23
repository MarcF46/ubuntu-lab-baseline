# Lab 16 – Preflight-Bewertung: Logrotate und Log-Aufbewahrung

## Ziel

Der Preflight prüft, welche Logrotate-, journald- und auditd-Mechanismen auf dem Lab-System bereits vorhanden sind. In dieser Phase wurden keine Rotationseinstellungen verändert.

## Beobachteter Zustand

- Zeitpunkt der Prüfung: 2026-06-23T11:04:20+02:00
- logrotate vorhanden: true
- logrotate Version: 3.22.0
- logrotate.timer aktiv wartend: true
- logrotate.timer aktiviert: true
- letzter logrotate.service-Lauf erfolgreich: true
- journald aktiv: true
- journald Speicherverbrauch: Archived and active journals take up 74.1M in the file system.
- journald Drop-in-Verzeichnis fehlt: true
- auditd Loggröße: 432K	/var/log/audit
- /var/log Gesamtgröße: 87M	/var/log

## auditd Rotation

- max_log_file: 8 MB
- num_logs: 5
- max_log_file_action: ROTATE
- disk_full_action: SUSPEND
- disk_error_action: SUSPEND

## Betriebliche Einordnung

logrotate ist installiert und wird über einen systemd-Timer regelmäßig gestartet. Der Service selbst ist nach dem Lauf wieder inaktiv. Das ist bei einem kurz laufenden Timer-Service normal und kein Fehler.

journald belegt aktuell nur einen moderaten Speicherbereich. Für das Lab ist das unkritisch, sollte aber später bewusst mit Aufbewahrung, Speichergrenzen und Analyseanforderungen verbunden werden.

auditd ist ein Sonderfall: Die Rotation wird nicht einfach nur über logrotate betrachtet, sondern auditd bringt eigene Rotationsparameter in auditd.conf mit. Aktuell ist eine Rotation bei 8 MB pro Logdatei und 5 Logs konfiguriert. Für ein Lab ist das klein und kontrollierbar. In produktiven Umgebungen müsste die Aufbewahrung an Incident-Response-, Compliance-, SIEM- und Datenschutzanforderungen angepasst werden.

## Risiken

- Zu kurze Aufbewahrung kann wichtige Security- und Diagnoseereignisse vernichten.
- Zu lange Aufbewahrung kann Speicherplatzprobleme erzeugen.
- Security-Logs können sensible Informationen enthalten.
- Rotation ohne Verständnis kann Analyseketten unterbrechen.
- auditd-Logs müssen besonders kontrolliert behandelt werden, weil sie Nachweischarakter haben.

## Lab-vs-Production

Im Lab reicht eine kleine, kontrollierte Logmenge. In Produktion braucht es zusätzlich klare Vorgaben zu Aufbewahrungsfristen, Zugriffsschutz, zentraler Sammlung, Monitoring, Alarmierung bei Speicherproblemen und Restore-/Forensik-Anforderungen.

## Merksätze

- Ein Timer wartet. Ein One-Shot-Service arbeitet kurz und verschwindet wieder.
- Logs sind Spuren, aber Spuren brauchen Ordnung.
- Rotation ist nicht Löschen, sondern kontrolliertes Weiterreichen.
- auditd-Logs sind Nachweise, nicht nur Textdateien.
