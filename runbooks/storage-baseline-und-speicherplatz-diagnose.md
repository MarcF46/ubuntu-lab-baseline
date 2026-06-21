# Runbook – Storage Baseline und Speicherplatz-Diagnose

## Ziel

Dieses Runbook beschreibt die Prüfung von Speicherplatz, Dateisystemen, Mounts, Blockgeräten, Swap und typischen Storage-Risiken auf einem Linux-System.

## Typisches Betriebsszenario

Ein Linux-Server zeigt Update-, Logging-, Backup- oder Service-Probleme. Eine häufige Ursache ist fehlender Speicherplatz, ein unerwarteter Mount-Zustand oder ein volles Log-Verzeichnis.

## Muss wissen

- df zeigt die Auslastung eingehängter Dateisysteme.
- lsblk zeigt Blockgeräte, Partitionen und Dateisysteme.
- findmnt zeigt, was wo eingehängt ist.
- du zeigt, welche Ordner Speicherplatz verbrauchen.
- swapon zeigt aktiven Swap-Speicher.

## Wichtige Befehle

### Dateisysteme prüfen

- df -hT

Bedeutung:

- -h zeigt Größen menschenlesbar an.
- -T zeigt den Dateisystemtyp an, zum Beispiel ext4, vfat, ntfs3 oder tmpfs.

### Blockgeräte prüfen

- lsblk -f

Bedeutung:

- lsblk zeigt Laufwerke, Partitionen und Mountpoints.
- -f zeigt zusätzlich Dateisystem, Label, UUID und Nutzung.

### Mounts prüfen

- findmnt
- findmnt -rno TARGET,SOURCE,FSTYPE,OPTIONS

Bedeutung:

- findmnt zeigt die aktuell eingehängten Dateisysteme.
- TARGET ist der Einhängepunkt.
- SOURCE ist die Quelle, zum Beispiel eine Partition oder ein virtuelles Dateisystem.
- FSTYPE ist der Dateisystemtyp.
- OPTIONS zeigt Mount-Optionen.

### Ordnergrößen prüfen

- du -sh /var/log
- du -sh /home/* 2>/dev/null
- du -sh ./* 2>/dev/null | sort -h

Bedeutung:

- du misst Speicherverbrauch von Ordnern.
- -s fasst zusammen.
- -h zeigt menschenlesbare Größen.
- sort -h sortiert Größen sinnvoll.

### Swap prüfen

- swapon --show
- free -h

Bedeutung:

- Swap ist Auslagerungsspeicher auf Datei oder Partition.
- Swap-Nutzung ist nicht automatisch schlecht, kann aber auf Speicherdruck hinweisen.

## Typische Schwellenwerte

- unter 70 Prozent Nutzung: meist unkritisch
- ab 80 Prozent Nutzung: beobachten und Wachstum prüfen
- ab 90 Prozent Nutzung: aktiv bewerten und bereinigen oder erweitern
- ab 95 Prozent Nutzung: kritisch, besonders bei /, /var, /var/log oder Datenbank-/Backup-Dateisystemen

## Typische Fehlerbilder

- apt kann keine Pakete installieren, weil / voll ist.
- Services starten nicht, weil sie keine temporären Dateien schreiben können.
- Logs fehlen oder brechen ab, weil /var/log voll ist.
- Backups schlagen fehl, weil das Ziel-Dateisystem voll ist.
- Ein erwartetes Laufwerk ist nicht gemountet.
- Eine externe Platte ist fast voll.

## Diagnoseweg bei vollem Dateisystem

1. Dateisystemauslastung prüfen:

- df -hT

2. Betroffenes Dateisystem identifizieren:

- Welcher Mountpoint ist voll?
- Ist /, /var, /home, /tmp oder ein Daten-/Backup-Mount betroffen?

3. Große Ordner finden:

- sudo du -xh / --max-depth=1 2>/dev/null | sort -h
- sudo du -xh /var --max-depth=1 2>/dev/null | sort -h

4. Logs prüfen:

- sudo journalctl --disk-usage
- ls -lh /var/log

5. Erst bewerten, dann löschen:

- keine unbekannten Systemdateien blind entfernen
- keine Paketdatenbanken löschen
- keine Logs löschen, wenn sie für Incident-Analyse benötigt werden

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Storage-Baseline. In Produktion sollte Storage über Monitoring überwacht werden, zum Beispiel mit Schwellwerten für Dateisystemauslastung, Inodes, Log-Wachstum, Backup-Ziel und Mount-Zustand.

## Betriebliche Bewertung

Storage-Probleme wirken oft wie Anwendungs-, Update- oder Service-Probleme. Deshalb gehört die Speicherplatzprüfung zu den ersten Basisprüfungen bei vielen Linux-Incidents.

## Merksätze

- df zeigt, wie voll die Regale sind.
- du zeigt, welcher Karton Platz frisst.
- lsblk zeigt die Plattenkarte.
- findmnt zeigt, was wo eingehängt ist.
- Wenn die Platte voll ist, wirken viele andere Dinge kaputt.
