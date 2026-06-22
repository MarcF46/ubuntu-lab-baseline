# Troubleshooting-Karte – Security-Baseline und Härtungsprüfung

## Zweck

Diese Karte unterstützt die Diagnose typischer Security-Befunde auf einem Linux-System. Ziel ist eine saubere Einordnung, bevor Härtungsmaßnahmen umgesetzt werden.

## Sofortprüfung

- `whoami`
- `id`
- `groups`
- `sudo -l`
- `stat -c '%A %a %U:%G %n' "$HOME" "$HOME/.ssh" "$HOME/.ssh/authorized_keys"`
- `sudo sshd -T`
- `systemctl is-active ssh`
- `systemctl is-enabled ssh`
- `sudo ufw status verbose`
- `apt list --upgradable`
- `systemctl --failed --no-pager`

## Symptom 1 – Benutzer hat sudo-Rechte

Mögliche Ursachen:

- Admin-Lab-Benutzer.
- Mitgliedschaft in der sudo-Gruppe.
- bewusst eingerichtete administrative Rolle.
- zu breit vergebene Rechte.

Prüfung:

- `id`
- `groups`
- `getent group sudo`
- `sudo -l`

Bewertung:

- Im Admin-Lab ist sudo plausibel.
- In Produktion muss jede Admin-Berechtigung begründet sein.
- sudo-Rechte sind kein Fehler, aber ein Verantwortungsbereich.

## Symptom 2 – SSH PasswordAuthentication steht auf yes

Mögliche Ursachen:

- Standardkonfiguration.
- Passwortlogin bewusst erlaubt.
- Key-Login noch nicht vollständig eingeführt.
- Legacy-Zugriff erforderlich.

Prüfung:

- `sudo sshd -T | grep passwordauthentication`
- `sudo sshd -T | grep pubkeyauthentication`
- Test eines Key-Logins über eine zweite Sitzung.

Bewertung:

- PasswordAuthentication yes ist ein Härtungskandidat.
- Nicht sofort deaktivieren, wenn Key-Login nicht sicher getestet wurde.
- Änderung nur mit offener bestehender Sitzung und Rückfallplan.

## Symptom 3 – X11Forwarding steht auf yes

Mögliche Ursachen:

- Standard- oder Komforteinstellung.
- grafische Weiterleitung wurde nie deaktiviert.
- Funktion wird eventuell nicht benötigt.

Prüfung:

- `sudo sshd -T | grep x11forwarding`

Bewertung:

- X11Forwarding yes ist ein Härtungskandidat, wenn nicht benötigt.
- Kein Notfall, aber ein Punkt für kontrollierte Härtung.
- Änderung mit SSH-Konfigurationsprüfung und Reload planen.

## Symptom 4 – UFW ist inaktiv

Mögliche Ursachen:

- Lab-System ohne aktive Host-Firewall.
- Firewall-Regeln werden extern umgesetzt.
- UFW wurde noch nicht konfiguriert.
- bewusste Entscheidung im Lernsystem.

Prüfung:

- `command -v ufw`
- `sudo ufw status verbose`
- `ss -tulpen`

Bewertung:

- Inaktiv ist im Lab dokumentierbar.
- In Produktion muss klar sein, wo Zugriff kontrolliert wird.
- Firewall nicht aktivieren, ohne SSH-Zugriff abzusichern.
- Keine Firewall-Änderung ohne Rückweg.

## Symptom 5 – SSH-Port lauscht auf 0.0.0.0 oder [::]

Mögliche Ursachen:

- SSH lauscht auf allen IPv4-Adressen.
- SSH lauscht auf IPv6-any.
- Standardverhalten ohne ListenAddress-Einschränkung.

Prüfung:

- `ss -tlnH | grep ':22'`
- `sudo sshd -T | grep listenaddress`

Bewertung:

- Nicht automatisch falsch.
- Bedeutet nur: Dienst lauscht breit.
- Erreichbarkeit hängt zusätzlich von Firewall, Routing und Netzwerkpfad ab.
- Fachlich erklären und später bei Bedarf einschränken.

## Symptom 6 – Home- oder SSH-Rechte sind zu offen

Mögliche Ursachen:

- falsches chmod.
- manuell kopierte SSH-Dateien.
- Migration von anderem System.
- unbewusst geänderte Verzeichnisrechte.

Prüfung:

- `stat -c '%A %a %U:%G %n' "$HOME"`
- `stat -c '%A %a %U:%G %n' "$HOME/.ssh"`
- `stat -c '%A %a %U:%G %n' "$HOME/.ssh/authorized_keys"`

Bewertung:

- .ssh sollte typischerweise 700 sein.
- authorized_keys sollte typischerweise 600 sein.
- private Schlüssel dürfen nicht öffentlich lesbar sein.
- Rechteänderungen nur gezielt durchführen.

## Symptom 7 – Offene Updates vorhanden

Mögliche Ursachen:

- normaler Patch-Zyklus.
- Sicherheitsupdates offen.
- Paketlisten wurden aktualisiert.
- System wurde länger nicht aktualisiert.

Prüfung:

- `apt list --upgradable`
- `test -f /var/run/reboot-required && cat /var/run/reboot-required`

Bewertung:

- Offene Updates sind ein Betriebs- und Sicherheitsprüfpunkt.
- Updates sind ein kontrollierter Change.
- Kritische Pakete wie Kernel, SSH, systemd, libc oder OpenSSL besonders beachten.

## Symptom 8 – Reboot-Marker vorhanden

Mögliche Ursachen:

- Kernel-Update.
- systemnahe Bibliothek aktualisiert.
- Dienst benötigt Neustart.
- Sicherheitsupdate erfordert Reboot.

Prüfung:

- `cat /var/run/reboot-required`
- `cat /var/run/reboot-required.pkgs`

Bewertung:

- Reboot planen, nicht blind ausführen.
- Wartungsfenster, aktive Sessions und Dienste prüfen.
- Nach Reboot Health-Checks ausführen.

## Symptom 9 – Failed systemd Units vorhanden

Mögliche Ursachen:

- Dienststart fehlgeschlagen.
- Abhängigkeit fehlt.
- Konfiguration fehlerhaft.
- alter Fehlerstatus nach früherem Test.
- Hardware- oder Desktop-Dienstproblem.

Prüfung:

- `systemctl --failed --no-pager`
- `systemctl status <dienstname>`
- `journalctl -u <dienstname> --no-pager -n 80`

Bewertung:

- Failed Units sind Warnsignale.
- Nicht jede failed Unit ist ein Sicherheitsvorfall.
- Ursache und betroffene Funktion prüfen.

## Symptom 10 – Kritische Systemdatei-Rechte auffällig

Mögliche Ursachen:

- falsche Rechteänderung.
- fehlerhafte Paket-/Systemänderung.
- manuelle Reparatur.
- falscher Besitzer.

Prüfung:

- `stat -c '%A %a %U:%G %n' /etc/passwd /etc/shadow /etc/group /etc/sudoers`

Bewertung:

- /etc/shadow darf nicht allgemein lesbar sein.
- /etc/sudoers muss stark geschützt bleiben.
- Abweichungen sind ernst zu prüfen.

## Sicherer Diagnoseweg

1. Symptom erfassen.
2. betroffenen Bereich bestimmen.
3. Ist-Zustand prüfen.
4. Risiko bewerten.
5. keine Sofortänderung ohne Rückweg durchführen.
6. Änderung als separaten Change planen.
7. Test- und Rollback-Weg festlegen.
8. Ergebnis dokumentieren.

## Typische Anfängerfehler

- SSH härten und sich aussperren.
- Firewall aktivieren ohne SSH-Allow-Regel.
- PasswordAuthentication deaktivieren ohne getesteten Key-Login.
- sudo-Rechte entfernen ohne zweiten Admin-Zugang.
- Tool-Ausgabe als Alarm behandeln, ohne Kontext zu prüfen.
- private Schlüssel, Tokens oder Secrets dokumentieren.
- Sicherheitsänderungen ohne Commit- und Rollback-Plan durchführen.

## Merksätze

- Security beginnt mit Bestandsaufnahme.
- Rechte sind Türen, Gruppen sind Schlüsselbunde.
- SSH ist die Admin-Haustür.
- Erst prüfen, dann härten.
- Keine Härtung ohne Rückweg.
- Ein Befund ist noch kein Alarm.
- Eine Härtung ohne Test kann selbst zum Ausfall werden.
