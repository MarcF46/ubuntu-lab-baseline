# Lab 07 – Storage Baseline

## Ziel

Im Lab wurde eine erste Storage-Baseline des Ubuntu-Systems erstellt. Geprüft wurden Dateisysteme, Mounts, Blockgeräte, Swap und die Größe wichtiger Ordner.

## Typisches Betriebsszenario

Ein Linux-Server zeigt Update-, Logging- oder Service-Probleme. Eine häufige Ursache ist fehlender Speicherplatz oder ein unerwarteter Mount-/Dateisystemzustand.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab07-storage/lab07-storage-baseline-raw.txt

## Beobachteter Zustand

- Root-Dateisystem: ext4, Größe 150G, belegt 14G, frei 130G, Nutzung 10%
- Home-Dateisystem: ext4, Größe 150G, belegt 14G, frei 130G, Nutzung 10%
- Anzahl erkannter Mountpunkte: 50
- Swap-Zustand: Swap aktiv oder konfiguriert
- Größe /var/log: 65M
- Größe Projektordner: 5.4M

## Betriebliche Bewertung

Die Storage-Baseline dient als Ausgangspunkt für spätere Diagnosefälle. Besonders wichtig sind Root-Dateisystem, Log-Verzeichnis, Mountpunkte und Swap-Zustand.

Wenn ein Dateisystem voll läuft, können Updates fehlschlagen, Logs nicht mehr geschrieben werden und Services unerwartet reagieren. Deshalb gehört Storage-Prüfung zu den ersten Diagnosewegen bei vielen Linux-Problemen.

## Nächster professioneller Schritt

Als nächster Schritt werden typische Storage-Fehlerbilder und Prüfkommandos in einem Runbook dokumentiert.

## Merksätze

- df zeigt, wie voll die Regale sind.
- lsblk zeigt, welche Platten und Partitionen vorhanden sind.
- findmnt zeigt, was wo eingehängt ist.
- du zeigt, welcher Ordner Platz verbraucht.
- Wenn die Platte voll ist, wirken viele andere Dinge kaputt.
