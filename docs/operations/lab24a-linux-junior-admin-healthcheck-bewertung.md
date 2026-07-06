# Lab24a – Linux Junior Admin Healthcheck Bewertung

## Status

Der Linux-Admin-Healthcheck wurde durchgeführt.

## Geprüft

- Git-Status und GitHub-Synchronität
- Systembasis mit hostnamectl
- Uptime und Load
- fehlgeschlagene systemd-Units
- Status und Autostart von ssh, cups und ufw
- Portbindung von SSH und CUPS
- UFW-Regelstatus
- Speicherplatz
- RAM und Swap
- aktuelle Error-Level-Logs

## Ergebnis

Das System ist grundsätzlich betriebsbereit.

Git ist synchron mit origin/main.

systemd zeigt keine fehlgeschlagenen Units.

SSH, CUPS und UFW sind aktiv und enabled.

SSH lauscht netzwerkfähig auf Port 22.

CUPS lauscht nur lokal auf Port 631.

UFW ist aktiv und erlaubt SSH über Port 22.

Speicherplatz und RAM sind unkritisch.

## Auffälligkeiten

Die Error-Level-Logs enthalten Meldungen aus folgenden Bereichen:

- ACPI / BIOS
- hp-wmi / platform_profile
- Bluetooth
- GNOME / snap-userd
- polkit
- USB EMI Hinweis
- sudo timeout durch nicht abgeschlossene Authentifizierung

## Bewertung

Die Auffälligkeiten deuten aktuell nicht auf einen akuten Ausfall der geprüften Basisdienste hin.

Der sudo timeout war kein UFW-Fehler, sondern ein fehlgeschlagener Prüfschritt. Die Firewall-Schicht wurde anschließend erfolgreich nachgetestet.

## Nächster Schritt

Keine direkte Reparatur erforderlich.

Wiederkehrende Hardware-, Bluetooth- oder USB-Meldungen sollten beobachtet werden, falls funktionale Probleme auftreten.
