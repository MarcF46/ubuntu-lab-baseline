# Troubleshooting-Karte – Backup-/Restore-Fehlerdiagnose

## Zweck

Diese Karte unterstützt die Diagnose typischer Fehler bei kontrollierten Backup- und Restore-Tests auf Linux-Systemen.

## Sofortprüfung

- `ls -lah <backup-ziel>`
- `df -hT`
- `tar -tzf <archiv> | head`
- `sha256sum <archiv>`
- `sha256sum --check <pruefsummendatei>`
- `tar -xzf <archiv> -C <restore-ziel>`
- `diff -qr <quelle> <restore-ziel>`

## Symptom 1 – Archiv wurde nicht erstellt

Mögliche Ursachen:

- Quellpfad falsch.
- Zielordner fehlt.
- Schreibrechte fehlen.
- Dateiname falsch.
- Speicherplatz reicht nicht.
- tar-Befehl falsch aufgebaut.

Prüfung:

- `ls -lah <quellordner>`
- `ls -lah <zielordner>`
- `df -hT`
- `tar --version`

Bewertung:

- Ohne Archiv existiert kein nutzbares Backup.
- Zuerst Pfade und Rechte prüfen.
- Danach Speicherplatz prüfen.
- Erst dann den tar-Befehl korrigieren.

## Symptom 2 – Archiv ist leer oder unerwartet klein

Mögliche Ursachen:

- falscher Quellordner.
- leerer Quellordner.
- falscher -C-Pfad.
- Dateien wurden nicht eingeschlossen.
- Ausschlussmuster zu breit gesetzt.

Prüfung:

- `du -sh <quellordner>`
- `find <quellordner> -type f | sort`
- `tar -tzf <archiv> | head`
- `tar -tzf <archiv> | wc -l`

Bewertung:

- Ein existierendes Archiv ist noch kein gültiges Backup.
- Der Inhalt muss zum erwarteten Sicherungsumfang passen.
- Ein zu kleines Archiv ist ein Warnsignal.

## Symptom 3 – Prüfsumme schlägt fehl

Mögliche Ursachen:

- Archiv wurde nach der Prüfsummenerstellung verändert.
- Prüfsummendatei verweist auf falschen Dateinamen.
- Archiv wurde beschädigt.
- Datei liegt in anderem Verzeichnis.
- Prüfsummendatei wurde falsch erzeugt.

Prüfung:

- `cat <pruefsummendatei>`
- `sha256sum <archiv>`
- `sha256sum --check <pruefsummendatei>`

Bewertung:

- Eine fehlgeschlagene Prüfsumme ist ein Integritätsproblem.
- Das Archiv darf dann nicht ungeprüft als verlässlich gelten.
- Ursache muss dokumentiert und behoben werden.

## Symptom 4 – Restore schlägt fehl

Mögliche Ursachen:

- Restore-Ziel existiert nicht.
- Schreibrechte fehlen.
- Archiv ist beschädigt.
- Archivpfad ist falsch.
- Ziel-Dateisystem hat zu wenig freien Speicherplatz.
- Archivformat passt nicht zum verwendeten Befehl.

Prüfung:

- `ls -lah <archiv>`
- `ls -ld <restore-ziel>`
- `df -hT`
- `tar -tzf <archiv> | head`
- `tar -xzf <archiv> -C <restore-ziel>`

Bewertung:

- Ein Backup ohne erfolgreichen Restore ist betrieblich nicht belastbar.
- Restore nie direkt in produktive Zielpfade testen.
- Zuerst separaten Restore-Testordner verwenden.

## Symptom 5 – Restore funktioniert, aber Vergleich zeigt Unterschiede

Mögliche Ursachen:

- Quelle wurde nach dem Backup verändert.
- Restore-Ziel ist falsch.
- Archiv enthält anderen Ordnernamen.
- nicht alle Dateien wurden gesichert.
- Dateien wurden beim Restore überschrieben.
- Metadaten wurden nicht erhalten.

Prüfung:

- `find <quelle> -type f | sort`
- `find <restore-ziel> -type f | sort`
- `diff -qr <quelle> <restore-ziel>`

Bewertung:

- Unterschiede müssen fachlich geprüft werden.
- Bei Lab-Daten sollte ein identischer Vergleich möglich sein.
- Bei Produktionsdaten können zusätzlich Rechte, Besitzer, Zeitstempel und ACLs relevant sein.

## Symptom 6 – Speicherplatz reicht nicht

Mögliche Ursachen:

- Ziel-Dateisystem zu klein.
- altes Backup nicht gelöscht.
- Restore-Ziel auf falschem Mountpoint.
- große Quelldaten unterschätzt.
- temporäre Dateien belegen Platz.

Prüfung:

- `df -hT`
- `du -sh <quelle>`
- `du -sh <backup-ziel>`
- `find <ziel> -maxdepth 1 -type f -ls`

Bewertung:

- Speicherplatzprobleme können Backup und Restore gleichermaßen treffen.
- Vor dem Backup und vor dem Restore muss freier Speicher geprüft werden.
- Ein Backup-Ziel darf nicht stillschweigend volllaufen.

## Symptom 7 – Sensible Daten wurden versehentlich gesichert

Mögliche Ursachen:

- Quellpfad zu breit gewählt.
- Home-Verzeichnis komplett gesichert.
- Konfigurationsdateien mit Secrets enthalten.
- private Schlüssel wurden eingeschlossen.
- Datenbankdump enthält echte Daten.

Prüfung:

- Sicherungsumfang prüfen.
- Dateiliste prüfen.
- bekannte Secret-Dateien ausschließen.
- Zugriff auf Backup-Ziel prüfen.

Bewertung:

- Backups sind oft sensibler als die Originaldaten, weil viele Daten gebündelt vorliegen.
- Zugriffsschutz, Verschlüsselung und Aufbewahrung sind Pflichtpunkte in produktionsnahen Konzepten.
- Sensible Backups gehören nicht in öffentliche Repositories.

## Symptom 8 – Backup liegt auf demselben System

Mögliche Ursachen:

- Lab-Test bewusst lokal.
- kein externes Backup-Ziel eingerichtet.
- Offsite-Strategie fehlt.
- Backup-Ziel ist nur ein lokaler Ordner.

Bewertung:

- Für das Lab ist ein lokaler Test sinnvoll.
- Für Produktion reicht ein Backup auf demselben System nicht aus.
- Bei Hardwaredefekt, Ransomware oder versehentlicher Löschung wäre das Backup mitgefährdet.

## Typischer Anfängerfehler

Ein Backup wird als erfolgreich bewertet, weil eine Datei mit `.tar.gz` existiert. Das ist zu wenig. Entscheidend ist, ob die Datei lesbar, unverändert, wiederherstellbar und mit dem erwarteten Datenbestand vergleichbar ist.

## Sicherer Diagnoseweg

1. Quellpfad prüfen.
2. Zielpfad prüfen.
3. Speicherplatz prüfen.
4. Archivinhalt prüfen.
5. Prüfsumme prüfen.
6. Restore in separates Ziel durchführen.
7. Quelle und Restore vergleichen.
8. Ergebnis dokumentieren.
9. Sicherheitsrisiken bewerten.

## Sichere Maßnahmen

- Keine produktiven Daten in Lab-Backups verwenden.
- Restore nie unüberlegt in produktive Pfade durchführen.
- Prüfsummen erzeugen und prüfen.
- Restore-Test dokumentieren.
- Zugriff auf Backups einschränken.
- echte Backups verschlüsseln.
- Backup-Ziele getrennt vom Quellsystem planen.
- Restore regelmäßig testen.

## Lab-vs-Production-Einordnung

Im Lab wird ein lokaler Backup-/Restore-Test mit harmlosen Daten durchgeführt.

In Produktion müssen zusätzlich Backup-Strategie, Wiederanlaufplanung, Aufbewahrung, Verschlüsselung, Offsite-Kopie, Zugriffsschutz, Ransomware-Schutz, Monitoring, Verantwortlichkeiten und regelmäßige Restore-Tests definiert werden.

## Merksätze

- Backup ist nur eine Behauptung.
- Restore ist der Beweis.
- Prüfsummen sind das Siegel auf dem Paket.
- Kein Backup ohne Restore-Test.
- Backup ist der Fallschirm.
- Restore ist der Sprungtest.
- Wenn der Restore scheitert, ist der Backup-Prozess nicht belastbar.
