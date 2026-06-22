# Troubleshooting-Karte – Netzwerk-Baseline und Diagnose

## Zweck

Diese Karte hilft bei typischen Netzwerkproblemen auf Linux-Systemen: keine IP-Adresse, fehlende Default Route, DNS-Probleme, fehlende Erreichbarkeit oder Dienste, die lokal laufen, aber von außen nicht erreichbar sind.

## Sofortprüfung

- ip -brief addr
- ip route
- resolvectl status
- getent hosts ubuntu.com
- ping -c 3 1.1.1.1
- ping -c 3 ubuntu.com
- ss -tuln
- systemctl --failed --no-pager

## Symptom 1 – Keine IP-Adresse vorhanden

Mögliche Ursachen:

- Netzwerkkabel getrennt.
- WLAN nicht verbunden.
- DHCP nicht erreichbar.
- Interface deaktiviert.
- NetworkManager-Profil fehlerhaft.
- Treiber- oder Hardwareproblem.

Prüfung:

- ip -brief addr
- ip addr
- nmcli device status
- journalctl -u NetworkManager --since "1 hour ago" --no-pager

Bewertung:

- Ein Interface ohne IP kann keine normale Netzwerkkommunikation im jeweiligen Netz durchführen.
- DOWN ist unkritisch, wenn das Interface nicht genutzt wird.
- Bei erwartetem aktivem Interface ist DOWN oder NO-CARRIER ein wichtiger Hinweis.

## Symptom 2 – Default Route fehlt

Mögliche Ursachen:

- DHCP hat kein Gateway geliefert.
- Gateway ist falsch konfiguriert.
- falsches Netzwerkprofil aktiv.
- Interface ist nicht korrekt verbunden.
- Routing wurde manuell verändert.

Prüfung:

- ip route
- ip -brief addr
- nmcli connection show
- resolvectl status

Bewertung:

- Ohne Default Route sind externe Ziele meist nicht erreichbar.
- Lokale Ziele im gleichen Subnetz können trotzdem funktionieren.
- Fehlt nur die Default Route, ist DNS nicht automatisch die Ursache.

## Symptom 3 – IP-Ziel erreichbar, Domain nicht erreichbar

Wahrscheinliche Ursache:

- DNS-Problem.

Prüfung:

- ping -c 3 1.1.1.1
- getent hosts ubuntu.com
- resolvectl dns
- resolvectl status
- ls -l /etc/resolv.conf
- sed -n '1,80p' /etc/resolv.conf

Bewertung:

- Funktioniert IP, aber keine Namensauflösung, liegt der Schwerpunkt bei DNS.
- Bei systemd-resolved ist 127.0.0.53 als lokaler Stub-Resolver normal.
- Die echten DNS-Server werden über resolvectl status geprüft.

## Symptom 4 – DNS funktioniert, aber ping schlägt fehl

Mögliche Ursachen:

- ICMP wird blockiert.
- Ziel blockiert Ping.
- Firewall oder Router filtert ICMP.
- IPv6-Pfad ist gestört.
- Ziel ist temporär nicht erreichbar.

Prüfung:

- getent hosts ubuntu.com
- ping -c 3 ubuntu.com
- ping -4 -c 3 ubuntu.com
- ping -6 -c 3 ubuntu.com

Bewertung:

- Ein fehlgeschlagener Ping beweist nicht allein, dass ein Dienst nicht erreichbar ist.
- DNS und ICMP müssen getrennt bewertet werden.
- Für Dienste sind Porttests wichtiger als Ping.

## Symptom 5 – Dienst läuft, ist aber nicht erreichbar

Mögliche Ursachen:

- Dienst lauscht nicht.
- Dienst lauscht nur auf 127.0.0.1.
- falscher Port wird getestet.
- Firewall blockiert.
- Routing zwischen Client und Server fehlt.
- Dienst ist active, aber fehlerhaft konfiguriert.

Prüfung:

- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager
- ss -tuln
- ip addr
- ip route

Bewertung:

- Ein active-Dienst ist nicht automatisch erreichbar.
- Entscheidend ist, ob der Dienst auf der richtigen Adresse und dem richtigen Port lauscht.
- 127.0.0.1 bedeutet nur lokal erreichbar.
- 0.0.0.0 bedeutet auf allen IPv4-Adressen lauschend.
- [::] bedeutet auf IPv6-Adressen lauschend.

## Symptom 6 – Port ist offen, aber Zugriff scheitert

Mögliche Ursachen:

- Firewall blockiert zwischen Client und Server.
- Dienst erwartet TLS oder bestimmtes Protokoll.
- Zugriff erfolgt auf falsche IP.
- Client befindet sich in anderem Netz.
- Dienst nimmt Verbindung an, lehnt Anwendungsebene aber ab.

Prüfung:

- ss -tuln
- systemctl status <dienstname> --no-pager -l
- journalctl -u <dienstname> --since "1 hour ago" --no-pager
- ip route

Bewertung:

- Offener Port lokal beweist nicht automatisch externe Erreichbarkeit.
- Zwischen lokalem Port und externem Zugriff liegen Firewall, Routing und Netzwerkpfad.
- In Produktion zusätzlich Load Balancer, Security Groups oder Netzwerksegmentierung berücksichtigen.

## Symptom 7 – Mehrere Interfaces sichtbar

Mögliche Ursachen:

- Ethernet und WLAN vorhanden.
- USB-Netzwerkadapter angeschlossen.
- virtuelle Interfaces durch Container, VPN oder Virtualisierung.
- nicht genutzte Interfaces sind DOWN.

Prüfung:

- ip -brief addr
- ip route
- nmcli device status

Bewertung:

- Mehrere Interfaces sind normal.
- Wichtig ist, welches Interface die Default Route nutzt.
- Falsche Default Route kann zu schwer nachvollziehbaren Verbindungsproblemen führen.

## Typischer Anfängerfehler

DNS, Routing und Portzustand werden vermischt. Dadurch wird beispielsweise ein DNS-Problem vermutet, obwohl eigentlich der Dienst nicht lauscht, oder ein Firewallproblem vermutet, obwohl die Default Route fehlt.

## Sicherer Diagnoseweg

1. IP-Konfiguration prüfen.
2. Default Route prüfen.
3. DNS-Auflösung prüfen.
4. Erreichbarkeit per IP prüfen.
5. Erreichbarkeit per Domain prüfen.
6. Lokale Ports prüfen.
7. Dienststatus und Logs prüfen.
8. Firewall und externe Erreichbarkeit bewerten.

## Sichere Maßnahmen

- IP- und MAC-Adressen nicht unbedacht öffentlich dokumentieren.
- Keine Firewall-Regeln blind ändern.
- Erst lokale Zustände prüfen, dann externe Pfade.
- Dienst, Port und Bind-Adresse gemeinsam bewerten.
- Bei produktiven Systemen Änderungen dokumentieren und freigeben lassen.

## Lab-vs-Production-Einordnung

Im Lab reicht die manuelle Diagnose mit ip, resolvectl, getent, ping und ss.

In Produktion sind zusätzliche Ebenen relevant: VLANs, Firewalls, VPN, Proxy, Load Balancer, DNS-Zonen, Security Groups, Network Security Groups, Monitoring und zentrale Logs.

## Merksätze

- IP zeigt, wer das System im Netzwerk ist.
- Route zeigt, wohin Pakete gehen.
- DNS übersetzt Namen in Adressen.
- Ports zeigen, welche Türen lokal offen sind.
- Erst IP, dann Route, dann DNS, dann Port.
- Wenn IP geht, aber Name nicht: DNS prüfen.
- Wenn Name geht, aber Dienst nicht: Port und Dienst prüfen.
- Wenn der Dienst läuft, aber niemand ihn erreicht, beginnt die Netzwerkdiagnose.
