# Lab21b – SSH vs. CUPS: Port, Bindung und Firewall

## Ziel

SSH und CUPS wurden verglichen, um Dienststatus, Portbindung und Firewall-Freigabe getrennt zu bewerten.

## Beobachtung

SSH war aktiv und lauschte auf:

- 0.0.0.0:22
- [::]:22

CUPS war aktiv und lauschte auf:

- 127.0.0.1:631
- [::1]:631

## Bewertung SSH

SSH lauscht auf allen IPv4- und IPv6-Adressen des Rechners.

Das bedeutet:

SSH ist grundsätzlich netzwerkfähig erreichbar, sofern Firewall und Netzwerkpfad dies erlauben.

## Bewertung CUPS

CUPS lauscht nur auf Loopback-Adressen.

Das bedeutet:

CUPS ist nur lokal auf dem Rechner erreichbar. Andere Geräte im LAN erreichen dadurch nicht dieses CUPS-Webinterface.

## Adressen richtig deuten

| Adresse | Bedeutung |
|---|---|
| 127.0.0.1 | IPv4-Loopback, nur dieser Rechner |
| ::1 | IPv6-Loopback, nur dieser Rechner |
| 0.0.0.0 | alle IPv4-Adressen des Rechners |
| :: | alle IPv6-Adressen des Rechners |

## UFW-Bewertung

UFW erlaubte nur:

- 22/tcp
- 22/tcp IPv6

Damit war SSH firewallseitig erlaubt. CUPS war firewallseitig nicht erlaubt.

## Merksatz

0.0.0.0 und :: bedeuten netzwerkfähig.
127.0.0.1 und ::1 bedeuten nur lokal.
Loopback ist nicht LAN.
