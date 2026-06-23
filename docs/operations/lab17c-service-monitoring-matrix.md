# Lab17c – Service-Monitoring-Matrix

## Zweck
Diese Matrix übersetzt die Service- und Port-Baseline aus Lab17b in eine erste serviceorientierte Monitoring-Sicht.

Ziel ist nicht nur die technische Frage, ob ein Dienst läuft. Entscheidend ist, welche Auswirkung ein Ausfall auf Administration, Sicherheit, Logging, Wartung oder Benutzerfunktionen hätte.

## Grundprinzip

| Ebene | Leitfrage |
|---|---|
| Host | Ist das System erreichbar? |
| Dienst | Läuft der relevante systemd-Service? |
| Port | Lauscht der erwartete Netzwerkport? |
| Funktion | Liefert der Dienst eine nutzbare Antwort? |
| Betrieb | Gibt es eine klare Reaktion bei Störung? |

## Service-Monitoring-Matrix

| Service oder Bereich | Technischer Check | Service-Auswirkung bei Störung | Alarmstufe | Erste Reaktion |
|---|---|---|---|---|
| SSH (Secure Shell, verschlüsselter Fernzugriff) | systemctl status ssh, Port 22 prüfen | Remote-Administration kann ausfallen oder unsicher sein | WARNING bis CRITICAL | Erreichbarkeit, Firewall, Dienststatus und Auth-Logs prüfen |
| auditd (Audit Daemon, Linux-Auditdienst) | systemctl status auditd | Sicherheitsrelevante Ereignisse werden ggf. nicht mehr auditierbar erfasst | WARNING bis CRITICAL | Dienststatus prüfen, Journal und Audit-Regeln kontrollieren |
| Fail2Ban | systemctl status fail2ban | Brute-Force-Schutz kann fehlen | WARNING | Dienststatus, Jail-Status und SSH-Fehlversuche prüfen |
| rsyslog (System Logging Service) | systemctl status rsyslog | Systemlogs können fehlen oder nicht weitergeleitet werden | WARNING bis CRITICAL | Dienststatus und Logfluss prüfen |
| logrotate.timer | systemctl status logrotate.timer | Logs können unkontrolliert wachsen | WARNING | Timer, letzte Ausführung und /var/log-Größe prüfen |
| DNS (Domain Name System, Namensauflösung)-Stub | Port 53 lokal prüfen, Namensauflösung testen | Paketupdates, Webzugriffe oder Dienste können Namensauflösung verlieren | WARNING bis CRITICAL | resolvectl, systemd-resolved und Testauflösung prüfen |
| CUPS (Common Unix Printing System, Druckdienst) | Port 631 lokal, cups.service prüfen | Druckfunktion kann ausfallen; auf Servern oft unnötige Angriffsfläche | INFO bis WARNING | Bedarf klären, lokale Bindung prüfen, ggf. deaktivieren |
| Avahi/mDNS (multicast DNS, lokale Netzwerkerkennung) | Port 5353, avahi-daemon prüfen | Lokale Geräteerkennung betroffen; in Servernetzen potenziell unerwünscht | INFO bis WARNING | Lab-/Desktop-Bedarf prüfen, Production-Bewertung durchführen |
| systemd-Timer | systemctl list-timers --all | Wartungsjobs können ausfallen oder verspätet laufen | WARNING | fehlgeschlagene Timer und aktivierte Services prüfen |
| Speicherplatz und Inodes | df -h, df -i, Lab16-Skript | Dienste können schreiben, starten oder rotieren verlieren | WARNING bis CRITICAL | Lab16-Runbook und Incident-Karte nutzen |

## Bewertungslogik

| Alarmstufe | Bedeutung | Beispiel |
|---|---|---|
| INFO | Zustand ist interessant, aber nicht akut kritisch | Avahi/mDNS auf einem Desktop-Lab-System aktiv |
| WARNING | Zustand kann betrieblich relevant werden | logrotate.timer inaktiv oder ungewöhnlich viele offene Ports |
| CRITICAL | Service-Ausfall oder Sicherheits-/Betriebsrisiko wahrscheinlich | SSH nicht erreichbar, Logging ausgefallen, Dateisystem voll |

## Wichtige Unterscheidung
Ein offener Port ist nicht automatisch schlecht. Entscheidend ist, ob der Port erwartet, dokumentiert, abgesichert und überwacht ist.

Ein laufender Dienst ist ebenfalls nicht automatisch ein funktionierender Service. Ein Dienst kann aktiv sein, aber falsche Antworten liefern, keine Logs schreiben oder von Benutzern nicht erreichbar sein.

## Bezug zu Lab16
Lab16 liefert bereits einen konkreten Healthcheck für Speicherplatz, Inodes, /var/log, logrotate.timer und gelöschte offene Dateien. Diese Checks können direkt in die Monitoring-Matrix übernommen werden.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Service-Auswahl | Lernorientiert, mehr Dienste sichtbar | nur notwendige Dienste betreiben |
| Alarmierung | manuelle Bewertung | Ticket, Bereitschaft oder Eskalation |
| Schwellwerte | einfache Startwerte | serviceabhängig, dokumentiert und getestet |
| Sicherheitsdienste | lokal geprüft | zentral überwacht und auditierbar |
| Ports | lokal sichtbar | Firewall-, Segmentierungs- und Management-Netz-Konzept beachten |

## Nächster praktischer Schritt
Als nächstes wird ein kleines read-only Prüfskript vorbereitet, das ausgewählte Servicezustände lokal bewertet. Dabei geht es noch nicht um Prometheus oder Grafana, sondern um saubere Checklogik.

## Merksatz
Monitoring ist erst dann professionell, wenn ein Alarm eine klare Bedeutung und eine sichere nächste Handlung hat.
