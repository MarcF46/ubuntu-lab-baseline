# Lab 14 – Fail2ban SSH-Jail

## Ziel

Im Lab wurde Fail2ban installiert und ein SSH-Jail für sshd aktiviert. Ziel ist eine zusätzliche Schutzschicht gegen wiederholte fehlgeschlagene SSH-Anmeldeversuche.

## Beobachteter Zustand

- fail2ban vorher: nicht_gefunden
- fail2ban nachher: /usr/bin/fail2ban-client
- apt install Exit-Code: 0
- Fail2ban Konfigurationstest Exit-Code: 0
- Fail2ban Dienststatus: active
- Fail2ban Autostartstatus: enabled
- SSH-Jail Status Exit-Code: 255
- Security Health Check Exit-Code: 0
- Change-Ergebnis: fehlerhaft

## Konfiguration

Die Repo-Vorlage liegt hier:

- configs/fail2ban/jail.d/sshd.local

Die Systemkonfiguration wurde nach /etc/fail2ban/jail.d/sshd.local installiert.

## Betriebliche Bewertung

Fail2ban ergänzt SSH-Härtung und UFW. Es ersetzt weder Key-basierte Anmeldung noch Firewall-Regeln. In diesem Lab schützt Fail2ban zusätzlich gegen auffällige wiederholte SSH-Fehlversuche.

## Merksätze

- UFW ist der Türsteher.
- Fail2ban ist der Türsteher mit Gedächtnis.
- Schutzschichten ergänzen sich, sie ersetzen sich nicht.
