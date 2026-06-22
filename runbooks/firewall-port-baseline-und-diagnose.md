# Runbook – Firewall-, Port- und Zugriffskontrolle

## Zweck

Dieses Runbook beschreibt eine sichere Basisprüfung für Firewall-Status, lokal lauschende Ports, SSH-Erreichbarkeit und Zugriffskontrolle auf einem Ubuntu-Linux-System.

## Typisches Betriebsszenario

Ein Dienst läuft auf einem Server, ist aber nicht erreichbar oder unerwartet erreichbar. Vor Änderungen an Firewall-Regeln wird geprüft, welche Dienste lokal lauschen, ob eine Firewall aktiv ist und ob kritische Verwaltungszugänge wie SSH geschützt bleiben.

## Begriffe

- Firewall: Regelwerk, das Netzwerkzugriffe erlaubt oder blockiert.
- UFW: Uncomplicated Firewall, einfache Firewall-Verwaltung unter Ubuntu.
- nftables: moderne Linux-Firewall-Technik im Kernel.
- Port: logische Tür eines Dienstes.
- Inbound: eingehender Zugriff auf das System.
- Outbound: ausgehender Zugriff vom System nach außen.
- TCP: verbindungsorientiertes Netzwerkprotokoll.
- UDP: verbindungsloses Netzwerkprotokoll.
- SSH: Secure Shell, verschlüsselter Remote-Zugriff auf Linux-Systeme.
- Bind-Adresse: Adresse, auf der ein Dienst lauscht, zum Beispiel 127.0.0.1 oder 0.0.0.0.

## Sicherer Diagnoseweg

1. Firewall-Werkzeug prüfen.
2. Firewall-Status prüfen.
3. Lokal lauschende Ports erfassen.
4. SSH-Dienst und SSH-Port prüfen.
5. nftables-Regeln grob prüfen.
6. Ports fachlich einem Dienst zuordnen.
7. Risiko bewerten.
8. Erst danach Regeln ändern.

## 1. UFW prüfen

Basisbefehle:

    command -v ufw
    sudo ufw status verbose

Bewertung:

- UFW vorhanden bedeutet nur, dass das Werkzeug installiert ist.
- UFW inaktiv bedeutet, dass UFW aktuell keine Filterregeln durchsetzt.
- UFW aktiv bedeutet, dass Regeln wirken können.
- Vor Aktivierung von UFW muss SSH-Zugriff explizit berücksichtigt werden.

## 2. nftables prüfen

Basisbefehl:

    sudo nft list ruleset

Bewertung:

- nftables zeigt das Kernel-Firewall-Regelwerk.
- Eine leere oder sehr kurze Ausgabe kann bedeuten, dass aktuell keine eigenen Regeln aktiv sind.
- UFW nutzt je nach System intern nftables oder iptables-Kompatibilität.
- nftables ist näher an der technischen Firewall-Ebene als UFW.

## 3. Lokal lauschende Ports prüfen

Basisbefehl:

    ss -tuln

Bewertung:

- TCP LISTEN zeigt lokal lauschende TCP-Dienste.
- UDP UNCONN zeigt lokal gebundene UDP-Sockets.
- Port 22 ist typisch für SSH.
- Port 53 auf 127.0.0.53 oder 127.0.0.54 ist typisch für lokale DNS-Resolver.
- Port 631 ist häufig CUPS bzw. Druckdienst.
- Ein lauschender Port ist nicht automatisch extern erreichbar.

## 4. SSH besonders prüfen

Basisbefehle:

    systemctl is-active ssh
    systemctl is-enabled ssh
    systemctl status ssh --no-pager -l
    ss -tlnH | awk '{print $4}' | grep -E '(:22$|\]:22$)'

Bewertung:

- SSH active bedeutet, dass der Dienst läuft.
- SSH enabled bedeutet, dass der Dienst beim Boot starten soll.
- Port 22 sichtbar bedeutet, dass SSH lokal lauscht.
- SSH ist die Admin-Haustür und darf bei Firewall-Änderungen nicht ausgesperrt werden.

## 5. Bind-Adressen verstehen

Wichtige Beispiele:

- 127.0.0.1: Dienst lauscht nur lokal auf dem System.
- 0.0.0.0: Dienst lauscht auf allen IPv4-Adressen.
- [::]: Dienst lauscht auf IPv6-Adressen.
- 192.168.x.x: Dienst lauscht auf einer konkreten lokalen IPv4-Adresse.

Bewertung:

- Ein Dienst auf 127.0.0.1 ist von außen normalerweise nicht erreichbar.
- Ein Dienst auf 0.0.0.0 kann über Netzwerkinterfaces erreichbar sein.
- Firewall und Routing entscheiden zusätzlich, ob externe Clients zugreifen können.

## 6. Typische Ports einordnen

Beispiele:

- 22/TCP: SSH.
- 53/TCP oder 53/UDP: DNS.
- 80/TCP: HTTP.
- 443/TCP: HTTPS.
- 631/TCP: CUPS/Druckdienst.
- 5353/UDP: mDNS/Multicast-DNS.

Bewertung:

- Jeder offene Port braucht eine fachliche Erklärung.
- Unerwartete Ports sind zu untersuchen.
- Erwartete lokale Dienste sind nicht automatisch problematisch.

## 7. Vor Firewall-Änderungen prüfen

Vor jeder Änderung:

- Ist SSH aktiv?
- Lauscht SSH auf Port 22?
- Gibt es eine offene bestehende Admin-Sitzung?
- Gibt es lokalen Konsolenzugriff oder Recovery-Möglichkeit?
- Ist klar, welche Regel geändert wird?
- Ist klar, wie ein Rollback erfolgt?

Beispielhafte sichere Denkweise:

- Erst SSH erlauben.
- Dann Firewall aktivieren.
- Dann neuen SSH-Login testen.
- Alte Sitzung offen lassen.
- Erst danach alte Sitzung schließen.

## Typische Fehlerbilder

### UFW ist inaktiv

Mögliche Ursachen:

- Firewall wurde nie aktiviert.
- Lab-System ohne aktive Firewall.
- Regelplanung noch nicht erfolgt.
- Admin wollte SSH-Aussperrung vermeiden.

Bewertung:

- Im Lab nicht automatisch kritisch.
- In Produktion ein klarer Bewertungs- und Freigabepunkt.

### Dienst läuft, aber Zugriff scheitert

Mögliche Ursachen:

- Firewall blockiert.
- Dienst lauscht nur auf localhost.
- falscher Port.
- falsche IP.
- Routingproblem.
- Client in anderem Netz.

Erste Prüfung:

    systemctl status <dienstname> --no-pager -l
    ss -tuln
    sudo ufw status verbose
    ip route

### Port ist offen, aber nicht gewollt

Mögliche Ursachen:

- Dienst automatisch gestartet.
- Paketinstallation hat Dienst aktiviert.
- Desktop- oder Systemdienst lauscht lokal.
- Fehlkonfiguration.

Erste Prüfung:

    ss -tuln
    systemctl --type=service --state=running --no-pager
    journalctl -p warning..alert --since "1 hour ago" --no-pager

### SSH wird durch Firewall ausgesperrt

Mögliche Ursachen:

- UFW aktiviert ohne SSH-Regel.
- falscher Port erlaubt.
- Zugriff nur aus falschem Netz erlaubt.
- IPv4/IPv6-Regel vergessen.

Sichere Gegenmaßnahme:

- bestehende SSH-Sitzung offen halten.
- lokale Konsole oder Recovery-Zugang bereithalten.
- SSH-Regel prüfen, bevor Firewall aktiviert wird.
- neuen Login testen, bevor alte Sitzung geschlossen wird.

## Sicheres Verhalten

- Firewall-Regeln nicht blind ändern.
- SSH-Zugriff vor Änderungen schützen.
- Ports und Dienste fachlich zuordnen.
- Private IPs und MAC-Adressen nicht unbedacht öffentlich dokumentieren.
- Änderungen mit Rollback-Plan durchführen.
- In Produktion Change-Prozess, Wartungsfenster und Freigabe beachten.

## Lab-vs-Production-Einordnung

Im Lab reicht die Bestandsaufnahme mit ufw, nft, ss und systemctl.

In Produktion müssen Firewall-Regeln dokumentiert, geprüft, freigegeben und überwacht werden. Zusätzlich sind Netzwerksegmentierung, zentrale Firewalls, Security Groups, Network Security Groups, Load Balancer, Logging und Incident Response relevant.

## Merksätze

- Netzwerk ist die Straße.
- Ports sind die Türen.
- Firewall ist der Türsteher.
- SSH ist die Admin-Haustür.
- Erst Bestand prüfen, dann Regel ändern.
- Keine Firewall-Änderung ohne Rückweg.
