# Lab 15 – auditd Regeln für Admin-Dateien

## Ziel

Im Lab wurden erste eigene auditd-Regeln für sicherheitsrelevante Benutzer-, Gruppen- und sudo-Dateien erstellt und geladen.

## Beobachteter Zustand

- Repo-Regeldatei: configs/auditd/rules.d/30-lab15-admin-files.rules
- System-Regeldatei: /etc/audit/rules.d/30-lab15-admin-files.rules
- augenrules --load Exit-Code: 0
- auditctl -s Exit-Code: 0
- auditctl -l Exit-Code: 0
- lab15_identity_changes Regelanzahl: 4
- lab15_sudoers_changes Regelanzahl: 2
- Change-Ergebnis: erfolgreich

## Überwachte Bereiche

- /etc/passwd
- /etc/group
- /etc/shadow
- /etc/gshadow
- /etc/sudoers
- /etc/sudoers.d/

## Betriebliche Bewertung

Die Regeln überwachen bewusst nur ausgewählte sicherheitsrelevante Dateien. Damit bleibt das Lab kontrolliert und erzeugt keine unnötig große Audit-Datenmenge.

## Merksätze

- Audit-Regeln sind wie Bewegungsmelder an sensiblen Türen.
- Eigene Regeln gehören in eine eigene Datei.
- auditctl zeigt den geladenen Ist-Zustand.
- augenrules lädt den geplanten Regelzustand aus Regeldateien.
