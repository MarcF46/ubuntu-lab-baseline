# Lab 13b – UFW Firewall-Change-Plan

## Ziel

Im Lab wird die spätere Aktivierung von UFW als kontrollierter Firewall-Change vorbereitet. Es wird noch keine Firewall aktiviert.

## Beobachteter Zustand

- UFW Pfad: /usr/sbin/ufw
- UFW Status: Status: Inaktiv
- SSH Dienststatus: active
- SSH Autostartstatus: enabled
- SSH Port 22 lokal sichtbar: ja
- PasswordAuthentication: no
- PubkeyAuthentication: yes

## Geplanter sicherer Ablauf

1. SSH-Zugriff prüfen.
2. bestehende Sitzung offen lassen.
3. SSH-Allow-Regel für Port 22 setzen.
4. UFW Default Policy prüfen.
5. UFW aktivieren.
6. neue SSH-Sitzung testen.
7. Security-Health-Check erneut ausführen.
8. Ergebnis dokumentieren.

## Nicht in diesem Schritt enthalten

- keine Aktivierung von UFW
- keine Änderung an SSH
- keine Änderung an Routing oder DNS
- kein Schließen bestehender SSH-Sitzungen

## Rollback-Idee

Wenn UFW später den Zugriff stört, muss über die offene Sitzung oder lokale Konsole UFW deaktiviert oder die Regel korrigiert werden. Vor Aktivierung muss daher ein Rückweg vorhanden sein.

## Betriebliche Bewertung

UFW ist der letzte verbleibende Härtungskandidat aus der aktuellen Security-Baseline. Die Aktivierung ist sinnvoll, muss aber als separater Change mit SSH-Schutz behandelt werden.

## Merksätze

- Firewall ist der Türsteher.
- Keine Firewall-Änderung ohne Rückweg.
- Erst SSH erlauben, dann Firewall aktivieren.
- Port offen heißt Tür vorhanden; Firewall erlaubt heißt Durchgang erlaubt.
