# Runbook Lab21 – Dienstprobleme schichtenweise diagnostizieren

## Zweck

Dieses Runbook beschreibt einen kompakten Diagnoseablauf für Linux-Dienstprobleme.

## 1. Systemweiten Erstcheck durchführen

Einsatzfall:

- Lage unklar
- Server nach Reboot prüfen
- allgemeine Störungsmeldung

Befehl:

systemctl --failed

Bewertung:

- 0 loaded units listed = keine fehlgeschlagene systemd-Unit
- Einträge vorhanden = betroffene Units gezielt prüfen

## 2. Konkreten Dienst prüfen

Befehle:

systemctl is-active DIENST
systemctl is-enabled DIENST

Bei Auffälligkeit:

systemctl status DIENST --no-pager

## 3. Port und Bindung prüfen

Befehl:

ss -tulpn | grep -Ei ':(PORT)\b'

Bewertung:

| Bindung | Bedeutung |
|---|---|
| 127.0.0.1:PORT | nur lokal |
| [::1]:PORT | nur lokal per IPv6 |
| 0.0.0.0:PORT | alle IPv4-Adressen |
| [::]:PORT | alle IPv6-Adressen |
| 192.168.x.x:PORT | konkrete LAN-Adresse |

## 4. Zugriff testen

Lokaler Test:

curl -I --max-time 3 http://127.0.0.1:PORT

LAN-Test:

curl -I --max-time 3 http://SERVER-IP:PORT

## 5. Firewall prüfen

Befehl:

sudo ufw status numbered

Wichtig:

Nur aktiv eingetragene Regeln sind echte Freigaben. Ein UFW-Profil ist nicht automatisch eine offene Regel.

## 6. Logs gezielt lesen

Dienstbezogen:

journalctl -u DIENST -b -n 30 --no-pager

Nur Warnungen und Fehler:

journalctl -u DIENST -b -p warning -n 30 --no-pager

Systemweite Fehler:

journalctl -b -p err -n 30 --no-pager

## 7. Lograuschen reduzieren

| Filter | Wirkung |
|---|---|
| -u DIENST | nur ein bestimmter Dienst |
| -b | nur aktueller Boot |
| -p err | Fehler und kritischer |
| -p warning | Warnungen und Fehler |
| -n 30 | Ausgabe begrenzen |
| --no-pager | direkte Terminalausgabe |

## 8. Kurzablauf

Unklar?
→ systemctl --failed

Dienst bekannt?
→ systemctl is-active DIENST

Dienst aktiv, aber nicht erreichbar?
→ ss → curl lokal → curl LAN → ufw

Ursache gesucht?
→ journalctl -u DIENST -b -n 30

Zu viel Ausgabe?
→ -u, -b, -p, -n nutzen

## Abschlussregel

Erst prüfen, dann ändern.
Schichtweise denken schlägt Aktionismus.
