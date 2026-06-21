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

## Lab 06b – Update-Automation mit Monitoring, Reboot-Erkennung und sicherer Freigabelogik

## Zweck

Diese spätere Trainingseinheit erweitert den kontrollierten Update-Change um Automatisierung und Monitoring.

Ziel ist kein blinder Vollautomat, sondern ein sicherer Ablauf, der Updates erkennt, Risiken bewertet, Reboot-Bedarf meldet und nur klar freigegebene Update-Klassen automatisch ausführt.

## Typisches Betriebsszenario

Mehrere Linux-Server müssen regelmäßig auf Updates geprüft werden. Updates ohne Reboot-Bedarf und ohne kritische Paketgruppen könnten automatisiert verarbeitet werden. Updates mit Reboot-Bedarf oder kritischen Komponenten sollen dagegen im Monitoring sichtbar werden und eine manuelle Freigabe oder ein Wartungsfenster auslösen.

## Möglicher Ablauf

- verfügbare Updates regelmäßig prüfen
- Security-Updates erkennen
- kritische Paketgruppen erkennen
- Reboot-Marker prüfen
- Update-Lauf simulieren
- Entscheidung treffen: automatisch ausführen oder Alarm/Ticket erzeugen
- nach einem Update Health Checks durchführen
- Reboot-Bedarf nach dem Update erneut prüfen
- Ergebnis an Monitoring oder Statusdatei übergeben

## Sicherheitslogik

Automatisierung sollte nicht bedeuten, dass jedes Update blind installiert wird. Sinnvoll ist eine Policy-Logik:

- unkritische Updates ohne Reboot-Bedarf: automatisierbar nach Freigaberegel
- kritische Pakete: manuelle Prüfung oder Wartungsfenster
- Reboot erforderlich: Monitoring-Alarm oder Ticket statt blindem Neustart
- fehlgeschlagene Health Checks: Alarm und keine weiteren Änderungen

## Monitoring-Idee

Ein Skript könnte regelmäßig prüfen, ob Updates verfügbar sind, ob ein Reboot nötig ist und ob kritische Pakete betroffen sind. Das Ergebnis könnte später über Monitoring sichtbar gemacht werden, zum Beispiel als Statusdatei, Metrik oder Alert.

## Betriebliche Bewertung

Diese Einheit verbindet Paketverwaltung, Automatisierung, Monitoring, Change-Management und Betriebssicherheit. Sie ist damit besonders wertvoll für Cloud-Ops-, DevOps- und Plattform-Engineering-Grundlagen.

## Merksätze

- Automatisierung ersetzt nicht die Entscheidung.
- Reboot wird gemeldet, nicht überrascht.
- Kritische Pakete brauchen Freigabe.
- Monitoring macht Update-Risiken sichtbar.
- Gute Automation hat Bremsen, nicht nur Gas.
