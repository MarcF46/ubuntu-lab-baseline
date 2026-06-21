# Lab 06a – Kontrollierter Update-Change mit Backup, Snapshot, Rollback und Nachprüfung

## Ziel

Diese Einheit beschreibt einen kontrollierten Update-Change für ein Ubuntu-Lab-System. Im Fokus stehen nicht nur die Paketinstallation, sondern Vorprüfung, Absicherung, Rollback-Planung, Durchführung, Nachprüfung und Statuskommunikation.

## Typisches Betriebsszenario

Ein Linux-Server hat verfügbare Updates. Vor der Installation muss entschieden werden, ob der Update-Lauf freigegeben werden kann, welche Risiken bestehen, ob ein Backup oder Snapshot vorhanden ist und welche Prüfungen nach dem Update notwendig sind.

## Change-Zusammenfassung

- Change-Typ: kontrollierter Paketupdate-Change
- System: Ubuntu-Lab-System
- Status: Vorbereitung, noch keine Installation
- Update-Quelle: apt-Paketverwaltung
- Vorprüfung: Lab 06 apt Update-Prüfung und Reboot-/Risiko-Bewertung
- Installation: noch nicht durchgeführt
- Nachprüfung: geplant

## Vorliegende Nachweise aus Lab 06

- apt-Update-Bewertung vorhanden
- Reboot-/Risiko-Bewertung vorhanden
- Runbook vorhanden
- Checkliste vorhanden
- Troubleshooting-Karte vorhanden
- privater Rohoutput vorhanden

## Backup-/Snapshot-Bewertung

Im Lab wurde noch kein echter VM-Snapshot oder vollständiges Systembackup erstellt. Für eine produktionsnahe Durchführung muss deshalb vor einer echten Installation bewusst entschieden werden, welche Absicherungsebene genutzt wird.

Geeignete Absicherungsebenen:

- Paketliste vor dem Update sichern
- apt-Historie prüfen
- Systemzustand vor dem Update dokumentieren
- wichtige Dienste vor dem Update prüfen
- bei VM-Systemen Snapshot vor dem Update erstellen
- bei produktiven Systemen Backup-/Restore-Fähigkeit prüfen

## Rollback-Plan

Der Rollback hängt davon ab, wie das System betrieben wird.

Lab-Variante:

- Paketlisten und apt-Historie sichern
- installierte Paketversionen dokumentieren
- Zustand kritischer Dienste vor und nach dem Update vergleichen
- bei Fehlern konkrete Paket-/Service-Logs auswerten

Produktionsvariante:

- VM-Snapshot oder Backup vor Änderung bestätigen
- Restore-Verfahren kennen
- Wartungsfenster definieren
- betroffene Dienste und Ansprechpartner dokumentieren
- Rückfallentscheidung vorab festlegen

## Vorprüfung vor Installation

Vor einem echten Update sollten mindestens geprüft werden:

- git status --short
- apt list --upgradable
- sudo apt-get -s upgrade
- test -f /var/run/reboot-required
- systemctl --failed
- systemctl status ssh --no-pager -l
- freier Speicherplatz mit df -h

## Nachprüfung nach Installation

Nach einem echten Update sollten mindestens geprüft werden:

- apt list --upgradable
- test -f /var/run/reboot-required
- systemctl --failed
- systemctl status ssh --no-pager -l
- journalctl -p warning..alert --since "30 minutes ago" --no-pager
- relevante Service-Health-Checks
- apt-Historie

## Entscheidung für dieses Lab

Der echte Update-Lauf wird erst durchgeführt, nachdem ein Vorher-Zustand dokumentiert wurde. Dadurch entsteht ein nachvollziehbarer technischer Nachweis vor und nach der Änderung.

## Betriebliche Bewertung

Ein Update ist eine kontrollierte Betriebsänderung. Professionell ist nicht nur die Installation selbst, sondern der vollständige Ablauf aus Vorprüfung, Absicherung, Durchführung, Nachweis und Rückfalloption.

## Merksätze

- Backup ist der Rettungsanker.
- Snapshot ist der schnelle Zwischenstand, aber kein vollständiger Backup-Ersatz.
- Rollback wird vor der Änderung geplant.
- Erst absichern, dann ändern, dann beweisen.
- Update ohne Nachprüfung ist nur halbe Betriebsarbeit.
