# Checkliste – Storage Baseline und Speicherplatz-Diagnose

## Zweck

Diese Checkliste dient zur schnellen Prüfung von Speicherplatz, Dateisystemen, Mounts, Blockgeräten, Swap und typischen Storage-Risiken auf einem Linux-System.

## Typisches Betriebsszenario

Ein Linux-Server zeigt Update-, Logging-, Backup- oder Service-Probleme. Vor tieferer Fehlersuche wird geprüft, ob ein Dateisystem voll ist, ein Mount fehlt oder ein Log-/Datenverzeichnis stark gewachsen ist.

## Typisches Fehlerbild

- apt schlägt fehl, weil zu wenig Speicherplatz vorhanden ist.
- Services starten nicht, weil sie keine Dateien mehr schreiben können.
- Logs fehlen oder brechen ab, weil /var/log voll ist.
- Backups schlagen fehl, weil das Ziel-Dateisystem fast voll ist.
- Eine erwartete Datenplatte ist nicht gemountet.
- Swap wird stark genutzt und weist auf Speicherdruck hin.

## Basisprüfung

- df -hT
- lsblk -f
- findmnt -rno TARGET,SOURCE,FSTYPE,OPTIONS
- swapon --show
- free -h

Erwartung:

- Root-Dateisystem ist nicht kritisch voll.
- Wichtige Mountpunkte sind vorhanden.
- Dateisystemtypen sind plausibel.
- Swap-Zustand ist bekannt.

## Speicherplatz bewerten

- unter 70 Prozent Nutzung: meist unkritisch
- ab 80 Prozent Nutzung: beobachten und Wachstum prüfen
- ab 90 Prozent Nutzung: aktiv bewerten und bereinigen oder erweitern
- ab 95 Prozent Nutzung: kritisch, besonders bei /, /var, /var/log oder Backup-/Daten-Dateisystemen

## Große Ordner finden

- du -sh /var/log
- du -sh /home/* 2>/dev/null
- du -sh ./* 2>/dev/null | sort -h
- sudo du -xh / --max-depth=1 2>/dev/null | sort -h
- sudo du -xh /var --max-depth=1 2>/dev/null | sort -h

Erwartung:

- Große Verzeichnisse werden sichtbar.
- Auffälliges Wachstum kann eingegrenzt werden.
- Es wird nicht blind gelöscht.

## Logs prüfen

- sudo journalctl --disk-usage
- ls -lh /var/log
- sudo du -sh /var/log/* 2>/dev/null | sort -h

Bewertung:

- Journal- und Loggröße prüfen.
- Logs nicht vorschnell löschen, wenn sie für Fehleranalyse benötigt werden.
- Erst Ursache und Aufbewahrungsbedarf bewerten.

## Mounts prüfen

- findmnt
- lsblk -f
- df -hT

Bewertung:

- Ist ein erwartetes Laufwerk eingehängt?
- Ist ein externes oder Backup-Dateisystem fast voll?
- Stimmen Mountpoint und Dateisystemtyp?

## Kritische Bereiche

- /
- /var
- /var/log
- /tmp
- /home
- Backup-Ziele
- Datenbank- oder Anwendungsdaten
- externe Datenträger

## Sicheres Verhalten bei vollem Dateisystem

- keine unbekannten Systemdateien löschen
- keine Paketdatenbanken löschen
- keine Logs löschen, bevor geklärt ist, ob sie für Diagnose benötigt werden
- große Dateien erst identifizieren, dann bewerten
- bei produktiven Systemen Änderung dokumentieren

## Betriebliche Bewertung

Storage-Probleme sind häufig Grundursachen für Folgefehler. Eine schnelle Speicherplatzprüfung gehört deshalb zu den ersten Basisprüfungen bei Update-, Logging-, Backup- und Service-Problemen.

## Merksätze

- df zeigt, wie voll die Regale sind.
- du zeigt, welcher Karton Platz frisst.
- lsblk zeigt die Plattenkarte.
- findmnt zeigt, was wo eingehängt ist.
- Erst finden, dann bewerten, dann bereinigen.
