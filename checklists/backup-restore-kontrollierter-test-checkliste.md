# Checkliste – Kontrollierter Backup-/Restore-Test

## Zweck

Diese Checkliste dient zur sicheren Durchführung und Bewertung eines kontrollierten Backup-/Restore-Tests mit harmlosen Lab-Daten.

## Grundregel

Ein Backup gilt erst dann als belastbar, wenn ein Restore erfolgreich getestet und dokumentiert wurde.

## Vor dem Backup prüfen

- Sind die zu sichernden Daten klar definiert?
- Werden ausschließlich harmlose Lab-Daten genutzt?
- Sind keine Passwörter enthalten?
- Sind keine Tokens enthalten?
- Sind keine privaten Schlüssel enthalten?
- Sind keine echten Benutzer- oder Kundendaten enthalten?
- Ist ausreichend freier Speicherplatz vorhanden?
- Ist das Backup-Ziel eindeutig?
- Ist das Restore-Ziel eindeutig?
- Wird nicht direkt in produktive Zielpfade wiederhergestellt?

## Werkzeuge prüfen

- tar vorhanden?
- gzip vorhanden?
- sha256sum vorhanden?
- diff vorhanden?
- df vorhanden?
- findmnt vorhanden?
- optional rsync vorhanden?

Basisprüfung:

    command -v tar
    command -v gzip
    command -v sha256sum
    command -v diff
    command -v df
    command -v findmnt
    command -v rsync

## Backup erstellen

- Quellordner prüfen.
- Zielordner prüfen.
- Archivname eindeutig wählen.
- tar mit -czf verwenden.
- -C-Pfad bewusst setzen.
- Archiv nach Erstellung prüfen.

Beispiel:

    tar -czf lab12-test-backup.tar.gz -C <basisordner> <quellordner>

Bewertung:

- -c erstellt ein Archiv.
- -z nutzt gzip-Komprimierung.
- -f setzt den Archivdateinamen.
- -C wechselt vor dem Archivieren in einen Zielordner.

## Prüfsumme erzeugen

- SHA-256-Prüfsumme erzeugen.
- Prüfsummendatei neben dem Archiv ablegen.
- Prüfsummendatei nicht mit dem Archiv verwechseln.

Beispiel:

    sha256sum lab12-test-backup.tar.gz > lab12-test-backup.sha256

Bewertung:

- Prüfsumme zeigt Integrität.
- Prüfsumme schützt nicht vor unbefugtem Lesen.
- Verschlüsselung ist ein separates Thema.

## Prüfsumme prüfen

- Prüfsumme gegen das Archiv prüfen.
- Exit-Code beachten.
- Fehlermeldungen dokumentieren.

Beispiel:

    sha256sum --check lab12-test-backup.sha256

Bewertung:

- Exit-Code 0 bedeutet erfolgreiche Prüfung.
- Fehler bedeutet: Archiv, Pfad oder Prüfsummendatei passt nicht.

## Restore durchführen

- Separates Restore-Ziel nutzen.
- Zielordner vorher prüfen.
- Nicht in produktive Pfade entpacken.
- Archiv mit tar extrahieren.
- Restore-Exit-Code beachten.

Beispiel:

    tar -xzf lab12-test-backup.tar.gz -C <restore-ziel>

Bewertung:

- -x extrahiert ein Archiv.
- -z nutzt gzip.
- -f gibt das Archiv an.
- -C setzt das Zielverzeichnis.

## Quelle und Restore vergleichen

- Datei-Anzahl vergleichen.
- Quelle und Restore per diff vergleichen.
- Exit-Code dokumentieren.
- Unterschiede bewerten.

Beispiel:

    diff -qr <quelle> <restore-ziel>

Bewertung:

- Exit-Code 0 bedeutet: keine Unterschiede gefunden.
- Unterschiede müssen fachlich geprüft werden.
- Bei echten Systemen können zusätzlich Rechte, Besitzer und Zeitstempel relevant sein.

## Erfolgreicher Mindestnachweis

Ein kontrollierter Restore-Test gilt im Lab als erfolgreich, wenn:

- Testdaten wurden erstellt.
- Archiv wurde erstellt.
- Prüfsumme wurde erzeugt.
- Prüfsumme wurde erfolgreich geprüft.
- Archiv wurde erfolgreich entpackt.
- Quelle und Restore wurden verglichen.
- Vergleich zeigt keine Unterschiede.
- Ergebnis wurde dokumentiert.
- sensible Daten wurden nicht verwendet.

## Typische Fehlerbilder prüfen

- Archiv wurde nicht erstellt.
- Archiv ist leer oder unerwartet klein.
- falscher Quellpfad wurde gesichert.
- Prüfsumme schlägt fehl.
- Restore-Ziel fehlt.
- Restore schlägt wegen Rechten fehl.
- Restore schlägt wegen Speicherplatzmangel fehl.
- diff zeigt Unterschiede.
- Quelle wurde nach Backup verändert.
- Archiv wurde in den falschen Zielpfad entpackt.
- sensible Daten wurden versehentlich aufgenommen.

## Sicherheitsprüfung

- Enthält das Backup personenbezogene Daten?
- Enthält das Backup Passwörter?
- Enthält das Backup Tokens?
- Enthält das Backup private Schlüssel?
- Enthält das Backup Datenbankinhalte?
- Enthält das Backup interne Konfigurationsdateien?
- Ist Zugriff auf das Backup eingeschränkt?
- Ist Verschlüsselung erforderlich?
- Ist die Ablage getrennt vom Quellsystem?
- Gibt es eine Lösch- oder Aufbewahrungsregel?

## Lab-vs-Production-Einordnung

Im Lab reicht ein lokaler Test mit TAR, gzip, SHA-256 und diff.

In Produktion müssen zusätzlich geprüft werden:

- Backup-Zeitplan.
- Restore-Zeit.
- Restore-Punkt.
- Aufbewahrung.
- Verschlüsselung.
- Zugriffsschutz.
- Offsite-Kopie.
- Ransomware-Schutz.
- Monitoring.
- regelmäßige Restore-Tests.
- Verantwortlichkeiten.
- Notfallkommunikation.
- Dokumentation für Audit und Betrieb.

## Sichere Dokumentation

- Keine echten Geheimnisse dokumentieren.
- Keine privaten Schlüssel dokumentieren.
- Keine personenbezogenen Rohdaten veröffentlichen.
- Pfade und Verfahren sachlich beschreiben.
- Ergebnis mit Exit-Codes dokumentieren.
- Grenzen des Lab-Tests klar benennen.

## Merksätze

- Backup ist nur eine Behauptung.
- Restore ist der Beweis.
- Prüfsummen sind das Siegel auf dem Paket.
- Kein Backup ohne Restore-Test.
- Backup ist der Fallschirm.
- Restore ist der Sprungtest.
- Eine Sicherung ohne getestete Wiederherstellung ist nur Hoffnung.
