# Incident Card Lab24 – CUPS-Webinterface nur lokal erreichbar

## Symptom

Das CUPS-Webinterface ist über das LAN nicht erreichbar.

Lokal auf dem Ubuntu-Rechner funktioniert der Zugriff.

## Betroffene Schichten

- Dienststatus
- Portbindung / Listen-Adresse
- CUPS-Konfiguration
- Firewall-Regeln
- LAN-Erreichbarkeit

## Beobachtete Befunde

CUPS ist aktiv.

CUPS lauscht auf:

- 127.0.0.1:631
- [::1]:631

SSH lauscht auf:

- 0.0.0.0:22
- [::]:22

UFW ist aktiv und erlaubt:

- 22/tcp
- 22/tcp IPv6

Für CUPS Port 631 besteht keine aktive UFW-Freigabe.

## Wahrscheinliche Ursache

CUPS lauscht nur auf Loopback-Adressen.

Dadurch ist das Webinterface nur lokal auf dem Ubuntu-Rechner erreichbar.

Zusätzlich ist Port 631 in UFW nicht für eingehenden LAN-Zugriff freigegeben.

## Bewertung

Kein Hinweis auf einen CUPS-Dienstausfall.

Der Dienst läuft, ist aber aktuell nicht als LAN-Dienst konfiguriert oder firewallseitig freigegeben.

## Nächster Schritt

CUPS-Konfiguration und offizielle CUPS-Dokumentation prüfen.

Falls LAN-Zugriff fachlich gewünscht ist, Änderung kontrolliert planen:

1. Listen-Adresse prüfen
2. Zugriffskonfiguration prüfen
3. Firewall-Regel prüfen
4. lokalen Test durchführen
5. LAN-Test durchführen
6. Rollback-Möglichkeit dokumentieren

## Merksatz

Aktiver Dienst bedeutet nicht automatisch erreichbarer Dienst.

Port vorhanden bedeutet nicht automatisch LAN-erreichbar.

Entscheidend ist, auf welcher Adresse der Dienst lauscht.
