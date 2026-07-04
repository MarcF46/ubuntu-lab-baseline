# Abschlussstatus Lab21 – Dienstprobleme und Admin-Entscheidungskompass

## Status

Lab21 wurde erfolgreich abgeschlossen.

## Behandelte Themen

- systemweiter Dienst-Health-Check mit systemctl --failed
- gezielter Dienststatus mit systemctl is-active
- Autostartprüfung mit systemctl is-enabled
- Port- und Adressbindung mit ss -tulpn
- UFW-Regelprüfung mit ufw status numbered
- lokaler und LAN-basierter Zugriffstest mit curl
- dienstbezogene Logauswertung mit journalctl -u DIENST -b
- Reduzierung von Lograuschen durch Filter
- Loopback vs. LAN
- SSH vs. CUPS als Vergleichsdienste
- SSSD als Identitätsdienst eingeordnet

## Wichtige Erkenntnisse

Installiert ist nicht dasselbe wie aktiv.
Aktiv ist nicht dasselbe wie erreichbar.
Ein UFW-Profil ist nicht automatisch eine offene Regel.
Ein Prozess kann laufen, ohne als systemweiter Dienst zu erscheinen.
Lograuschen ist normal, gute Filter sparen Zeit.

## Besonders wichtige Merksätze

journalctl ohne -b kann alte Boots mit anzeigen.
journalctl mit -b zeigt nur den aktuellen Systemstart.

Nicht jede Logzeile ist ein Problem.
Erst filtern, dann bewerten.

127.0.0.1 und ::1 zeigen immer auf den eigenen Rechner.
0.0.0.0 und :: bedeuten: Dienst lauscht auf allen passenden Netzwerkschnittstellen.

## Arbeitsplatznahe Kompetenz

Nach dieser Einheit kann ein Dienstproblem in Schichten eingeordnet werden:

1. Dienststatus
2. Prozess
3. Port
4. Adresse / Bindung
5. Firewall
6. Client-Test
7. Logs

## Abschlussbewertung

Nicht raten, sondern schichtweise prüfen.
Nicht in Logwänden versinken, sondern gezielt filtern.
Nicht sofort ändern, sondern zuerst den Zustand beweisen.
