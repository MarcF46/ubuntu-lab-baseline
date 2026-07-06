# Lab23 – Linux Admin Abschluss-Healthcheck

## Ziel

Dieser Healthcheck bewertet den technischen Zustand des Ubuntu-Lab-Systems am Ende der Linux-Admin-Baseline.

## Systemkontext

- Hostname: ubuntu-lab
- Betriebssystem: Ubuntu 26.04 LTS
- Kernel: Linux 7.0.0-27-generic
- Hardware: HP 250 15.6 inch G9 Notebook PC
- Architektur: x86-64

## Systemd-Status

Ergebnis:

- Keine fehlgeschlagenen systemd-Units
- Ausgabe: 0 loaded units listed

Bewertung:

Das System zeigt auf systemd-Ebene keinen akuten Dienstfehler.

## Wichtige Dienste

Geprüfte Dienste:

- ssh
- cups
- ufw

Ergebnis:

- alle drei Dienste sind aktiv
- alle drei Dienste sind enabled

Bewertung:

Die geprüften Basisdienste laufen und sind für den Systemstart aktiviert.

## Port- und Bindungsbewertung

SSH:

- 0.0.0.0:22
- [::]:22

Bewertung:

SSH lauscht netzwerkfähig auf IPv4 und IPv6.

CUPS:

- 127.0.0.1:631
- [::1]:631

Bewertung:

CUPS lauscht nur lokal auf Loopback-Adressen.

## Firewall

UFW ist aktiv.

Aktiv erlaubte Regeln:

- 22/tcp
- 22/tcp IPv6

Bewertung:

SSH ist firewallseitig freigegeben. CUPS ist nicht für eingehenden Netzwerkzugriff freigegeben.

## Ressourcen

Speicherplatz:

- Root-Dateisystem: 150G Gesamtgröße
- Belegt: 18G
- Nutzung: 13 Prozent

RAM:

- Gesamt: 14 GiB
- Verfügbar: 9,7 GiB
- Swap: 4,0 GiB, ungenutzt

Bewertung:

Speicherplatz und RAM sind im Lab-Kontext unkritisch.

## Error-Logs

Beobachtete Meldungstypen:

- ACPI BIOS Errors
- hp-wmi platform_profile Meldungen
- bluetoothd Meldungen
- GNOME/GDM Meldungen
- snap-userd Scope-Meldung
- polkitd Meldung
- USB EMI Hinweis

Bewertung:

Die Meldungen sind aktuell als Hardware-, Firmware-, Desktop- oder Peripherie-Kontext einzuordnen. Es liegt kein direkter Hinweis auf einen SSH-, CUPS-, UFW- oder Git-Ausfall vor.

## Git-Zustand

Ergebnis:

- main folgt origin/main
- kein voraus
- kein hinterher

Bewertung:

Lokales Repository und GitHub-Remote sind synchron.

## Abschlussbewertung

Das Ubuntu-Lab-System ist für weitere Lern- und Administrationsaufgaben betriebsbereit.

Technischer Gesamtstatus:

- systemd sauber
- Basisdienste aktiv
- Firewall aktiv
- SSH erreichbar konfiguriert
- CUPS lokal begrenzt
- Ressourcen unkritisch
- Git synchron
