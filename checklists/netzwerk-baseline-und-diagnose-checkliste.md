# Checkliste – Netzwerk-Baseline und Diagnose

## Zweck

Diese Checkliste dient zur schnellen Prüfung grundlegender Netzwerkfunktionen auf einem Linux-System: IP-Adressen, Schnittstellen, Routing, DNS, Erreichbarkeit und offene Ports.

## Basisprüfung

- ip -brief addr ausführen.
- ip addr ausführen.
- ip route ausführen.
- resolvectl status prüfen.
- getent hosts ubuntu.com ausführen.
- ping -c 3 1.1.1.1 ausführen.
- ping -c 3 ubuntu.com ausführen.
- ss -tuln ausführen.

## Schnittstellen prüfen

- Aktives Interface identifizieren.
- Prüfen, ob das erwartete Interface UP ist.
- Prüfen, ob nicht genutzte Interfaces DOWN sind.
- Loopback lo als normalen lokalen Netzwerkadapter einordnen.

## IP-Adressen prüfen

- IPv4-Adresse prüfen.
- IPv6-Adresse prüfen, falls vorhanden.
- Subnetz prüfen.
- Dynamische Adresse als DHCP-Ergebnis einordnen.
- Private Rohdaten mit IP- und MAC-Adressen nicht öffentlich dokumentieren.

## Routing prüfen

- Default Route vorhanden?
- Gateway sichtbar?
- Richtiges Interface für Default Route?
- Lokales Subnetz als direkte Route sichtbar?

Bewertung:

- Ohne Default Route sind externe Ziele meist nicht erreichbar.
- Lokale Kommunikation kann trotzdem funktionieren.
- Falsches Interface in der Default Route kann zu schwer erkennbaren Fehlern führen.

## DNS prüfen

- resolvectl dns prüfen.
- resolvectl domain prüfen.
- resolvectl status prüfen.
- /etc/resolv.conf als Symlink oder Datei prüfen.
- getent hosts ubuntu.com prüfen.
- getent hosts github.com prüfen.

Bewertung:

- DNS funktioniert, wenn Namen zuverlässig aufgelöst werden.
- 127.0.0.53 ist bei systemd-resolved als lokaler Stub-Resolver normal.
- Eine lokale Domain wie fritz.box ist in Heim- und Lab-Netzen erwartbar.

## Erreichbarkeit prüfen

- IP-Ziel mit ping prüfen.
- Domain-Ziel mit ping prüfen.
- Ergebnis von IP-Ping und DNS-Prüfung getrennt bewerten.

Bewertung:

- IP erreichbar, Domain nicht: DNS-Verdacht.
- IP nicht erreichbar, Domain nicht erreichbar: Routing, Gateway, Verbindung oder Firewall prüfen.
- DNS funktioniert, aber ping nicht: ICMP kann blockiert sein.

## Lokale Ports prüfen

- ss -tuln ausführen.
- TCP LISTEN Ports prüfen.
- UDP gebundene Ports prüfen.
- Port 22 als SSH einordnen.
- Port 53 als lokalen DNS-Resolver einordnen, wenn auf 127.0.0.53 oder 127.0.0.54.
- Port 631 als möglichen Druckdienst einordnen.

## Dienstbezogene Prüfung

Bei einem konkreten Dienst zusätzlich prüfen:

- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager
- ss -tuln | grep <port>

Hinweis:

<dienstname> und <port> sind Platzhalter und müssen ersetzt werden.

## Typische Fehlerbilder

- Keine IP-Adresse.
- Interface ist DOWN.
- Default Route fehlt.
- DNS-Auflösung schlägt fehl.
- IP ist erreichbar, Domain aber nicht.
- Dienst läuft, Port lauscht aber nicht.
- Dienst lauscht nur auf localhost.
- Firewall blockiert Zugriff.
- Falsche IP oder falscher Port wird getestet.

## Sicheres Verhalten

- IP- und MAC-Adressen nicht unbedacht öffentlich dokumentieren.
- Routing und DNS getrennt bewerten.
- Portzustände mit Dienst und Risiko einordnen.
- Nicht sofort Firewall-Regeln ändern.
- Erst lokale Diagnose, dann externe Erreichbarkeit prüfen.
- Bei produktiven Systemen Change- und Firewall-Prozesse beachten.

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Netzwerkprüfung. In Produktion sollten Netzwerkkonfiguration, DNS, Gateway, Firewall, offene Ports und Service-Erreichbarkeit überwacht und dokumentiert werden.

## Merksätze

- IP zeigt, wer das System im Netzwerk ist.
- Route zeigt, wohin Pakete gehen.
- DNS übersetzt Namen in Adressen.
- Ports zeigen, welche Türen lokal offen sind.
- Erst IP, dann Route, dann DNS, dann Port.
- Wenn der Dienst läuft, aber niemand ihn erreicht, beginnt die Netzwerkdiagnose.
