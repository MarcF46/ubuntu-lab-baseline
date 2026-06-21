# Checkliste: systemd und journalctl am Beispiel ssh.service prüfen

## Zweck

Diese Checkliste dient zur schnellen Kontrolle eines systemd-Dienstes am Beispiel von `ssh.service`.

## Dienststatus

- [ ] systemd-Version wurde geprüft.
- [ ] Dienststatus wurde mit `systemctl status ssh --no-pager -l` geprüft.
- [ ] `Loaded` wurde bewertet.
- [ ] `Active` wurde bewertet.
- [ ] `Main PID` wurde geprüft.
- [ ] Letzte Status-Logzeilen wurden gelesen.

## Active / Enabled

- [ ] Laufender Zustand wurde mit `systemctl is-active ssh` geprüft.
- [ ] Erwarteter Zustand ist `active`.
- [ ] Autostart wurde mit `systemctl is-enabled ssh` geprüft.
- [ ] Erwarteter Zustand ist `enabled`.
- [ ] Unterschied zwischen `active` und `enabled` wurde verstanden.

## Logauswertung

- [ ] SSH-Logs wurden mit `journalctl -u ssh` geprüft.
- [ ] Ausgabe wurde mit `--no-pager` nicht-interaktiv angezeigt.
- [ ] Anzahl der Logzeilen wurde mit `-n` begrenzt.
- [ ] Zeitformat wurde mit `-o short-iso` lesbar gemacht.
- [ ] Start-, Stop- und Login-Ereignisse wurden fachlich eingeordnet.

## Systemzeit

- [ ] Systemzeit wurde mit `timedatectl` geprüft.
- [ ] `System clock synchronized` wurde bewertet.
- [ ] `NTP service` wurde bewertet.
- [ ] Auffällige Zeitdarstellungen wie `left` statt `ago` wurden eingeordnet.

## Health-Check

- [ ] Skript `scripts/check-systemd-ssh.sh` wurde ausgeführt.
- [ ] Ergebnis war erfolgreich.
- [ ] Exit-Code war `0`.
- [ ] Rohoutput wurde privat abgelegt.
- [ ] Öffentliche Kurzbewertung wurde erstellt.

## Lab-vs-Production

- [ ] Lab-Prüfung wurde als lokale Einzelserverprüfung eingeordnet.
- [ ] Production-Unterschiede wurden dokumentiert.
- [ ] Zentrales Logging wurde als späterer Ausbaupunkt erkannt.
- [ ] Monitoring und Alerting wurden als spätere Betriebsbausteine markiert.

## Abschlusskriterien

Der Abschnitt gilt als sauber geprüft, wenn:

- `ssh.service` aktiv ist.
- `ssh.service` enabled ist.
- Logs abrufbar und fachlich eingeordnet sind.
- Systemzeit synchronisiert ist.
- Health-Check-Skript erfolgreich läuft.
- Sensible Rohlogs privat bleiben.
