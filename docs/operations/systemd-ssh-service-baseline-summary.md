# systemd und journalctl - SSH-Service-Baseline

## Ausgangslage

Im Lab wurde der Dienstzustand von `ssh.service` mit `systemctl` geprüft und die zugehörige Logausgabe mit `journalctl` ausgewertet.

Der vollständige Rohlog-Nachweis wurde bewusst privat abgelegt, da er lokale Benutzer-, Host-, Port- und SSH-Key-Informationen enthält.

Privater Rohlog-Nachweis:

    docs/private/evidence/lab-03-systemd-logs/systemd-ssh-service-baseline-raw.txt

## Technischer Nachweis

Die Prüfung zeigte:

- `ssh.service` ist geladen.
- `ssh.service` ist aktiviert.
- `ssh.service` läuft aktiv.
- `systemctl is-active ssh` liefert `active`.
- `systemctl is-enabled ssh` liefert `enabled`.
- `journalctl` zeigt Start-, Stop- und SSH-Login-Ereignisse.

Die Systemzeitprüfung zeigte:

- Systemuhr ist synchronisiert.
- NTP-Dienst ist aktiv.
- Zeitzone ist Europe/Berlin.

## Betriebliche Bewertung

Der SSH-Dienst befindet sich in einem gesunden Grundzustand. Der Dienst läuft aktuell und ist für den automatischen Start beim Boot aktiviert.

Die Logs zeigen nachvollziehbare Ereignisse wie Dienststart, Dienststopp und erfolgreiche SSH-Anmeldungen. Damit ist `journalctl` als zentrale Quelle für Service-Ereignisse nutzbar.

Auffällig war eine zeitliche Darstellung mit `left` statt `ago` im Dienststatus. Das deutet darauf hin, dass ein Service-Zeitstempel aus Sicht des aktuellen Systemzeitpunkts in der Zukunft lag. Da NTP aktiv ist und die Systemuhr synchronisiert wurde, ist daraus aktuell kein akuter SSH-Fehler abzuleiten.

Wichtige Betriebsregel:

    Logs sind nur so zuverlässig wie die Systemzeit.

## Lab-vs-Production-Einordnung

Im Lab reicht die lokale Prüfung von `ssh.service`, `systemctl`, `journalctl` und `timedatectl` aus, um das Verhalten eines systemd-Dienstes nachzuvollziehen.

In Production wären zusätzlich relevant:

- zentrale Zeitsynchronisation
- zentrales Logging
- Alerting bei Service-Ausfällen
- Überwachung fehlgeschlagener systemd Units
- Log-Aufbewahrung und Zugriffskontrolle
- Dokumentation von Neustarts und Wartungsfenstern

## Nächster professioneller Schritt

Als nächster Schritt sollte ein kleines Health-Check-Skript für systemd-Dienste entstehen. Dieses Skript sollte mindestens prüfen, ob `ssh.service` aktiv und enabled ist und ob die Systemzeit synchronisiert wird.
