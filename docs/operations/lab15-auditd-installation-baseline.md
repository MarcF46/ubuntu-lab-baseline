# Lab 15 – auditd Installation und Baseline

## Ziel

Im Lab wurde auditd installiert und als Basis für Security-Auditing geprüft. In diesem Schritt wurden noch keine eigenen Audit-Regeln gesetzt.

## Beobachteter Zustand

- auditd vorher: nicht_installiert
- apt install Exit-Code: 0
- auditd nachher: install ok installed 1:4.1.2-1build1
- auditctl Pfad: /usr/sbin/auditctl
- ausearch Pfad: /usr/sbin/ausearch
- aureport Pfad: /usr/sbin/aureport
- auditd Dienststatus: active
- auditd Autostartstatus: enabled
- /etc/audit/auditd.conf: nicht_vorhanden
- /etc/audit/rules.d: nicht_vorhanden
- /var/log/audit/audit.log: vorhanden
- auditctl -s Exit-Code: 0
- auditctl -l Exit-Code: 0
- Change-Ergebnis: erfolgreich

## Betriebliche Bewertung

auditd ist nun als Audit-Basisdienst vorhanden. Damit können im nächsten Schritt gezielte Regeln für sicherheitsrelevante Dateien und administrative Änderungen geplant und aktiviert werden.

In diesem Lab bleibt der Ansatz bewusst kontrolliert: Erst Dienst und Werkzeuge prüfen, dann Regeln setzen. Maximale Protokollierung ohne Zielbild wird vermieden.

## Nächster Schritt

Als nächster Schritt wird eine eigene Lab-Regeldatei geplant, die ausgewählte sicherheitsrelevante Dateien überwacht.

## Merksätze

- Erst Audit-Dienst prüfen, dann Regeln setzen.
- Audit-Regeln müssen gezielt sein, nicht maximal laut.
- Rohdaten privat, Bewertung öffentlich.
