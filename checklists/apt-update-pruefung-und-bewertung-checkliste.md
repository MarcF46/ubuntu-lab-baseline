# Checkliste – apt Update-Prüfung und Update-Bewertung

## Zweck

Diese Checkliste dient zur schnellen Vorprüfung von Paketupdates auf einem Ubuntu-System.

## Typisches Betriebsszenario

Ein Linux-Server meldet verfügbare Updates. Vor einer Installation muss geprüft werden, ob der Update-Lauf überschaubar ist, ob Security-Updates enthalten sind, ob kritische Komponenten betroffen sind und ob ein Neustart wahrscheinlich ist.

## Typisches Fehlerbild

- Updates werden blind installiert.
- Ein Reboot wird erst nachträglich bemerkt.
- SSH, Netzwerk, Firewall oder systemd werden aktualisiert, ohne Nachprüfung einzuplanen.
- Es gibt kein Backup, keinen Snapshot und keinen Rollback-Plan.
- Nach dem Update wird nicht geprüft, ob Dienste noch funktionieren.

## Vorprüfung

- sudo apt update
- apt list --upgradable
- sudo apt upgrade --simulate

Erwartung:

- Paketquellen sind erreichbar.
- Verfügbare Updates sind sichtbar.
- Der simulierte Upgrade-Lauf installiert nichts.
- Der simulierte Upgrade-Lauf entfernt nichts.
- Zurückgehaltene Pakete werden erkannt.

## Security-Bewertung

- Prüfen, ob resolute-security oder Security-Hinweise in der Ausgabe auftauchen.
- Security-Updates priorisiert bewerten.
- Trotzdem keine blinde Installation ohne Nachprüfung.

## Kritische Paketgruppen prüfen

Besonders aufmerksam prüfen bei:

- Kernel-Paketen: linux-image, linux-headers, linux-modules
- systemd
- libc6
- openssl
- openssh
- docker / containerd
- network-manager
- ufw / iptables / nftables

## Reboot-Prüfung

- test -f /var/run/reboot-required && cat /var/run/reboot-required || echo "Kein Reboot-Marker vorhanden."
- cat /var/run/reboot-required.pkgs 2>/dev/null || true

Erwartung:

- Wenn /var/run/reboot-required vorhanden ist, ist aktuell ein Neustart angefordert.
- Wenn die Datei nicht vorhanden ist, besteht aktuell kein bekannter Reboot-Marker.
- Ein fehlender Reboot-Marker garantiert nicht, dass nach einem zukünftigen Update kein Neustart nötig wird.

## Vor echtem Update klären

- Gibt es ein aktuelles Backup oder einen Snapshot?
- Ist ein Rollback-Plan vorhanden?
- Ist ein Wartungsfenster nötig?
- Welche Dienste müssen nach dem Update geprüft werden?
- Wer muss informiert werden?

## Nachprüfung nach echtem Update

- systemctl --failed
- systemctl status ssh --no-pager -l
- journalctl -p warning..alert --since "30 minutes ago" --no-pager
- test -f /var/run/reboot-required
- apt list --upgradable
- relevante Service-Health-Checks

## Betriebliche Bewertung

Ein Update-Lauf wirkt kontrollierbarer, wenn keine Pakete entfernt, keine neuen Pakete installiert, keine Pakete zurückgehalten und keine kritischen Basisdienste betroffen sind.

Ein echter Update-Lauf bleibt trotzdem eine Betriebsänderung und benötigt Vorprüfung, Absicherung, Durchführung, Nachprüfung und Dokumentation.

## Merksätze

- apt update liest den Katalog.
- apt upgrade --simulate zeigt den Umbauplan.
- Security-Updates sind wichtig, aber trotzdem kontrolliert einzuspielen.
- Rollback wird vor der Änderung geplant.
- Update ohne Nachprüfung ist nur halbe Betriebsarbeit.
