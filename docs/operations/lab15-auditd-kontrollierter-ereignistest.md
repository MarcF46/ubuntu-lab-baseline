# Lab 15 – auditd kontrollierter Ereignistest

## Ziel

Im Lab wurde geprüft, ob die geladenen auditd-Regeln nicht nur sichtbar sind, sondern bei einer kontrollierten Änderung auch ein Audit-Ereignis erzeugen.

## Testmethode

Für den Test wurde eine temporäre Gruppe angelegt und direkt wieder entfernt. Dadurch wurden /etc/group und /etc/gshadow kontrolliert verändert. Diese Dateien werden durch die Lab15-Regeln mit dem Key lab15_identity_changes überwacht.

## Beobachteter Zustand

- Testgruppe: lab15auditcheck
- Event-Start: 2026-06-23T10:55:37+02:00
- Identity-Regeln vor Test: 4
- sudoers-Regeln vor Test: 2
- groupadd Exit-Code: 0
- groupdel Exit-Code: 0
- ausearch Exit-Code: 0
- aureport Exit-Code: 0
- Audit type-Zeilen seit recent: 48
- lab15_identity_changes Treffer: 8
- Test-Ergebnis: erfolgreich

## Betriebliche Bewertung

Der Test bestätigt, ob die Audit-Regeln nicht nur geladen sind, sondern bei einer kontrollierten Änderung an identitätsrelevanten Systemdateien Ereignisse erzeugen. Damit wird die Wirkung der Regel praktisch verifiziert.

## Vorsicht

Der Test wurde bewusst mit einer temporären Gruppe durchgeführt. Änderungen an /etc/sudoers wurden nicht simuliert, weil sudoers-Änderungen ein höheres Risiko für administrative Zugriffe haben.

## Merksätze

- Regel geladen heißt noch nicht: Wirkung bewiesen.
- Ein guter Test verändert wenig, beweist aber genug.
- Audit-Rohdaten bleiben privat.
- Öffentliche Dokumentation beschreibt Wirkung und Bewertung.
