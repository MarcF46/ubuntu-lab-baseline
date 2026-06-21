# Troubleshooting-Karte – Logging, Journal und Logrotation

## Zweck

Diese Karte hilft bei typischen Log- und Journal-Problemen auf Linux-Systemen: viele Warnungen, stark wachsendes /var/log, großes systemd-Journal, fehlerhafte Logrotation oder sicherheitsrelevante Login-Muster.

## Typisches Betriebsszenario

Ein Linux-System zeigt Fehler oder ungewöhnliches Verhalten. Logs werden geprüft, um Zeitraum, Dienst, Ursache und Wiederholungsmuster einzugrenzen. Gleichzeitig wird bewertet, ob Logs selbst zum Storage-Problem werden.

## Sofortprüfung

- systemctl is-active systemd-journald
- journalctl --disk-usage
- journalctl -p warning..alert --since "1 hour ago" --no-pager
- du -sh /var/log
- ls -lh /var/log
- systemctl is-active rsyslog

## Symptom 1 – Viele Warnungen im Journal

Typische Ursachen:

- Boot- oder Hardware-Warnungen
- Desktop-/GNOME-/Snap-Hintergrundmeldungen
- Treiber- oder Firmware-Hinweise
- Dienste mit Abhängigkeitsproblemen
- wiederholte Servicefehler

Prüfung:

- journalctl -p warning..alert --since "1 hour ago" --no-pager
- journalctl -b -p warning..alert --no-pager
- systemctl --failed --no-pager

Bewertung:

- Einzelne Boot-Warnungen sind nicht automatisch kritisch.
- Wiederholte Meldungen mit Dienstabbruch sind wichtiger.
- Warnungen mit Sicherheitsbezug, Datenverlust, Netzwerkverlust oder Serviceausfall priorisieren.

## Symptom 2 – Ein Dienst schreibt wiederholt Fehler

Prüfung:

- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager
- journalctl -u <dienstname> -n 100 --no-pager

Hinweis:

<dienstname> ist ein Platzhalter und muss ersetzt werden, zum Beispiel durch ssh, rsyslog oder systemd-journald.

Bewertung:

- Ist der Dienst active, failed oder restarting?
- Gibt es Exit-Codes?
- Tritt der Fehler nach Start, Reload, Login, Update oder Geräteanschluss auf?
- Gibt es eine klare Fehlermeldung oder nur eine Warnung?

## Symptom 3 – /var/log wächst stark

Typische Ursachen:

- Fehlerloop eines Dienstes
- sehr gesprächige Anwendung
- fehlende oder falsche Logrotation
- ungewöhnlich viele Authentifizierungsereignisse

Prüfung:

- du -sh /var/log
- sudo du -sh /var/log/* 2>/dev/null | sort -h
- ls -lh /var/log
- journalctl --disk-usage

Bewertung:

- Größte Logdatei oder größtes Logverzeichnis identifizieren.
- Ursache des Wachstums prüfen.
- Logs bei Incident-Verdacht vor Bereinigung sichern.
- Nicht blind löschen.

## Symptom 4 – Journal belegt viel Speicherplatz

Prüfung:

- journalctl --disk-usage
- ls -lh /var/log/journal 2>/dev/null
- sudo du -sh /var/log/journal 2>/dev/null

Bewertung:

- Prüfen, ob die Größe zum System und zur Nutzung passt.
- Bei starkem Wachstum Ursache im Journal suchen.
- In Produktion Aufbewahrung, Compliance und zentrale Logsammlung berücksichtigen.

## Symptom 5 – Logrotation greift nicht

Typische Folgen:

- klassische Logdateien wachsen dauerhaft weiter
- alte Logs werden nicht rotiert oder komprimiert
- /var/log wird langfristig zum Storage-Risiko

Prüfung:

- ls -lh /etc/logrotate.conf
- ls -lh /etc/logrotate.d
- sudo logrotate -d /etc/logrotate.conf

Bewertung:

- Debug-Modus zeigt nur, was passieren würde.
- Keine echte Rotation im Debug-Modus.
- Bei produktiven Systemen Rotation nicht blind erzwingen.

## Symptom 6 – Auffällige Login- oder SSH-Meldungen

Prüfung:

- tail -n 100 /var/log/auth.log 2>/dev/null
- journalctl -u ssh --since "1 hour ago" --no-pager
- journalctl -p warning..alert --since "1 hour ago" --no-pager | grep -i ssh

Bewertung:

- Viele fehlgeschlagene Logins sind sicherheitsrelevant.
- Erfolgreiche unbekannte Logins wären kritisch.
- In Produktion mit Fail2ban, SIEM oder zentralem Logging korrelieren.

## Typischer Anfängerfehler

Bei vielen Logs wird sofort gelöscht. Dadurch können wichtige Hinweise, Sicherheitsnachweise oder Incident-Spuren verloren gehen.

## Sicherer Diagnoseweg

1. Zeitraum eingrenzen.
2. Betroffenen Dienst oder Logbereich identifizieren.
3. Wiederholungsmuster suchen.
4. Schweregrad bewerten.
5. Bei Incident-Verdacht Logs sichern.
6. Ursache beheben.
7. Erst danach bereinigen oder Rotation anpassen.

## Betriebliche Einordnung

Logs sind gleichzeitig Diagnosequelle, Nachweisquelle und mögliches Storage-Risiko. Gute Logdiagnose bedeutet nicht, jede Warnung sofort zu reparieren, sondern relevante Muster sicher von Hintergrundrauschen zu trennen.

## Merksätze

- Logs sind der Flugschreiber des Systems.
- Warnung ist nicht gleich Incident.
- Erst Zeitraum, dann Dienst, dann Muster.
- Logrotation wechselt den Aktenordner, bevor er platzt.
- Erst sichern und bewerten, dann bereinigen.
