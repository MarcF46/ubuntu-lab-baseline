# Lab 14 – Fail2ban SSH-Schutz Change-Plan

## Ziel

Im Lab wird Fail2ban als zusätzlicher SSH-Schutz vorbereitet. Fail2ban soll später fehlgeschlagene Login-Versuche erkennen und auffällige Quellen temporär blockieren können.

## Beobachteter Zustand

- fail2ban-client: nicht gefunden
- SSH Dienststatus: active
- UFW Status: Status: Aktiv
- PasswordAuthentication: no
- PubkeyAuthentication: yes
- /var/log/auth.log: vorhanden
- SSH Journal-Zeilen letzte 24h: 46

## Geplanter Ablauf

1. Fail2ban-Paketstatus prüfen.
2. Fail2ban installieren, falls nicht vorhanden.
3. lokale Jail-Konfiguration für sshd erstellen.
4. Dienst starten und aktivieren.
5. Fail2ban-Status prüfen.
6. Security-Health-Check erneut ausführen.
7. Ergebnis dokumentieren.

## Betriebliche Bewertung

Fail2ban ersetzt keine saubere SSH-Härtung und keine Firewall. Es ist eine zusätzliche Schutzschicht. Besonders wichtig bleibt: SSH-Key-Login aktiv, Passwortlogin deaktiviert, UFW aktiv und Port 22 bewusst erlaubt.

## Merksätze

- UFW ist der Türsteher.
- Fail2ban merkt sich Störenfriede.
- Schutzschichten ergänzen sich, sie ersetzen sich nicht.
