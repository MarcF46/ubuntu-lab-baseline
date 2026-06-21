# Troubleshooting-Karte – apt Update-Prüfung und Update-Bewertung

## Zweck

Diese Karte hilft bei typischen Problemen während der Vorprüfung von Paketupdates auf Ubuntu-Systemen.

## Typisches Betriebsszenario

Ein Linux-Server meldet verfügbare Updates. Während der Prüfung treten Warnungen, Paketquellenprobleme, zurückgehaltene Pakete, Reboot-Hinweise oder unklare Upgrade-Ausgaben auf.

## Symptom 1 – apt meldet: CLI interface is not stable

Bedeutung:

- apt ist für interaktive Admin-Arbeit üblich.
- Für robuste Skripte ist apt nicht die stabilste Schnittstelle.
- Für Automatisierung sind apt-get und apt-cache oft besser geeignet.

Bewertung:

- Im Lab ist die Warnung unkritisch.
- In produktiven Skripten sollte geprüft werden, ob apt-get verwendet werden sollte.

## Symptom 2 – Paketquellen sind nicht erreichbar

Typische Hinweise:

- Temporary failure resolving
- Could not resolve
- Failed to fetch
- Connection timed out

Mögliche Ursachen:

- DNS-Problem
- Netzwerkproblem
- Proxy- oder Firewall-Regel
- falscher Mirror
- temporärer Ausfall der Paketquelle

Prüfung:

- ping -c 3 de.archive.ubuntu.com
- ping -c 3 security.ubuntu.com
- resolvectl status
- ip route
- cat /etc/apt/sources.list 2>/dev/null || true
- ls -l /etc/apt/sources.list.d/

## Symptom 3 – Pakete werden zurückgehalten

Typische Hinweise:

- kept back
- zurückgehalten
- not upgraded

Bedeutung:

- apt würde bestimmte Pakete nicht im normalen Upgrade-Lauf aktualisieren.
- Häufig betrifft das Pakete mit neuen Abhängigkeiten oder größeren Änderungen.

Prüfung:

- apt list --upgradable
- sudo apt upgrade --simulate
- sudo apt full-upgrade --simulate

Bewertung:

- full-upgrade darf Pakete installieren oder entfernen.
- In Produktion nur nach genauer Prüfung und Freigabe verwenden.

## Symptom 4 – Reboot-Marker vorhanden

Prüfung:

- test -f /var/run/reboot-required && cat /var/run/reboot-required
- cat /var/run/reboot-required.pkgs 2>/dev/null || true

Bedeutung:

- Das System fordert aktuell einen Neustart an.
- Häufig nach Kernel-, libc- oder systemnahen Updates.

Betriebliche Bewertung:

- Reboot nicht spontan auf produktiven Systemen durchführen.
- Wartungsfenster, Nutzerinformation und Service-Nachprüfung einplanen.

## Symptom 5 – Kritische Komponenten in der Update-Liste

Besonders aufmerksam prüfen bei:

- linux-image / linux-headers / linux-modules
- systemd
- libc6
- openssl
- openssh
- docker / containerd
- network-manager
- ufw / iptables / nftables

Betriebliche Bewertung:

- Diese Pakete können Boot, Dienste, SSH-Zugriff, Containerbetrieb, Netzwerk oder Firewall beeinflussen.
- Vor Installation Backup/Snapshot, Rollback-Plan und Nachprüfung vorbereiten.

## Symptom 6 – Update wurde durchgeführt, danach funktionieren Dienste nicht sauber

Sofortprüfung:

- systemctl --failed
- journalctl -p warning..alert --since "30 minutes ago" --no-pager
- systemctl status ssh --no-pager -l
- apt list --upgradable
- tail -n 80 /var/log/apt/history.log

Bewertung:

- Erst Zustand sichern und Logs prüfen.
- Nicht blind weitere Änderungen ausführen.
- Bei kritischen Diensten Rollback-Plan prüfen.

## Typischer Anfängerfehler

Updates werden installiert, weil sie verfügbar sind, ohne vorher Risiko, Reboot, Backup, Rollback und Nachprüfung zu planen.

## Betriebliche Einordnung

Update-Probleme sind oft keine reinen Paketprobleme. Sie betreffen Betriebssicherheit, Erreichbarkeit, Rollback-Fähigkeit und Kommunikationswege.

## Merksätze

- apt update liest den Katalog.
- apt upgrade --simulate zeigt den Umbauplan.
- full-upgrade kann stärker eingreifen als upgrade.
- Reboot wird geplant, nicht überrascht.
- Erst prüfen, dann ändern, dann beweisen.
