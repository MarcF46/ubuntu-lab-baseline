# systemd / SSH-Service Health-Check - Kurzbewertung

## Ausgangslage

Für Lab 03 wurde ein wiederholbarer Health-Check für `ssh.service` erstellt.

Das Skript liegt unter:

    scripts/check-systemd-ssh.sh

Der vollständige Rohoutput wurde privat abgelegt, da Service-Logs lokale Systeminformationen enthalten können.

## Technischer Nachweis

Der Health-Check prüft:

- ob `ssh.service` aktiv ist
- ob `ssh.service` für den Systemstart aktiviert ist
- ob die Systemuhr synchronisiert ist
- ob der NTP-Dienst aktiv ist
- ob SSH-Logs über `journalctl` abrufbar sind

Der Lauf wurde erfolgreich abgeschlossen.

    Ergebnis: systemd / SSH Service Check erfolgreich
    Exit-Code: 0

## Betriebliche Bewertung

Der SSH-Dienst befindet sich in einem gesunden Betriebszustand. Die Prüfung ist wiederholbar und eignet sich als einfacher manueller Health-Check für Lab- und Junior-Admin-Situationen.

## Nächster professioneller Schritt

Für produktionsnahe Umgebungen wäre ein zentralisiertes Monitoring sinnvoll, das fehlgeschlagene systemd Units, Service-Ausfälle und Zeitsynchronisation automatisch überwacht.
