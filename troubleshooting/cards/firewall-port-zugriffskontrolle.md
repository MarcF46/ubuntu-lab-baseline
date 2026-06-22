# Troubleshooting-Karte – Firewall, Ports und Zugriffskontrolle

## Zweck

Diese Karte unterstützt die Diagnose typischer Firewall-, Port- und Zugriffskontrollprobleme auf Ubuntu-Linux-Systemen.

## Sofortprüfung

- `command -v ufw`
- `sudo ufw status verbose`
- `sudo nft list ruleset`
- `ss -tuln`
- `systemctl is-active ssh`
- `systemctl is-enabled ssh`
- `systemctl --failed --no-pager`

## Symptom 1 – UFW ist installiert, aber inaktiv

Mögliche Ursachen:

- Firewall wurde noch nicht aktiviert.
- Lab-System ohne aktive Firewall.
- Regelplanung steht noch aus.
- Admin-Zugriff per SSH sollte nicht gefährdet werden.
- Firewall wird über andere Mechanismen verwaltet.

Prüfung:

- `command -v ufw`
- `sudo ufw status verbose`
- `sudo nft list ruleset`

Bewertung:

- UFW vorhanden bedeutet nicht, dass die Firewall aktiv schützt.
- UFW inaktiv ist im Lab nicht automatisch ein Fehler.
- In Produktion ist eine inaktive Host-Firewall ein bewusster Risiko- und Architekturpunkt.

Sichere Maßnahme:

- Zustand dokumentieren.
- SSH-Zugriff bewerten.
- gewünschte Regeln planen.
- Rückweg festlegen.
- erst danach aktivieren oder ändern.

## Symptom 2 – Dienst läuft, aber Port lauscht nicht

Mögliche Ursachen:

- Dienst ist active, aber nicht korrekt gestartet.
- Dienstkonfiguration enthält falschen Port.
- Dienst lauscht nur auf einer anderen Adresse.
- Dienst wurde ohne Netzwerklistener gestartet.
- Abhängigkeit fehlt.

Prüfung:

- `systemctl status <dienstname> --no-pager -l`
- `journalctl -u <dienstname> --since "1 hour ago" --no-pager`
- `ss -tuln`

Bewertung:

- Ein active-Dienst ist nicht automatisch erreichbar.
- Entscheidend ist, ob der Dienst auf der erwarteten Adresse und dem erwarteten Port lauscht.
- Dienststatus, Logs und Portzustand müssen gemeinsam bewertet werden.

## Symptom 3 – Dienst lauscht nur auf localhost

Mögliche Ursachen:

- Dienst ist bewusst nur lokal gebunden.
- Konfiguration nutzt 127.0.0.1.
- Sicherheitsvorgabe verhindert externe Bindung.
- Reverse Proxy soll eigentlich extern erreichbar sein.

Prüfung:

- `ss -tuln`
- Dienstkonfiguration prüfen.
- `systemctl status <dienstname> --no-pager -l`

Bewertung:

- 127.0.0.1 bedeutet nur lokal auf dem System erreichbar.
- 0.0.0.0 bedeutet auf allen IPv4-Adressen lauschend.
- [::] bedeutet auf IPv6-Adressen lauschend.
- Eine lokale Bindung ist nicht automatisch falsch, aber sie muss zur Architektur passen.

## Symptom 4 – Port lauscht, aber Zugriff von außen scheitert

Mögliche Ursachen:

- Firewall blockiert.
- Routing zwischen Client und Server fehlt.
- falsche IP wird verwendet.
- falscher Port wird getestet.
- Dienst spricht anderes Protokoll.
- Netzwerksegmentierung blockiert.
- IPv4/IPv6-Verwechslung.

Prüfung:

- `ss -tuln`
- `sudo ufw status verbose`
- `ip addr`
- `ip route`
- `journalctl -u <dienstname> --since "1 hour ago" --no-pager`

Bewertung:

- Lokal offener Port beweist nicht externe Erreichbarkeit.
- Zwischen Client und Dienst liegen Routing, Firewall, Bind-Adresse und Netzwerkpfad.
- In Produktion können zusätzlich Load Balancer, Security Groups oder zentrale Firewalls beteiligt sein.

## Symptom 5 – SSH-Zugriff geht nach Firewall-Änderung verloren

Mögliche Ursachen:

- UFW aktiviert ohne SSH-Regel.
- falscher SSH-Port erlaubt.
- Zugriff nur aus falschem Netz erlaubt.
- IPv4-Regel gesetzt, IPv6-Regel vergessen.
- Standardrichtlinie blockiert eingehenden Verkehr.

Prüfung:

- lokale Konsole oder Recovery-Zugang verwenden.
- `sudo ufw status verbose`
- `ss -tlnH | grep ':22'`
- `systemctl status ssh --no-pager -l`

Sichere Gegenmaßnahme:

- bestehende SSH-Sitzung bei Änderungen offen lassen.
- SSH-Regel vor Aktivierung der Firewall setzen.
- neuen SSH-Login testen.
- alte Sitzung erst nach erfolgreichem Test schließen.
- Rückfallplan dokumentieren.

## Symptom 6 – Unerwarteter offener Port

Mögliche Ursachen:

- Paketinstallation hat Dienst aktiviert.
- Desktopdienst lauscht lokal.
- Druckdienst oder DNS-Resolver ist aktiv.
- Entwicklungsdienst wurde vergessen.
- Fehlkonfiguration.

Prüfung:

- `ss -tuln`
- `systemctl --type=service --state=running --no-pager`
- `journalctl -p warning..alert --since "1 hour ago" --no-pager`

Bewertung:

- Nicht jeder offene Port ist automatisch gefährlich.
- Jeder offene Port braucht aber eine fachliche Erklärung.
- Öffentliche Erreichbarkeit und lokale Bindung müssen getrennt bewertet werden.

## Symptom 7 – IPv4 funktioniert, IPv6 unerwartet offen oder blockiert

Mögliche Ursachen:

- Dienst lauscht zusätzlich auf [::].
- Firewall-Regeln berücksichtigen nur IPv4.
- IPv6 ist im Netzwerk aktiv.
- UFW IPv6-Konfiguration ist nicht beachtet worden.

Prüfung:

- `ss -tuln`
- `sudo ufw status verbose`
- `ip -6 addr`
- `ip -6 route`

Bewertung:

- IPv6 ist keine Nebensache.
- Dienste können über IPv6 erreichbar sein, obwohl nur IPv4 geprüft wurde.
- Firewall- und Portbewertung muss IPv4 und IPv6 berücksichtigen.

## Typischer Anfängerfehler

Ein Port wird als „offen im Internet“ bewertet, obwohl nur lokal ein Dienst lauscht. Lokal lauschend, lokal erreichbar, netzwerkintern erreichbar und öffentlich erreichbar sind unterschiedliche Zustände.

## Sicherer Diagnoseweg

1. Dienststatus prüfen.
2. Portzustand prüfen.
3. Bind-Adresse prüfen.
4. Firewallstatus prüfen.
5. Routing prüfen.
6. DNS oder Zieladresse prüfen.
7. externen Zugriff testen.
8. Risiko und Maßnahme dokumentieren.

## Sichere Maßnahmen

- Keine Firewall-Regel blind ändern.
- SSH vor Änderungen absichern.
- Rückweg planen.
- bestehende Admin-Sitzung offen lassen.
- neue Verbindung testen.
- Ergebnis dokumentieren.
- private IPs und MAC-Adressen nicht unbedacht veröffentlichen.

## Lab-vs-Production-Einordnung

Im Lab werden UFW, nftables, ss und systemctl zur lokalen Bewertung genutzt.

In Produktion müssen zusätzlich zentrale Firewalls, Cloud-Firewall-Regeln, Security Groups, Network Security Groups, Load Balancer, VLANs, VPNs, Monitoring, Logging und Change-Prozesse berücksichtigt werden.

## Merksätze

- Netzwerk ist die Straße.
- Ports sind die Türen.
- Firewall ist der Türsteher.
- SSH ist die Admin-Haustür.
- Port offen heißt: Die Tür existiert.
- Firewall erlaubt heißt: Jemand darf durch.
- Keine Firewall-Änderung ohne Rückweg.
