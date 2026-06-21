# Geplante zusätzliche Trainingseinheiten

## Lab 06a – Kontrollierter Update-Change mit Backup, Snapshot, Rollback und Nachprüfung

## Zweck

Diese zusätzliche Trainingseinheit erweitert Lab 06 um den vollständigen betrieblichen Ablauf rund um Paketupdates.

Updates sollen nicht nur technisch installiert werden. Im Fokus stehen Vorprüfung, Absicherung, kontrollierte Durchführung, Nachprüfung und professionelle Statuskommunikation.

## Typisches Betriebsszenario

Ein Linux-Server hat verfügbare Updates. Vor der Installation muss geklärt werden, ob ein Backup oder Snapshot vorhanden ist, wie ein Rollback möglich wäre und welche Health Checks nach dem Update erforderlich sind.

## Trainingsinhalte

- Backup- beziehungsweise Snapshot-Plan vor einer Änderung prüfen
- Unterschied zwischen Backup, Snapshot und Restore einordnen
- Rollback-Strategie vor dem Update formulieren
- Systemzustand vor der Änderung dokumentieren
- kontrollierten Update-Lauf durchführen
- Reboot-Bedarf nach dem Update prüfen
- Dienste, Logs und systemd-Fehlerzustände nachprüfen
- apt-Historie und installierte Paketänderungen nachvollziehen
- kurze professionelle Statusmeldung erstellen

## Betriebliche Bewertung

Ein Update ist eine kontrollierte Betriebsänderung. Professionell ist nicht nur die Installation selbst, sondern der vollständige Ablauf aus Vorprüfung, Absicherung, Durchführung, Nachweis und Rückfalloption.

## Lab-vs-Production-Einordnung

Im Lab kann ein Update direkt auf dem lokalen System getestet werden. In Produktion wären zusätzlich Wartungsfenster, Backup- oder Snapshot-Freigabe, Monitoring, Change-Dokumentation, Rollback-Plan und klare Verantwortlichkeiten erforderlich.

## Merksätze

- Backup ist der Rettungsanker.
- Snapshot ist der schnelle Zwischenstand, aber kein vollständiger Backup-Ersatz.
- Rollback wird vor der Änderung geplant, nicht erst nach dem Fehler.
- Update ohne Nachprüfung ist nur halbe Betriebsarbeit.
- Erst absichern, dann ändern, dann beweisen.
