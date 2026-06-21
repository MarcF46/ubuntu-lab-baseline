# Runbook – Logging, Journal und Logrotation prüfen

## Ziel

Dieses Runbook beschreibt die Prüfung von systemd-journald, Journal-Meldungen, klassischen Logdateien unter /var/log, rsyslog und Logrotation auf einem Linux-System.

## Typisches Betriebsszenario

Ein Linux-System zeigt Servicefehler, Updateprobleme, langsames Verhalten oder unerklärliche Warnungen. Für die Diagnose werden Logs benötigt. Gleichzeitig können Logs selbst zum Problem werden, wenn sie unkontrolliert wachsen und Speicherplatz verbrauchen.

## Muss wissen

- systemd-journald sammelt zentrale System- und Service-Logs.
- journalctl ist das wichtigste Werkzeug zum Lesen des systemd-Journals.
- /var/log enthält klassische Logdateien, zum Beispiel syslog, auth.log, kern.log oder dpkg.log.
- rsyslog schreibt viele klassische Textlogs unter /var/log.
- logrotate rotiert, komprimiert und begrenzt klassische Logdateien.

## Wichtige Befehle

### Journal-Speicherverbrauch prüfen

- journalctl --disk-usage

Bedeutung:

- zeigt, wie viel Speicherplatz aktive und archivierte Journal-Dateien belegen.
- wichtig zur Bewertung, ob das Journal ein Storage-Risiko wird.

### Journal-Warnungen anzeigen

- journalctl -p warning..alert --since "1 hour ago" --no-pager

Bedeutung:

- -p warning..alert filtert Warnungen, Fehler und kritische Meldungen.
- --since begrenzt den Zeitraum.
- --no-pager gibt die Ausgabe direkt im Terminal aus.

### Logs eines Dienstes prüfen

- journalctl -u ssh --since "1 hour ago" --no-pager
- journalctl -u systemd-journald --no-pager -n 50

Bedeutung:

- -u filtert nach einer systemd-Unit.
- -n 50 zeigt die letzten 50 Einträge.

### Klassische Logdateien prüfen

- ls -lh /var/log
- du -sh /var/log
- sudo du -sh /var/log/* 2>/dev/null | sort -h

Bedeutung:

- ls zeigt Dateien, Größen, Besitzer und Zeitpunkte.
- du zeigt den Speicherverbrauch.
- sort -h sortiert Größen menschenlesbar.

### rsyslog prüfen

- systemctl status rsyslog --no-pager -l
- systemctl is-active rsyslog

Bedeutung:

- rsyslog ist häufig für klassische Logs wie syslog, auth.log und kern.log zuständig.
- active bedeutet, dass der Dienst läuft.

### Logrotate prüfen

- ls -lh /etc/logrotate.conf
- ls -lh /etc/logrotate.d
- sudo logrotate -d /etc/logrotate.conf

Bedeutung:

- /etc/logrotate.conf ist die Hauptkonfiguration.
- /etc/logrotate.d enthält einzelne Rotationsregeln.
- logrotate -d ist ein Debug-/Trockenlauf und rotiert nicht wirklich.

## Typische Fehlerbilder

- /var/log wächst stark und füllt das Dateisystem.
- Journal-Dateien belegen ungewöhnlich viel Speicherplatz.
- Ein Dienst schreibt wiederholt Fehler ins Journal.
- Logrotation läuft nicht oder ist falsch konfiguriert.
- auth.log zeigt viele fehlgeschlagene Login-Versuche.
- syslog oder kern.log enthält wiederkehrende Hardware-, Treiber- oder USB-Warnungen.

## Diagnoseweg bei vielen Warnungen im Journal

1. Zeitraum eingrenzen:

- journalctl -p warning..alert --since "1 hour ago" --no-pager

2. Wiederkehrende Muster erkennen:

- gleicher Dienst
- gleicher Kernel-Treiber
- gleiche Hardware-Komponente
- gleiche Zeitpunkte nach Boot, Login oder Geräteanschluss

3. Schweregrad einordnen:

- einmalige Warnung nach Boot
- wiederholte Warnung ohne sichtbare Auswirkung
- wiederholter Fehler mit Dienstabbruch
- sicherheitsrelevante Meldung, zum Beispiel Login-Fehler

4. Betroffenen Dienst prüfen:

- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager

Hinweis:

<dienstname> ist ein Platzhalter und muss durch den echten Dienstnamen ersetzt werden, zum Beispiel ssh oder rsyslog.

## Diagnoseweg bei wachsendem /var/log

1. Größe prüfen:

- du -sh /var/log

2. Größte Logbereiche finden:

- sudo du -sh /var/log/* 2>/dev/null | sort -h

3. Ursache einordnen:

- welches Log wächst?
- welcher Dienst schreibt hinein?
- ist es normales Wachstum oder ein Fehlerloop?

4. Nicht blind löschen:

- Logs können für Incident-Analyse, Security-Prüfung oder Fehlersuche wichtig sein.
- Bei echten Vorfällen erst sichern, dann bereinigen.

## Logrotation sicher prüfen

- sudo logrotate -d /etc/logrotate.conf

Bedeutung:

- -d steht für Debug-Modus.
- Im Debug-Modus wird angezeigt, was logrotate tun würde.
- Es werden keine echten Logdateien rotiert.

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Prüfung von Journal, /var/log und Logrotate. In Produktion sollten Loggröße, Journal-Wachstum, fehlgeschlagene Dienste, sicherheitsrelevante Login-Muster und Logrotation überwacht werden.

## Betriebliche Bewertung

Logs sind gleichzeitig Diagnosequelle und Betriebsrisiko. Ohne Logs fehlt der Flugschreiber. Ohne Begrenzung können Logs selbst das System beeinträchtigen.

## Merksätze

- Logs sind der Flugschreiber des Systems.
- journalctl zeigt die Geschichte von systemd-Diensten.
- /var/log ist der klassische Log-Aktenordner.
- logrotate wechselt den Aktenordner, bevor er platzt.
- Warnung ist nicht gleich Incident, aber immer ein Hinweis.
- Erst Logs sichern und bewerten, dann bereinigen.
