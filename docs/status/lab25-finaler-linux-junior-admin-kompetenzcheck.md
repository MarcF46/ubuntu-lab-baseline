# Lab25 – Finaler Linux Junior Admin Kompetenzcheck

## Status

Der finale Linux-Junior-Admin-Kompetenzcheck wurde durchgeführt.

## Ziel

Ziel war die technische Bewertung eines Linux-Systems anhand eines kompakten Healthchecks und einer strukturierten Admin-Einschätzung.

## Geprüfte Schichten

1. Git- und Repository-Status
2. Systembasis
3. systemd-Status
4. Dienststatus
5. Port- und Bindungsstatus
6. Firewall-Regeln
7. Ressourcen
8. Error-Level-Logs
9. Gesamtbewertung

## Ergebnis

Das System ist stabil und betriebsbereit.

Git ist synchron mit origin/main.

systemd zeigt keine fehlgeschlagenen Units.

SSH, CUPS und UFW sind aktiv und enabled.

SSH lauscht netzwerkfähig und ist firewallseitig erlaubt.

CUPS läuft, ist aber nur lokal gebunden und nicht für LAN-Zugriff freigegeben.

Speicherplatz und RAM sind unkritisch.

## Auffälligkeiten

Die aktuellen Error-Level-Logs enthalten Meldungen aus folgenden Bereichen:

- ACPI / BIOS
- hp-wmi / platform_profile
- GNOME / Desktop-Kontext

## Bewertung

Die Auffälligkeiten deuten aktuell nicht auf einen akuten Ausfall der geprüften Basisdienste hin.

Es besteht kein unmittelbarer Reparaturbedarf.

## Beobachten

Wiederkehrende Hardware-, Firmware- oder Desktop-Meldungen sollten beobachtet werden, falls funktionale Probleme auftreten.

## Eingreifen

Ein Eingriff wäre erforderlich bei:

- konkretem Symptom
- failed systemd Unit
- Dienst-Ausfall
- Ressourcenengpass
- Sicherheitsereignis
- wiederholbarer funktionaler Störung

## Abschlusskompetenz

Die Linux-Junior-Admin-Baseline ist tragfähig.

Die wichtigste gefestigte Kompetenz ist die schichtweise Diagnose:

Systemstatus
→ Dienststatus
→ Port und Bindung
→ Firewall
→ Client- und Netzwerkpfad
→ Logs
→ Konfiguration

## Merksatz

Nicht jede Logzeile ist ein Problem.

Erst Kontext, Schicht und Auswirkung machen daraus einen Befund.
