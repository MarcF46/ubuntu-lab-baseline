# Checkliste – Firewall-, Port- und Zugriffskontrolle

## Zweck

Diese Checkliste dient zur sicheren Prüfung von Firewall-Status, lokal lauschenden Ports, SSH-Erreichbarkeit und Zugriffskontrolle auf einem Ubuntu-Linux-System.

## Basisprüfung

- command -v ufw ausführen.
- sudo ufw status verbose ausführen.
- sudo nft list ruleset ausführen.
- ss -tuln ausführen.
- systemctl is-active ssh ausführen.
- systemctl is-enabled ssh ausführen.
- SSH-Port 22 mit ss prüfen.
- systemctl --failed --no-pager prüfen.

## UFW prüfen

- UFW installiert?
- UFW aktiv?
- UFW inaktiv?
- Gibt es sichtbare Regeln?
- Ist SSH vor einer Aktivierung berücksichtigt?

Bewertung:

- UFW vorhanden bedeutet nicht automatisch, dass eine Firewall aktiv ist.
- UFW inaktiv ist im Lab nicht automatisch ein Fehler.
- In Produktion muss eine inaktive Firewall bewusst bewertet und dokumentiert werden.

## nftables prüfen

- nftables-Regelwerk anzeigen.
- Prüfen, ob Regeln vorhanden sind.
- Prüfen, ob Ausgabe leer oder sehr kurz ist.
- UFW und nftables nicht verwechseln.

Bewertung:

- UFW ist die einfache Verwaltungsoberfläche.
- nftables ist näher an der technischen Firewall-Ebene.
- Eine leere nftables-Ausgabe kann bedeuten, dass aktuell keine eigenen Regeln aktiv sind.

## Lokale Ports prüfen

- ss -tuln ausführen.
- TCP LISTEN Ports erfassen.
- UDP gebundene Ports erfassen.
- Port 22 als SSH einordnen.
- Port 53 als lokalen DNS-Resolver einordnen, falls auf 127.0.0.53 oder 127.0.0.54.
- Port 631 als möglichen Druckdienst einordnen.
- Unerwartete Ports markieren.

Bewertung:

- Ein lauschender Port ist eine lokal offene Tür.
- Ein lauschender Port ist nicht automatisch extern erreichbar.
- Jeder offene Port braucht eine fachliche Erklärung.

## SSH besonders absichern

- SSH-Dienst active?
- SSH-Dienst enabled?
- SSH-Port 22 sichtbar?
- Bestehende Admin-Sitzung offen?
- Lokaler Konsolenzugriff oder Recovery-Weg vorhanden?
- SSH-Regel geplant, bevor Firewall aktiviert wird?

Bewertung:

- SSH ist die Admin-Haustür.
- Firewall-Änderungen dürfen SSH nicht unbeabsichtigt blockieren.
- Vor produktiven Änderungen muss ein Rückweg vorhanden sein.

## Bind-Adressen prüfen

- 127.0.0.1 erkennen.
- 0.0.0.0 erkennen.
- [::] erkennen.
- konkrete lokale IP-Adresse erkennen.

Bewertung:

- 127.0.0.1 bedeutet nur lokal erreichbar.
- 0.0.0.0 bedeutet auf allen IPv4-Adressen lauschend.
- [::] bedeutet auf IPv6-Adressen lauschend.
- Firewall, Routing und Netzwerkpfad entscheiden zusätzlich über externe Erreichbarkeit.

## Typische Fehlerbilder prüfen

- UFW ist inaktiv.
- Dienst läuft, aber Port lauscht nicht.
- Dienst lauscht nur auf localhost.
- Dienst lauscht extern, obwohl es nicht erwartet wurde.
- Firewall blockiert Zugriff.
- SSH wurde durch Firewall-Regel ausgesperrt.
- falscher Port wird geprüft.
- IPv4-Regel vorhanden, IPv6-Regel vergessen.
- Port ist lokal offen, aber extern nicht erreichbar.

## Sichere Reihenfolge vor Firewall-Änderungen

1. Bestand erfassen.
2. SSH-Zugriff prüfen.
3. Rückweg planen.
4. gewünschte Regel formulieren.
5. Risiko bewerten.
6. Änderung durchführen.
7. neuen Zugriff testen.
8. alte Sitzung erst danach schließen.
9. Ergebnis dokumentieren.

## Sichere Dokumentation

- IP-Adressen nicht unbedacht öffentlich dokumentieren.
- MAC-Adressen nicht unbedacht öffentlich dokumentieren.
- Firewall-Regeln sachlich beschreiben.
- Risiken und Rollback erwähnen.
- Lab und Produktion klar trennen.

## Lab-vs-Production-Einordnung

Im Lab reicht eine manuelle Prüfung mit ufw, nft, ss und systemctl.

In Produktion müssen Firewall-Regeln dokumentiert, freigegeben, getestet und überwacht werden. Zusätzlich sind zentrale Firewalls, Netzwerksegmentierung, Security Groups, Network Security Groups, Load Balancer, Monitoring, Logging und Incident Response relevant.

## Merksätze

- Netzwerk ist die Straße.
- Ports sind die Türen.
- Firewall ist der Türsteher.
- SSH ist die Admin-Haustür.
- Erst Bestand prüfen, dann Regel ändern.
- Keine Firewall-Änderung ohne Rückweg.
