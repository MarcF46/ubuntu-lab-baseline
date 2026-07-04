# Incident Card Lab21 – CUPS lokal erreichbar, aber nicht im LAN

## Symptom

CUPS war lokal erreichbar, aber über die LAN-Adresse nicht erreichbar.

## Lokaler Test

curl -I --max-time 3 http://127.0.0.1:631

Ergebnis:

HTTP/1.1 200 OK

## LAN-Test

curl -I --max-time 3 http://192.168.178.25:631

Ergebnis:

Failed to connect

## Dienststatus

systemctl is-active cups

Ergebnis:

active

## Portbindung

ss -tulpn | grep -Ei ':(631)\b'

Ergebnis:

127.0.0.1:631
[::1]:631

## Firewallstatus

sudo ufw status numbered

Bewertung:

Nur SSH Port 22 war freigegeben. CUPS Port 631 war nicht freigegeben.

## Ursache

CUPS lauschte nur auf Loopback-Adressen:

- 127.0.0.1
- ::1

Damit war CUPS nur auf dem Rechner selbst erreichbar.

## Bewertung

Kein CUPS-Ausfall.
Primäre Ursache: Dienstbindung nur lokal.
Zusätzlich: UFW erlaubt Port 631 nicht.

## Merksatz

Lokal erreichbar heißt nicht im LAN erreichbar.
Loopback ist nicht LAN.
