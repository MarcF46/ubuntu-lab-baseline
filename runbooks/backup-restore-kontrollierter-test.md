# Runbook – Kontrollierter Backup-/Restore-Test

## Zweck

Dieses Runbook beschreibt einen sicheren, kontrollierten Backup- und Restore-Test mit harmlosen Lab-Testdaten. Ziel ist der Nachweis, dass ein Backup nicht nur erstellt, sondern auch geprüft, wiederhergestellt und mit dem Ausgangszustand verglichen werden kann.

## Typisches Betriebsszenario

Ein Team muss nachweisen, dass Daten im Fehlerfall wiederhergestellt werden können. Dafür reicht es nicht, ein Archiv zu besitzen. Entscheidend ist ein dokumentierter Restore-Test mit Prüfsumme, sauberem Zielpfad und Vergleich zwischen Quelle und Wiederherstellung.

## Begriffe

- Backup: Sicherung von Daten in eine zweite Ablageform.
- Restore: Wiederherstellung gesicherter Daten.
- Archiv: zusammengefasste Datei, die mehrere Dateien oder Ordner enthält.
- TAR: Tape Archive, klassisches Linux-Archivformat.
- gzip: Komprimierungsverfahren, häufig bei .tar.gz.
- SHA-256: kryptografische Prüfsumme zur Integritätsprüfung.
- Prüfsumme: digitaler Fingerabdruck einer Datei.
- diff: Vergleichswerkzeug für Dateien oder Verzeichnisse.
- Quelle: ursprünglicher Datenbestand.
- Restore-Ziel: Zielordner für die Wiederherstellung.

## Sicherer Ablauf

1. Testdaten erstellen.
2. Backup-Ziel vorbereiten.
3. Archiv erstellen.
4. Prüfsumme erzeugen.
5. Prüfsumme prüfen.
6. Archiv in separaten Zielordner wiederherstellen.
7. Quelle und Restore vergleichen.
8. Ergebnis dokumentieren.
9. Risiken und Produktionsunterschiede bewerten.

## 1. Testdaten vorbereiten

Im Lab werden ausschließlich harmlose Testdaten genutzt.

Beispielstruktur:

    test-source/
      config/
      data/
      notes/

Bewertung:

- Keine echten Benutzerdaten verwenden.
- Keine Passwörter verwenden.
- Keine Tokens verwenden.
- Keine privaten Schlüssel verwenden.
- Keine produktiven Konfigurationsgeheimnisse verwenden.

## 2. Archiv erstellen

Basisbefehl:

    tar -czf lab12-test-backup.tar.gz -C <basisordner> <quellordner>

Bedeutung:

- tar erstellt oder liest Archive.
- -c erstellt ein neues Archiv.
- -z nutzt gzip-Komprimierung.
- -f gibt den Archivdateinamen an.
- -C wechselt vor dem Archivieren in einen Zielordner.

Bewertung:

- Der Pfad muss genau geprüft werden.
- Ein falscher -C-Pfad kann unerwartete Ordnerstrukturen erzeugen.
- Ein zu breiter Quellpfad kann versehentlich sensible Daten sichern.

## 3. Prüfsumme erzeugen

Basisbefehl:

    sha256sum lab12-test-backup.tar.gz > lab12-test-backup.sha256

Bewertung:

- Die Prüfsumme dient als Integritätsnachweis.
- Wenn sich das Archiv ändert, ändert sich auch die Prüfsumme.
- Prüfsummen ersetzen keine Verschlüsselung.
- Prüfsummen zeigen Integrität, nicht Vertraulichkeit.

## 4. Prüfsumme prüfen

Basisbefehl:

    sha256sum --check lab12-test-backup.sha256

Bewertung:

- Exit-Code 0 bedeutet: Prüfsummenprüfung erfolgreich.
- Ein Fehler bedeutet: Archiv stimmt nicht mehr zur gespeicherten Prüfsumme.
- Ursache können beschädigte Datei, falscher Pfad oder verändertes Archiv sein.

## 5. Restore durchführen

Basisbefehl:

    tar -xzf lab12-test-backup.tar.gz -C <restore-ziel>

Bedeutung:

- -x extrahiert ein Archiv.
- -z nutzt gzip.
- -f gibt das Archiv an.
- -C legt den Zielordner fest.

Bewertung:

- Restore nie unüberlegt in produktive Zielpfade durchführen.
- Immer zuerst in einen separaten Restore-Testordner entpacken.
- Zielpfad vor Ausführung prüfen.
- Bestehende Daten nicht versehentlich überschreiben.

## 6. Quelle und Restore vergleichen

Basisbefehl:

    diff -qr <quelle> <restore-ziel>

Bedeutung:

- diff vergleicht Dateien oder Verzeichnisse.
- -q zeigt nur, ob Dateien unterschiedlich sind.
- -r vergleicht rekursiv Unterordner.

Bewertung:

- Exit-Code 0 bedeutet: keine Unterschiede gefunden.
- Unterschiede müssen fachlich bewertet werden.
- Metadaten wie Zeitstempel, Besitzer oder Rechte können je nach Verfahren zusätzlich relevant sein.

## 7. Erfolgreiche Mindestkriterien

Ein Lab-Restore gilt als erfolgreich, wenn:

- Archiv wurde erstellt.
- Prüfsumme wurde erzeugt.
- Prüfsumme wurde erfolgreich geprüft.
- Archiv wurde in separaten Restore-Ordner entpackt.
- Quelle und Restore wurden verglichen.
- Vergleich zeigt keine Unterschiede.
- Ergebnis wurde dokumentiert.

## Typische Fehlerbilder

### Archiv wurde nicht erstellt

Mögliche Ursachen:

- falscher Quellpfad.
- fehlende Rechte.
- Zielordner existiert nicht.
- kein freier Speicherplatz.
- falscher tar-Befehl.

Erste Prüfung:

    ls -lah <zielordner>
    df -hT
    tar --version

### Prüfsumme schlägt fehl

Mögliche Ursachen:

- Archiv wurde nachträglich verändert.
- Prüfsummendatei zeigt auf falschen Dateinamen.
- Archiv wurde beschädigt.
- Prüfsummendatei liegt im falschen Ordner.

Erste Prüfung:

    sha256sum <archiv>
    cat <pruefsummendatei>
    sha256sum --check <pruefsummendatei>

### Restore schlägt fehl

Mögliche Ursachen:

- Zielordner fehlt.
- keine Schreibrechte.
- Archiv beschädigt.
- falscher Archivpfad.
- zu wenig Speicherplatz.

Erste Prüfung:

    ls -lah <archiv>
    df -hT
    tar -tzf <archiv> | head

### Vergleich zeigt Unterschiede

Mögliche Ursachen:

- unvollständiger Restore.
- falscher Restore-Zielpfad.
- Quelle wurde nach Backup verändert.
- Archiv enthielt nicht den erwarteten Ordner.
- Dateien wurden beim Restore überschrieben oder verändert.

Erste Prüfung:

    find <quelle> -type f | sort
    find <restore-ziel> -type f | sort
    diff -qr <quelle> <restore-ziel>

## Sicherheitsbewertung

Backups können besonders sensible Daten enthalten:

- personenbezogene Daten.
- Passwörter.
- Tokens.
- private Schlüssel.
- Konfigurationsgeheimnisse.
- Datenbankinhalte.
- Kundendaten.
- interne Dokumente.

Deshalb müssen echte Backups geschützt werden durch:

- Zugriffsbeschränkung.
- Verschlüsselung.
- sichere Ablage.
- saubere Aufbewahrungsfristen.
- getrennte Backup-Ziele.
- Restore-Tests.
- Lösch- und Notfallkonzept.

## Lab-vs-Production-Einordnung

Im Lab reicht ein lokaler Test mit TAR, gzip, SHA-256 und diff.

In Produktion sind zusätzliche Punkte erforderlich:

- Backup-Plan.
- Restore-Plan.
- Rollen und Verantwortlichkeiten.
- Aufbewahrungsstrategie.
- Offsite-Kopie.
- Verschlüsselung.
- Zugriffsschutz.
- Monitoring.
- regelmäßige Restore-Tests.
- Dokumentation der Restore-Zeit.
- Dokumentation des Restore-Punkts.
- Schutz gegen Ransomware.
- getrennte Backup-Rechte.
- Notfallkommunikation.

## Typischer Anfängerfehler

Ein Backup wird als erfolgreich betrachtet, nur weil eine Archivdatei existiert. Das ist zu wenig. Ohne Prüfsumme, Restore-Test und Vergleich ist nicht sicher nachgewiesen, ob die Sicherung im Ernstfall nutzbar ist.

## Sichere Grundregel

Vor produktiven Restore-Aktionen gilt:

- Zielpfad prüfen.
- bestehende Daten schützen.
- Rückfallplan erstellen.
- Verantwortliche informieren.
- Restore zuerst in separatem Ziel testen.
- Ergebnis dokumentieren.

## Merksätze

- Backup ist nur eine Behauptung.
- Restore ist der Beweis.
- Prüfsummen sind das Siegel auf dem Paket.
- Kein Backup ohne Restore-Test.
- Backup ist der Fallschirm.
- Restore ist der Sprungtest.
