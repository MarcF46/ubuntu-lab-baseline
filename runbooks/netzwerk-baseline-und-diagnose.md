# Runbook – Netzwerk-Baseline und Diagnose

## Zweck

Dieses Runbook beschreibt eine strukturierte Basisprüfung für Netzwerkprobleme auf einem Linux-System. Geprüft werden IP-Adressen, Netzwerkschnittstellen, Default Route, DNS-Auflösung, externe Erreichbarkeit und lokal offene Ports.

## Typisches Betriebsszenario

Ein Dienst läuft lokal, ist aber nicht erreichbar. Vor tieferer Fehlersuche wird geprüft, ob das System selbst korrekt im Netzwerk steht und ob Name, Route, Verbindung und Portzustand plausibel sind.

## Begriffe

- IP-Adresse: Netzwerkadresse eines Systems.
- Interface: Netzwerkschnittstelle, zum Beispiel Ethernet oder WLAN.
- Default Route: Standardweg aus dem lokalen Netzwerk heraus.
- Gateway: Router, über den andere Netze erreicht werden.
- DNS: Domain Name System, übersetzt Namen wie ubuntu.com in IP-Adressen.
- Port: logische Tür eines Dienstes, zum Beispiel SSH auf Port 22.
- TCP: verbindungsorientiertes Netzwerkprotokoll.
- UDP: verbindungsloses Netzwerkprotokoll.
- Loopback: lokale Selbstadresse, meistens 127.0.0.1.

## Sicherer Diagnoseweg

1. Netzwerkschnittstellen prüfen.
2. IP-Adressen prüfen.
3. Default Route prüfen.
4. DNS-Auflösung prüfen.
5. Erreichbarkeit per IP prüfen.
6. Erreichbarkeit per Domain prüfen.
7. Lokal offene Ports prüfen.
8. Dienststatus und Firewall ergänzend prüfen.

## 1. Schnittstellen und IP-Adressen prüfen

Basisbefehle:

    ip -brief addr
    ip addr

Bewertung:

- lo ist das Loopback-Interface und normal.
- Ein aktives Interface sollte UP sein.
- Eine IPv4-Adresse im passenden Netz ist für viele Labs wichtig.
- IPv6 kann zusätzlich vorhanden sein und ist nicht automatisch ein Fehler.
- DOWN-Interfaces sind nicht kritisch, wenn sie nicht genutzt werden.

## 2. Default Route prüfen

Basisbefehl:

    ip route

Bewertung:

- Eine default-Route zeigt, wohin Pakete für externe Ziele gehen.
- Fehlt die default-Route, sind externe Ziele meist nicht erreichbar.
- Das Interface der default-Route ist das primäre Ausgangsinterface.
- Das Gateway ist typischerweise der Router.

## 3. DNS-Konfiguration prüfen

Basisbefehle:

    resolvectl dns
    resolvectl domain
    resolvectl status
    ls -l /etc/resolv.conf
    sed -n '1,80p' /etc/resolv.conf

Bewertung:

- systemd-resolved nutzt oft 127.0.0.53 als lokalen DNS-Stub.
- Die echten DNS-Server stehen in resolvectl status.
- Eine lokale Suchdomain wie fritz.box ist in Heim-/Lab-Netzen normal.
- DNS-Probleme zeigen sich oft dadurch, dass IP-Ziele erreichbar sind, Namen aber nicht.

## 4. Namensauflösung prüfen

Basisbefehle:

    getent hosts ubuntu.com
    getent hosts github.com

Bewertung:

- getent nutzt die systemweite Namensauflösung.
- Erfolgreiche Ausgabe bedeutet, dass DNS grundsätzlich funktioniert.
- Mehrere IPs für einen Namen sind normal.
- IPv6-Antworten sind nicht automatisch ein Problem.

## 5. Erreichbarkeit per IP prüfen

Basisbefehl:

    ping -c 3 1.1.1.1

Bewertung:

- Erfolgreicher Ping auf eine IP zeigt grundlegende externe Erreichbarkeit.
- Wenn IP-Ping funktioniert, aber Domain-Ping nicht, ist DNS verdächtig.
- Manche Netze oder Ziele blockieren ICMP. Ein fehlgeschlagener Ping ist daher nicht allein beweisend.

## 6. Erreichbarkeit per Domain prüfen

Basisbefehl:

    ping -c 3 ubuntu.com

Bewertung:

- Erfolgreicher Domain-Ping zeigt DNS plus Netzwerkpfad.
- Wenn getent funktioniert, aber ping nicht, kann ICMP blockiert sein.
- Wenn getent nicht funktioniert, liegt DNS-Verdacht nahe.

## 7. Lokale offene Ports prüfen

Basisbefehl:

    ss -tuln

Bewertung:

- TCP LISTEN zeigt lokal lauschende TCP-Dienste.
- UDP UNCONN zeigt lokal gebundene UDP-Sockets.
- Port 22 ist typisch für SSH.
- Port 53 auf 127.0.0.53 oder 127.0.0.54 ist typisch für lokale DNS-Resolver.
- Port 631 ist häufig CUPS bzw. Druckdienst.
- Offene Ports müssen fachlich erklärt werden können.

## 8. Dienststatus ergänzend prüfen

Beispiel für SSH:

    systemctl status ssh --no-pager -l
    journalctl -u ssh --since "1 hour ago" --no-pager
    ss -tln | grep ':22'

Bewertung:

- Ein Dienst kann active sein, aber nur auf localhost lauschen.
- Ein Dienst kann laufen, aber durch Firewall oder falsche Bind-Adresse nicht erreichbar sein.
- Ports zeigen, ob ein Dienst lokal überhaupt zuhört.

## Typische Fehlerbilder

### Keine IP-Adresse

Mögliche Ursachen:

- Kabel getrennt.
- WLAN nicht verbunden.
- DHCP nicht erreichbar.
- Interface deaktiviert.
- NetworkManager-Problem.

Erste Prüfung:

    ip -brief addr
    nmcli device status
    journalctl -u NetworkManager --since "1 hour ago" --no-pager

### Keine Default Route

Mögliche Ursachen:

- DHCP-Konfiguration unvollständig.
- Gateway nicht gesetzt.
- falsches Interface aktiv.
- Netzwerkprofil fehlerhaft.

Erste Prüfung:

    ip route
    resolvectl status

### DNS funktioniert nicht

Mögliche Ursachen:

- DNS-Server nicht erreichbar.
- falsche resolv.conf.
- systemd-resolved Problem.
- Router/DNS-Forwarder gestört.

Erste Prüfung:

    getent hosts ubuntu.com
    resolvectl status
    ping -c 3 1.1.1.1

### IP erreichbar, Domain nicht

Wahrscheinliche Ursache:

- DNS-Problem.

Erste Prüfung:

    ping -c 3 1.1.1.1
    getent hosts ubuntu.com
    resolvectl status

### Dienst läuft, ist aber nicht erreichbar

Mögliche Ursachen:

- Dienst lauscht nicht auf erwartetem Port.
- Dienst lauscht nur auf localhost.
- Firewall blockiert.
- falsche IP oder falscher Port.
- Routingproblem zwischen Client und Server.

Erste Prüfung:

    systemctl status <dienstname> --no-pager -l
    ss -tuln
    ip addr
    ip route

## Sicheres Verhalten

- Netzwerkdaten mit IPs und MAC-Adressen nicht unbedacht öffentlich dokumentieren.
- Erst lokale Konfiguration prüfen, dann externe Erreichbarkeit.
- DNS und Routing getrennt bewerten.
- Ports immer mit Dienst und Risiko einordnen.
- Bei produktiven Systemen Firewall- und Change-Regeln beachten.

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Prüfung mit ip, resolvectl, getent, ping und ss.

In Produktion sollten Netzwerkzustand, DNS-Erreichbarkeit, Portzustände, Firewall-Regeln und Service-Erreichbarkeit überwacht und dokumentiert werden. Zusätzlich wären zentrale Logs, Monitoring, Alerting und klare Eskalationswege sinnvoll.

## Merksätze

- IP zeigt, wer das System im Netzwerk ist.
- Route zeigt, wohin Pakete gehen.
- DNS übersetzt Namen in Adressen.
- Ports zeigen, welche Türen lokal offen sind.
- Erst IP, dann Route, dann DNS, dann Port.
- Wenn der Dienst läuft, aber niemand ihn erreicht, beginnt die Netzwerkdiagnose.
