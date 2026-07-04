# Arbeitsauftrag Lab21 – Dienstprobleme schichtenweise diagnostizieren

## Ziel

Diese Einheit trainiert einen praxisnahen Admin-Entscheidungskompass für Linux-Dienstprobleme.

## Kerngedanke

Nicht sofort ändern, sondern zuerst schichtweise prüfen:

1. Systemzustand
2. Dienststatus
3. Prozess
4. Port
5. Adresse / Bindung
6. Firewall
7. Client-Test
8. Logs

## Behandelte Dienste

- SSH (Secure Shell)
- CUPS (Common UNIX Printing System)
- UFW (Uncomplicated Firewall)
- systemd / journalctl

## Lernziel

Bei Dienstproblemen soll schnell entschieden werden können, welcher Prüfweg sinnvoll ist:

- unklare Lage: systemctl --failed
- bekannter Dienst: systemctl is-active DIENST
- Dienst läuft, aber Zugriff scheitert: ss, curl, ufw
- Ursache gesucht: journalctl gezielt filtern

## Merksatz

Erst Zustand klären. Dann Schicht eingrenzen. Dann Ursache suchen.
