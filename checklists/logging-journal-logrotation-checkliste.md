# Checkliste – Logging, Journal und Logrotation

## Zweck

Diese Checkliste dient zur schnellen Prüfung von systemd-journald, Journal-Meldungen, klassischen Logdateien unter /var/log, rsyslog und Logrotation.

## Typisches Betriebsszenario

Ein Linux-System zeigt Servicefehler, Updateprobleme, ungewöhnliches Verhalten oder wachsenden Speicherverbrauch. Logs werden geprüft, um Ursache, Zeitraum und betroffene Dienste einzugrenzen.

## Basisprüfung

- systemctl is-active systemd-journald
- systemctl status systemd-journald --no-pager -l
- journalctl --disk-usage
- du -sh /var/log
- ls -lh /var/log

Erwartung:

- systemd-journald ist active.
- Journal-Speicherverbrauch ist bekannt und nicht auffällig hoch.
- /var/log ist nicht ungewöhnlich groß.
- Logdateien sind vorhanden und zeitlich plausibel.

## Warnungen und Fehler prüfen

- journalctl -p warning..alert --since "1 hour ago" --no-pager
- journalctl -p err..alert --since "1 hour ago" --no-pager
- journalctl -b -p warning..alert --no-pager

Bewertung:

- Warnungen sind Hinweise, aber nicht automatisch Incidents.
- Wiederholungen und Muster sind wichtiger als einzelne Boot-Warnungen.
- Kritisch sind Fehler mit Dienstabbruch, Sicherheitsbezug oder sichtbarer Auswirkung.

## Dienstbezogene Logs prüfen

- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager
- journalctl -u <dienstname> -n 100 --no-pager

Hinweis:

<dienstname> ist ein Platzhalter und muss durch einen echten Dienst ersetzt werden, zum Beispiel ssh, rsyslog oder systemd-journald.

## Klassische Logdateien prüfen

- ls -lh /var/log
- sudo du -sh /var/log/* 2>/dev/null | sort -h
- tail -n 50 /var/log/syslog 2>/dev/null
- tail -n 50 /var/log/auth.log 2>/dev/null
- tail -n 50 /var/log/kern.log 2>/dev/null

Bewertung:

- syslog zeigt allgemeine Systemmeldungen.
- auth.log ist besonders wichtig für Login- und SSH-Ereignisse.
- kern.log enthält Kernel-, Treiber- und Hardware-Meldungen.

## Logrotation prüfen

- ls -lh /etc/logrotate.conf
- ls -lh /etc/logrotate.d
- sudo logrotate -d /etc/logrotate.conf

Erwartung:

- Hauptkonfiguration ist vorhanden.
- Dienstspezifische Regeln unter /etc/logrotate.d sind vorhanden.
- Debug-Lauf zeigt, was logrotate tun würde, ohne echte Rotation auszuführen.

## rsyslog prüfen

- command -v rsyslogd
- systemctl is-active rsyslog
- systemctl status rsyslog --no-pager -l

Erwartung:

- rsyslog ist vorhanden, wenn klassische Logs wie syslog/auth.log genutzt werden.
- rsyslog ist active, sofern installiert und benötigt.

## Typische Fehlerbilder

- Viele wiederholte Fehler im Journal.
- /var/log wächst stark.
- Journal belegt ungewöhnlich viel Speicher.
- auth.log zeigt viele fehlgeschlagene Login-Versuche.
- kern.log zeigt wiederkehrende Hardware- oder Treiberprobleme.
- Logrotate-Regeln fehlen oder greifen nicht.

## Sicheres Verhalten

- Logs nicht blind löschen.
- Bei Incident-Verdacht Logs zuerst sichern.
- Zeitraum und Dienst eingrenzen.
- Wiederholende Muster suchen.
- Erst Ursache bewerten, dann bereinigen.

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Prüfung. In Produktion sollten Journal-Größe, /var/log-Wachstum, fehlgeschlagene Dienste, SSH-/Login-Muster und Logrotation über Monitoring oder zentrale Logsysteme überwacht werden.

## Merksätze

- Logs sind der Flugschreiber des Systems.
- journalctl zeigt die Geschichte.
- /var/log ist der klassische Aktenordner.
- logrotate wechselt den Aktenordner, bevor er platzt.
- Warnung ist nicht gleich Incident.
- Erst Zeitraum, dann Dienst, dann Muster.
