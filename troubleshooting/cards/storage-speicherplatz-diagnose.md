# Troubleshooting-Karte – Storage und Speicherplatz-Diagnose

## Zweck

Diese Karte hilft bei typischen Storage-Problemen auf Linux-Systemen: volles Dateisystem, stark wachsendes Log-Verzeichnis, fehlender Mount, volle Backup-Platte oder auffällige Swap-Nutzung.

## Typisches Betriebsszenario

Ein Linux-Server zeigt Folgefehler: Updates schlagen fehl, Services starten nicht, Logs werden nicht geschrieben oder Backups brechen ab. Eine mögliche Grundursache ist fehlender Speicherplatz oder ein unerwarteter Mount-Zustand.

## Sofortprüfung

- df -hT
- lsblk -f
- findmnt -rno TARGET,SOURCE,FSTYPE,OPTIONS
- swapon --show
- free -h

## Symptom 1 – Root-Dateisystem / ist fast voll

Typische Folgen:

- apt kann keine Pakete installieren.
- Services können keine temporären Dateien schreiben.
- Logdateien können nicht erweitert werden.
- Anwendungen melden scheinbar unklare Fehler.

Prüfung:

- df -hT /
- sudo du -xh / --max-depth=1 2>/dev/null | sort -h

Bewertung:

- Ab 80 Prozent Nutzung Wachstum beobachten.
- Ab 90 Prozent aktiv bewerten.
- Ab 95 Prozent kritisch behandeln.

## Symptom 2 – /var oder /var/log wächst stark

Typische Ursachen:

- sehr viele Logs
- fehlende oder falsche Logrotation
- wiederholte Servicefehler
- große Journal-Dateien

Prüfung:

- du -sh /var/log
- sudo du -sh /var/log/* 2>/dev/null | sort -h
- sudo journalctl --disk-usage
- journalctl -p warning..alert --since "1 hour ago" --no-pager

Bewertung:

- Logs nicht blind löschen.
- Erst Ursache prüfen.
- Bei Incident-Verdacht Logs sichern.
- Danach Logrotation oder Servicefehler prüfen.

## Symptom 3 – Erwartetes Laufwerk ist nicht gemountet

Typische Folgen:

- Daten landen versehentlich im lokalen Ordner statt auf Daten-/Backup-Platte.
- Backup schreibt auf / statt auf das Ziel-Dateisystem.
- Anwendung findet Datenpfad nicht.

Prüfung:

- lsblk -f
- findmnt
- df -hT
- mount | grep -i "<suchbegriff>"

Bewertung:

- Prüfen, ob das Gerät sichtbar ist.
- Prüfen, ob der Mountpoint existiert.
- Prüfen, ob ein Eintrag in /etc/fstab vorhanden ist.
- Keine produktiven Mounts blind neu einhängen, ohne Abhängigkeiten zu prüfen.

## Symptom 4 – Backup- oder externe Platte ist fast voll

Typische Folgen:

- Backups schlagen fehl.
- Restore-Fähigkeit wird gefährdet.
- Alte Sicherungen verdrängen neue Sicherungen.

Prüfung:

- df -hT
- du -sh /pfad/zum/backup/* 2>/dev/null | sort -h

Bewertung:

- Backup-Ziel ab 80 bis 90 Prozent aktiv beobachten.
- Aufbewahrungsregeln prüfen.
- Nicht blind Backups löschen, bevor Restore- und Aufbewahrungsanforderungen geklärt sind.

## Symptom 5 – Swap wird stark genutzt

Bedeutung:

- Swap-Nutzung ist nicht automatisch ein Fehler.
- Starke oder dauerhaft steigende Swap-Nutzung kann auf Speicherdruck hinweisen.

Prüfung:

- swapon --show
- free -h
- top
- htop

Bewertung:

- Prüfen, welche Prozesse Speicher verbrauchen.
- Nicht sofort Swap deaktivieren.
- Bei Servern Workload, RAM, Dienste und Limits bewerten.

## Symptom 6 – Snap-loop-Geräte zeigen 100 Prozent Nutzung

Bedeutung:

- Snap-Pakete werden oft als read-only squashfs-Loop-Dateisysteme eingebunden.
- 100 Prozent Nutzung bei diesen Loop-Geräten ist normalerweise erwartbar.

Prüfung:

- df -hT
- lsblk -f

Bewertung:

- Nicht mit vollem Root-Dateisystem verwechseln.
- Entscheidend ist die Nutzung von /, /var, /home und relevanten Daten-/Backup-Mounts.

## Typischer Anfängerfehler

Bei vollem Dateisystem werden wahllos Dateien gelöscht. Dadurch können Logs, Paketdatenbanken, Anwendungsdaten oder wichtige Nachweise verloren gehen.

## Sicherer Diagnoseweg

1. Dateisystemauslastung prüfen.
2. Betroffenen Mountpoint identifizieren.
3. Große Ordner finden.
4. Ursache bewerten.
5. Bei Bedarf Logs oder Daten sichern.
6. Erst danach gezielt bereinigen oder erweitern.

## Betriebliche Einordnung

Storage-Probleme sind oft Grundursachen für Folgefehler. Ein voller oder fehlender Mount kann Updates, Logs, Backups, Datenbanken und Services gleichzeitig beeinflussen.

## Merksätze

- df zeigt, wie voll die Regale sind.
- du zeigt, welcher Karton Platz frisst.
- findmnt zeigt, welches Regal wirklich eingehängt ist.
- Backup-Platte voll ist kein Schönheitsfehler, sondern Betriebsrisiko.
- Erst finden, dann bewerten, dann bereinigen.
