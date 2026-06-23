# Lab17b – Service- und Port-Baseline: öffentliche Bewertung

## Zweck
Diese Bewertung fasst die lokale Service- und Port-Baseline aus privaten Rohdaten zusammen. Ziel ist eine serviceorientierte Sicht auf laufende Dienste, lauschende Ports und mögliche Monitoring-Kandidaten.

## Nachweisbasis
- Private Rohdaten: docs/private/evidence/lab17-monitoring/lab17b-local-service-port-baseline-raw.txt
- Öffentliche Bewertung: docs/operations/lab17b-service-port-baseline-bewertung.md

Die privaten Rohdaten bleiben privat, weil sie Hostname, Machine-ID, IP-Adressen, Prozessdetails und lokale Dienstinformationen enthalten können.

## Ergebnisübersicht

| Prüfpunkt | Ergebnis | Bewertung |
|---|---|---|
| Laufende systemd-Services | 36 | Baseline erfasst |
| TCP (Transmission Control Protocol, verbindungsorientiertes Netzwerkprotokoll)-LISTEN-Ports | 6 | weiter bewerten |
| UDP (User Datagram Protocol, verbindungsloses Netzwerkprotokoll)-Sockets | 15 | weiter bewerten |
| systemd-Timer | 19 | Baseline erfasst |
| SSH (Secure Shell, verschlüsselter Fernzugriff)-Service | erkannt | sicherheitsrelevant |
| auditd (Audit Daemon, Linux-Auditdienst) | erkannt | sicherheitsrelevant |
| Fail2Ban | erkannt | sicherheitsrelevant |
| rsyslog (System Logging Service) | erkannt | logging-relevant |
| logrotate.timer | erkannt | betrieblich relevant |

## Auffällige Service-Kandidaten

| Dienst oder Port-Gruppe | Einordnung | Monitoring-Relevanz |
|---|---|---|
| SSH Port 22 | lauscht auf allen IPv4-Schnittstellen; lauscht auf allen IPv6-Schnittstellen | Erreichbarkeit und Zugriffsschutz überwachen |
| CUPS (Common Unix Printing System, Druckdienst) Port 631 | lokal erkannt | lokal unkritischer als extern erreichbar |
| DNS (Domain Name System, Namensauflösung)-Stub Port 53 | lokaler DNS-Stub erkannt | wichtig für lokale Namensauflösung |
| Avahi/mDNS (multicast DNS, lokale Netzwerkerkennung) Port 5353 | mDNS/Avahi erkannt | im Lab normal, in Produktion bewusst bewerten |

## Bewertung
Die Baseline zeigt mehrere laufende Systemdienste und lauschende Ports. Für serviceorientiertes Monitoring ist entscheidend, diese technischen Zustände in Service-Fragen zu übersetzen.

Beispiel: Ein laufender SSH-Dienst bedeutet nicht automatisch sichere Administration. Relevant sind zusätzlich Erreichbarkeit, Zugriffsschutz, Firewall-Regeln, Authentifizierung, Logs und Alarmierung bei Fehlversuchen.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Lokale Dienste | dürfen sichtbar und lernorientiert bewertet werden | nur notwendige Dienste aktiv lassen |
| SSH | im Lab praktisch für Administration | über VPN (Virtual Private Network, verschlüsselter Netzzugang), Management-Netz oder restriktive Firewall absichern |
| mDNS/Avahi | auf Desktop-/Lab-Systemen häufig | in Servernetzen bewusst erlauben oder deaktivieren |
| Druckdienste | auf Desktop-Systemen normal | auf Servern nur bei Bedarf betreiben |
| DNS-Stub | lokal normal | Namensauflösung als kritische Abhängigkeit überwachen |
| Timer | lokal prüfen | zentrale Sicht auf geplante Jobs, Fehler und Laufzeiten aufbauen |

## Monitoring-Kandidaten

- SSH-Dienstzustand und Port-Erreichbarkeit.
- Fehlgeschlagene SSH-Logins über Logs oder Fail2Ban.
- DNS-Auflösung lokal und später netzweit.
- Logdienste wie rsyslog und logrotate.timer.
- Unerwartet lauschende Ports.
- Kritische systemd-Services.
- Timer-Fehler oder ausgefallene geplante Wartungsjobs.

## Diagnoseanker
Eine Port-Baseline beantwortet nicht nur, was läuft. Sie hilft zu entscheiden, was erwartet, was erklärbar und was riskant ist.

## Merksatz
Jeder offene Port ist eine Frage an den Betrieb: Warum ist er offen, wer nutzt ihn, wer überwacht ihn und was passiert bei Ausfall oder Missbrauch?
