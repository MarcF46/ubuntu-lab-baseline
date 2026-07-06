# Abschlussstatus Lab24 – Linux Junior Admin Abschlussprüfung Teil 1

## Status

Lab24 wurde als technische Abschlussprüfung der Linux-Junior-Admin-Baseline durchgeführt.

## Geprüfte Bereiche

- Git-Status und GitHub-Synchronität
- Systembasis und Uptime
- systemd-Healthcheck
- Dienststatus und Autostart von SSH, CUPS und UFW
- Portbindung und Listen-Adressen
- Firewall-Regeln
- Speicherplatz, RAM und Swap
- aktuelle Error-Level-Logs
- CUPS-Erreichbarkeit und Loopback-Bindung
- OSI-Modell vs. betriebliches Admin-Schichtenmodell

## Ergebnis

Das Ubuntu-Lab-System ist betriebsbereit.

Es wurden keine fehlgeschlagenen systemd-Units festgestellt.

SSH ist aktiv, enabled, netzwerkfähig gebunden und firewallseitig erlaubt.

CUPS ist aktiv und enabled, aber nur lokal auf Loopback-Adressen gebunden.

UFW ist aktiv und erlaubt SSH über Port 22.

Speicherplatz und RAM sind unkritisch.

Git ist mit origin/main synchron.

## Wichtige Erkenntnis

Das OSI-Modell erklärt Netzwerkkommunikation.

Das betriebliche Admin-Schichtenmodell hilft bei der praktischen Fehlersuche im Betrieb.

## Sichere Diagnose-Reihenfolge

1. Systemstatus
2. Dienststatus
3. Port und Bindung
4. Firewall
5. Client- und Netzwerkpfad
6. Logs
7. Konfiguration

## Abschlussbewertung

Die Prüfung zeigt eine stabile Linux-Admin-Baseline.

Die wichtigste Kompetenz ist die schichtweise Eingrenzung von Problemen, bevor Logs oder Konfigurationsdateien im Detail analysiert werden.

## Merksätze

Logs und Konfiguration sind nicht der erste Schritt.

Erst beweisen, auf welcher Schicht das Problem liegt.

Dienst aktiv bedeutet nicht automatisch erreichbar.

Port vorhanden bedeutet nicht automatisch LAN-erreichbar.

Schichtweise Diagnose schlägt Aktionismus.
