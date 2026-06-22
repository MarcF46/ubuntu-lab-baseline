# Lab 14 – Arbeitsauftrag: Fail2ban als zusätzliche SSH-Schutzschicht

## Ticket / Arbeitsauftrag

Ein Ubuntu-Lab-Server wurde bereits mit SSH-Key-Login, deaktiviertem Passwortlogin, deaktiviertem X11Forwarding und aktiver UFW-Host-Firewall gehärtet. Als zusätzlicher Schutz soll geprüft werden, ob Fail2ban für den SSH-Dienst eingesetzt werden kann.

Ziel ist, wiederholte fehlgeschlagene SSH-Anmeldeversuche zu erkennen und auffällige Quellen temporär zu blockieren. Die bestehende SSH-Erreichbarkeit darf dabei nicht beeinträchtigt werden.

## Ausgangslage

- SSH-Key-Login ist aktiv.
- PasswordAuthentication ist deaktiviert.
- X11Forwarding ist deaktiviert.
- UFW ist aktiv.
- SSH-Port 22/tcp ist erlaubt.
- Security-Health-Check ist erfolgreich.
- Fail2ban ist vor Beginn des Labs noch nicht installiert.

## Anforderungen

- Fail2ban-Paketstatus prüfen.
- Fail2ban installieren, falls nicht vorhanden.
- SSH-Jail für sshd konfigurieren.
- Fail2ban-Dienst starten und für Autostart aktivieren.
- Fail2ban-Konfiguration testen.
- sshd-Jail über fail2ban-client prüfen.
- Security-Health-Check erneut ausführen.
- Ergebnis dokumentieren.
- Readiness-Problem nach Dienststart fachlich einordnen, falls es auftritt.

## Erfolgskriterien

- fail2ban-client ist vorhanden.
- fail2ban.service ist active.
- fail2ban.service ist enabled.
- fail2ban-client ping liefert eine erfolgreiche Antwort.
- Jail-Liste enthält sshd.
- fail2ban-client status sshd ist abrufbar.
- Fail2ban-Konfigurationstest ist erfolgreich.
- UFW bleibt aktiv.
- SSH-Härtung bleibt unverändert.
- Git-Arbeitsstand ist sauber.

## Risiken

- Fail2ban startet, ist aber direkt nach dem Restart noch nicht über den Client-Socket ansprechbar.
- Eine fehlerhafte Jail-Konfiguration kann den Dienststart verhindern.
- Zu aggressive Ban-Regeln können legitime Admin-Zugriffe stören.
- In Produktion müssen Ban-Zeiten, Allowlists, Monitoring und Eskalation sorgfältig geplant werden.

## Rollback-Idee

Bei Problemen kann die Fail2ban-Jail-Konfiguration deaktiviert oder entfernt werden. Anschließend wird die Konfiguration getestet und der Fail2ban-Dienst neu gestartet. Bei schwerwiegenden Problemen kann Fail2ban gestoppt oder deaktiviert werden, während SSH und UFW unverändert weiterlaufen.

## Betriebliche Einordnung

Fail2ban ist keine Ersatzmaßnahme für SSH-Härtung oder Firewall-Regeln. Es ergänzt vorhandene Schutzschichten um eine Reaktion auf wiederholte fehlgeschlagene Anmeldeversuche.

## Merksätze

- UFW ist der Türsteher.
- Fail2ban ist der Türsteher mit Gedächtnis.
- systemctl zeigt den Prozesszustand.
- Der Client-Test zeigt die Ansprechbarkeit.
- Schutzschichten ergänzen sich, sie ersetzen sich nicht.
