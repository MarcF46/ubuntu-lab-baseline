# Lab 12 – Kontrollierter Backup-/Restore-Test

## Ziel

Im Lab wurde ein kontrollierter Backup- und Restore-Test mit harmlosen Testdaten durchgeführt. Ziel war der praktische Nachweis, dass ein erzeugtes Archiv per Prüfsumme geprüft, wiederhergestellt und mit dem Ausgangszustand verglichen werden kann.

## Typisches Betriebsszenario

Ein Team muss nicht nur behaupten, dass Backups vorhanden sind, sondern nachweisen, dass eine Wiederherstellung technisch funktioniert und nachvollziehbar geprüft wurde.

## Testumfang

Gesichert wurden ausschließlich künstlich erzeugte Lab-Testdaten. Es wurden keine echten Benutzer-, System-, Secret-, Passwort- oder produktiven Anwendungsdaten gesichert.

## Technischer Ablauf

1. Kontrolliertes Testverzeichnis erstellt.
2. Testdateien für Konfiguration, Beispieldaten und Notizen erzeugt.
3. Komprimiertes TAR-Archiv erstellt.
4. SHA-256-Prüfsumme erzeugt.
5. Prüfsumme gegen das Archiv geprüft.
6. Archiv in ein Restore-Ziel entpackt.
7. Quelle und Restore per diff verglichen.

## Beobachteter Zustand

- Quelldateien: 3
- Wiederhergestellte Dateien: 3
- Archivgröße: 4.0K
- SHA-256-Prüfsumme: 0d356a6ef068a0b8b8d5f2f174bb7d415eb8ca648af1d185b7f8c2ac69cc3d4f
- Prüfsummenprüfung Exit-Code: 0
- Restore Exit-Code: 0
- Vergleich Exit-Code: 0
- Gesamtergebnis: erfolgreich

## Private Artefakte

Die erzeugten Testdaten, das Archiv, die Prüfsumme und der Diff-Nachweis wurden bewusst privat abgelegt:

- docs/private/evidence/lab12-backup/test-source/
- docs/private/evidence/lab12-backup/artifacts/
- docs/private/evidence/lab12-backup/restore-target/

## Betriebliche Bewertung

Der Test zeigt den wichtigen Unterschied zwischen Backup-Erstellung und Restore-Nachweis. Ein Archiv allein ist noch kein belastbares Backup. Erst die erfolgreiche Prüfsummenprüfung, das erfolgreiche Entpacken und der Vergleich zwischen Quelle und Restore liefern einen nachvollziehbaren Nachweis.

In produktionsnahen Umgebungen müssten zusätzlich Zeitplan, Aufbewahrung, Verschlüsselung, Zugriffsschutz, Offsite-Kopie, Restore-Zeit, Restore-Punkt, Verantwortlichkeiten und regelmäßige Testläufe definiert werden.

## Sicherheitsbewertung

Der Test wurde bewusst mit harmlosen Lab-Daten durchgeführt. Echte Backups können sensible Daten, personenbezogene Informationen, Passwörter, Konfigurationsgeheimnisse oder Schlüssel enthalten und müssen deshalb besonders geschützt werden.

## Nächster professioneller Schritt

Als nächster Schritt werden ein Runbook, eine Checkliste und eine Troubleshooting-Karte für Backup-/Restore-Prozesse erstellt.

## Merksätze

- Backup ist nur eine Behauptung.
- Restore ist der Beweis.
- Prüfsummen sind das Siegel auf dem Paket.
- Kein Backup ohne Restore-Test.
