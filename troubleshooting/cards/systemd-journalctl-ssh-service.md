# Troubleshooting-Karte: systemd, journalctl und ssh.service

## Zweck

Diese Karte unterstützt bei typischen Problemen mit systemd-Diensten am Beispiel von `ssh.service`.

## Symptom 1: Dienst ist nicht aktiv

Typische Prüfung:

    systemctl is-active ssh

Problematisches Ergebnis:

    inactive
    failed

Weitere Prüfung:

    systemctl status ssh --no-pager -l
    journalctl -u ssh --no-pager -n 50 -o short-iso

Bewertung:

Wenn `ssh.service` nicht aktiv ist, muss geprüft werden, ob der Dienst gestoppt wurde, fehlerhaft startet oder durch eine Konfigurationsänderung blockiert wird.

## Symptom 2: Dienst startet nicht automatisch

Typische Prüfung:

    systemctl is-enabled ssh

Problematisches Ergebnis:

    disabled

Möglicher Fix im Lab:

    sudo systemctl enable ssh

Bewertung:

Ein Dienst kann aktuell laufen, aber beim nächsten Neustart nicht automatisch starten. Deshalb müssen `active` und `enabled` getrennt geprüft werden.

Merksatz:

    active = läuft jetzt.
    enabled = startet beim Boot.

## Symptom 3: Dienst ist failed

Prüfung:

    systemctl --failed
    systemctl status ssh --no-pager -l
    journalctl -u ssh --no-pager -n 100 -o short-iso

Bewertung:

`failed` bedeutet, dass systemd einen Dienstfehler erkannt hat. Dann sind Statusausgabe und Logs gemeinsam auszuwerten.

## Symptom 4: Logs wirken zeitlich unplausibel

Beobachtung:

    Zeitangaben wirken verschoben
    ago/left wirkt unlogisch
    Ereignisse passen zeitlich nicht zusammen

Prüfung:

    timedatectl
    journalctl -u ssh --no-pager -n 30 -o short-iso

Bewertung:

Logauswertung ist nur zuverlässig, wenn Systemzeit und Zeitsynchronisation stimmen.

Merksatz:

    Logs sind nur so zuverlässig wie die Systemzeit.

## Symptom 5: journalctl zeigt zu viele Informationen

Bessere Eingrenzung:

    journalctl -u ssh --no-pager -n 30 -o short-iso
    journalctl -u ssh --since "1 hour ago" --no-pager
    journalctl -u ssh --since today --no-pager

Bewertung:

Im Betrieb ist Eingrenzung wichtig. Zu große Logmengen erschweren Diagnose und erhöhen das Risiko, wichtige Hinweise zu übersehen.

## Sofortprüfung im Lab

    systemctl status ssh --no-pager -l
    systemctl is-active ssh
    systemctl is-enabled ssh
    timedatectl
    journalctl -u ssh --no-pager -n 30 -o short-iso
    ./scripts/check-systemd-ssh.sh

## Mögliche Sofortmaßnahmen im Lab

Dienst neu starten:

    sudo systemctl restart ssh

Dienst aktivieren:

    sudo systemctl enable ssh

Status erneut prüfen:

    systemctl status ssh --no-pager -l

Achtung:

Bei echter Remote-Administration kann ein fehlerhafter SSH-Neustart den eigenen Zugang unterbrechen. In Production sollte vor Änderungen ein zweiter Zugang oder eine Konsole verfügbar sein.

## Lab-vs-Production-Einordnung

Im Lab reicht lokale Diagnose mit `systemctl`, `journalctl`, `timedatectl` und Health-Check-Skript.

In Production wären zusätzlich relevant:

- Monitoring für failed units
- Alerting bei Service-Ausfall
- zentrale Logsammlung
- Zeitserver-Überwachung
- dokumentierte Wartungsfenster
- Notfallzugang bei SSH-Problemen

## Professionelle Statusmeldung

Der SSH-Dienst wurde mit systemctl und journalctl geprüft. Der Dienst ist aktiv, enabled und die Systemzeit ist synchronisiert. Die Logauswertung zeigt nachvollziehbare Start-, Stop- und Login-Ereignisse. Der Health-Check wurde erfolgreich mit Exit-Code 0 abgeschlossen.
