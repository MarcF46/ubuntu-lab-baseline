# Lab 14 – Fail2ban Diagnose und Nachprüfung

## Ausgangslage

Nach der Installation und Konfiguration von Fail2ban wurde der Dienst als active gemeldet, der erste Aufruf von fail2ban-client status sshd lieferte jedoch einen Socket-Fehler.

## Ursache / Einordnung

Die Nachprüfung zeigt, dass Fail2ban anschließend normal lief. Der erste Fehler wird als Readiness-/Timing-Thema eingeordnet: Der systemd-Dienst war bereits gestartet, der Fail2ban-Socket war für den Client-Aufruf aber offenbar noch nicht zuverlässig erreichbar.

## Nachprüfung

- Fail2ban Dienststatus: active
- Fail2ban Autostartstatus: enabled
- Fail2ban Ping: Server replied: pong
- Jail-Liste: sshd
- SSH-Jail Status Exit-Code: 0
- Configtest Exit-Code: 0

## Betriebliche Bewertung

Der Vorfall ist ein typisches Beispiel dafür, dass ein Dienst nach einem Restart nicht nur als active geprüft werden sollte. Zusätzlich muss geprüft werden, ob die Anwendung wirklich bereit ist und ihre Verwaltungsschnittstelle funktioniert.

## Merksätze

- systemctl zeigt den Prozesszustand.
- Der Client-Test zeigt die Ansprechbarkeit.
- Ein Dienst kann laufen, bevor er vollständig bereit ist.
- Nach Restart immer Readiness prüfen, nicht nur active.
