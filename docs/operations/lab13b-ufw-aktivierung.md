# Lab 13b – UFW-Aktivierung

## Ziel

Im Lab wurde UFW als Host-Firewall kontrolliert aktiviert. Ziel war, eingehende Verbindungen standardmäßig zu begrenzen und SSH weiterhin erreichbar zu halten.

## Beobachteter Zustand

- UFW vorher: Status: Inaktiv
- UFW nachher: Status: Aktiv
- SSH vor UFW Exit-Code: 255
- SSH nach UFW Exit-Code: 255
- Security Health Check Exit-Code: 0
- Rollback: automatisch_ausgefuehrt
- Change-Ergebnis: fehlerhaft

## Umgesetzte Regeln

- Default incoming: deny
- Default outgoing: allow
- SSH Port 22/tcp: allow

## Betriebliche Bewertung

Die Firewall wurde erst nach gesetzter SSH-Allow-Regel aktiviert. Der SSH-Zugriff wurde vor und nach der Aktivierung geprüft.

## Rollback-Idee

Bei Problemen kann UFW über die offene Sitzung oder lokale Konsole mit sudo ufw disable deaktiviert werden.

## Merksätze

- Erst SSH erlauben, dann Firewall aktivieren.
- Firewall ist der Türsteher.
- Nach dem Change zählt der neue Login-Test.
