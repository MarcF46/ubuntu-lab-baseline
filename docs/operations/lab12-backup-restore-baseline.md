# Lab 12 – Backup-/Restore-Baseline

## Ziel

Im Lab wurde die Ausgangslage für eine sichere Backup- und Restore-Übung geprüft. Ziel ist nicht die Sicherung echter sensibler Systemdaten, sondern ein kontrollierter Restore-Nachweis mit Testdaten.

## Typisches Betriebsszenario

Ein Team muss nachweisen, dass Daten nicht nur gesichert, sondern auch kontrolliert wiederhergestellt werden können. Dafür wird ein sicherer Test mit harmlosen Lab-Daten, Prüfsummen und dokumentiertem Restore-Prozess aufgebaut.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab12-backup/lab12-backup-restore-baseline-raw.txt

## Beobachteter Zustand

- tar verfügbar: ja
- sha256sum verfügbar: ja
- rsync verfügbar: ja
- gzip verfügbar: ja
- findmnt verfügbar: ja
- Root-Dateisystem: 10% belegt von 150G (ext4)
- Freier Speicher Root-Dateisystem: 130G frei

## Geplanter sicherer Lab-Ansatz

Für die praktische Übung wird ein kontrolliertes Testverzeichnis erstellt. Daraus wird ein komprimiertes TAR-Archiv erzeugt. Anschließend wird eine SHA-256-Prüfsumme gebildet, das Archiv in ein Restore-Verzeichnis entpackt und der wiederhergestellte Inhalt mit dem Ausgangszustand verglichen.

## Betriebliche Bewertung

Ein Backup ist erst dann betrieblich belastbar, wenn ein Restore erfolgreich getestet wurde. Besonders wichtig sind Prüfsummen, klare Zielpfade, dokumentierte Annahmen, ausreichend Speicherplatz und eine saubere Trennung zwischen echten sensiblen Daten und harmlosen Lab-Daten.

## Nächster professioneller Schritt

Als nächster Schritt wird ein kontrollierter Backup- und Restore-Test mit Testdaten durchgeführt.

## Merksätze

- Backup ist nur eine Behauptung.
- Restore ist der Beweis.
- Prüfsummen sind das Siegel auf dem Paket.
- Kein Backup ohne Restore-Test.
