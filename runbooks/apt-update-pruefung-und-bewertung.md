# Runbook – apt Update-Prüfung und Update-Bewertung

## Ziel

Dieses Runbook beschreibt eine sichere Vorprüfung von Paketupdates auf einem Ubuntu-System, ohne Updates direkt zu installieren.

## Typisches Betriebsszenario

Ein Linux-Server meldet verfügbare Updates. Vor einer Installation muss geprüft werden, welche Pakete betroffen sind, ob Security-Updates enthalten sind, ob kritische Systemkomponenten betroffen sind und ob ein Neustart wahrscheinlich ist.

## Muss wissen

- apt update aktualisiert die lokalen Paketlisten.
- apt list --upgradable zeigt verfügbare Paketupdates.
- apt upgrade --simulate simuliert einen Upgrade-Lauf, ohne Pakete zu installieren.
- /var/run/reboot-required zeigt an, ob aktuell ein Neustart angefordert wird.
- Ein fehlender Reboot-Marker garantiert nicht, dass nach einem zukünftigen Update kein Neustart nötig wird.

## Praxis wichtig

Vor einem echten Update sollten folgende Punkte geprüft werden:

- Welche Pakete werden aktualisiert?
- Sind Security-Updates enthalten?
- Werden Pakete neu installiert?
- Werden Pakete entfernt?
- Werden Pakete zurückgehalten?
- Sind Kernel, systemd, libc, SSH, Docker, Netzwerk oder Firewall betroffen?
- Gibt es aktuell einen Reboot-Marker?
- Gibt es Backup, Snapshot oder Rollback-Möglichkeit?
- Welche Dienste müssen nach dem Update geprüft werden?

## Schritt 1 – Paketquellen aktualisieren

Befehl:

- sudo apt update

Erwartung:

- Paketlisten werden gelesen.
- Die Paketquellen sind erreichbar.
- Die Anzahl verfügbarer Updates wird angezeigt.

## Schritt 2 – Verfügbare Updates anzeigen

Befehl:

- apt list --upgradable

Erwartung:

- Aktualisierbare Pakete werden angezeigt.
- Paketversionen und Quellen sind sichtbar.

## Schritt 3 – Upgrade trocken simulieren

Befehl:

- sudo apt upgrade --simulate

Erwartung:

- Es wird angezeigt, was aktualisiert würde.
- Es wird nichts installiert.
- Es wird nichts entfernt.
- Der Exit-Status und die Zusammenfassung werden geprüft.

## Schritt 4 – Reboot-Marker prüfen

Befehl:

- test -f /var/run/reboot-required && cat /var/run/reboot-required || echo "Kein Reboot-Marker vorhanden."

Erwartung:

- Wenn die Datei vorhanden ist, ist aktuell ein Neustart angefordert.
- Wenn die Datei fehlt, besteht aktuell kein bekannter Reboot-Marker.

## Schritt 5 – Kritische Paketgruppen prüfen

Beispiele für besonders aufmerksam zu prüfende Pakete:

- linux-image / linux-headers / linux-modules
- systemd
- libc6
- openssl
- openssh
- docker / containerd
- network-manager
- ufw / iptables / nftables

## Bewertung

Ein Update-Lauf wirkt risikoärmer, wenn keine Pakete entfernt, keine neuen Pakete installiert, keine Pakete zurückgehalten und keine kritischen Basisdienste betroffen sind.

Trotzdem bleibt jedes Update eine kontrollierte Betriebsänderung. Vor produktiven Updates sind Backup oder Snapshot, Wartungsfenster, Rollback-Plan und Nachprüfung erforderlich.

## Rollback-Hinweis

Ein Rollback wird vor der Änderung geplant. Nach einem fehlgeschlagenen Update ist es oft zu spät, erst dann über Wiederherstellung nachzudenken.

## Nachprüfung nach einem echten Update

Nach einem echten Update sollten mindestens geprüft werden:

- systemctl --failed
- systemctl status ssh --no-pager -l
- journalctl -p warning..alert --since "30 minutes ago" --no-pager
- test -f /var/run/reboot-required
- apt list --upgradable
- relevante Anwendungs- oder Service-Health-Checks

## Lab-vs-Production-Einordnung

Im Lab kann die Prüfung direkt auf dem lokalen System erfolgen. In Produktion wären zusätzlich Change-Freigabe, Wartungsfenster, Monitoring, Backup-Freigabe, Kommunikationsplan und dokumentierter Rollback erforderlich.

## Merksätze

- apt update liest den Katalog.
- apt upgrade --simulate zeigt den Umbauplan.
- Update ist Änderung, nicht nur Installation.
- Rollback wird vor dem Fehler geplant.
- Update ohne Nachprüfung ist nur halbe Betriebsarbeit.
