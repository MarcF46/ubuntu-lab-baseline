# Runbook – Security-Baseline und Härtungsprüfung

## Zweck

Dieses Runbook beschreibt die strukturierte Prüfung einer Security-Baseline auf einem Linux-System. Ziel ist eine nachvollziehbare Bestandsaufnahme, bevor Härtungsmaßnahmen geplant oder umgesetzt werden.

## Typisches Betriebsszenario

Ein Linux-System soll sicherheitstechnisch bewertet werden. Vor Änderungen an SSH, Firewall, sudo, Benutzerrechten oder Systemdiensten wird der aktuelle Zustand geprüft und dokumentiert.

## Grundregel

Security-Baseline bedeutet zuerst prüfen, nicht sofort ändern.

## Wichtige Begriffe

- Security-Baseline: dokumentierter Ausgangszustand eines Systems aus Sicherheitssicht.
- Härtung: gezielte Reduzierung unnötiger Angriffsflächen.
- SSH: Secure Shell, verschlüsselter Admin-Zugriff auf ein System.
- sudo: Mechanismus, mit dem berechtigte Benutzer administrative Befehle ausführen können.
- UFW: Uncomplicated Firewall, vereinfachte Firewall-Verwaltung unter Ubuntu.
- systemd Unit: Service-, Timer- oder Systemeinheit, die von systemd verwaltet wird.
- Reboot-Marker: Hinweisdatei, dass nach Updates ein Neustart erforderlich ist.

## Sicherer Diagnoseablauf

1. aktuellen Benutzer und Gruppen prüfen.
2. sudo-Mitgliedschaft und sudo-Grundzustand prüfen.
3. Home- und SSH-Dateirechte prüfen.
4. effektive SSH-Konfiguration prüfen.
5. SSH-Dienststatus und Port prüfen.
6. Firewall-Status prüfen.
7. Update- und Reboot-Hinweise prüfen.
8. kritische Systemdatei-Rechte prüfen.
9. fehlgeschlagene systemd Units prüfen.
10. Befunde bewerten und Änderungen als separate Changes planen.

## Benutzer und Gruppen prüfen

Beispielbefehle:

    whoami
    id
    groups
    getent group sudo

Bewertung:

- Nur notwendige Benutzer sollten administrative Rechte besitzen.
- Mitgliedschaft in der sudo-Gruppe bedeutet erhöhte Verantwortung.
- Gruppenmitgliedschaften sollten fachlich erklärbar sein.
- Unbekannte oder unnötige Admin-Mitgliedschaften sind ein Prüfpunkt.

## sudo-Grundzustand prüfen

Beispielbefehl:

    sudo -l

Bewertung:

- sudo zeigt, welche administrativen Rechte für den Benutzer gelten.
- In produktiven Umgebungen sollten sudo-Rechte nachvollziehbar, begrenzt und dokumentiert sein.
- Breite sudo-Rechte sind nicht automatisch falsch, müssen aber bewusst vergeben sein.

## Home- und SSH-Dateirechte prüfen

Beispielbefehle:

    ls -ld "$HOME"
    ls -ld "$HOME/.ssh"
    ls -l "$HOME/.ssh/authorized_keys"
    stat -c '%A %a %U:%G %n' "$HOME" "$HOME/.ssh" "$HOME/.ssh/authorized_keys"

Typische Zielwerte:

- Home-Verzeichnis: restriktiv, zum Beispiel 750 oder 700.
- .ssh-Verzeichnis: 700.
- authorized_keys: 600.

Bewertung:

- Zu offene SSH-Dateirechte können Sicherheitsrisiken erzeugen.
- Private Schlüssel dürfen nicht öffentlich lesbar sein.
- authorized_keys steuert, welche Public Keys für den Benutzer zugelassen sind.

## SSH-Konfiguration prüfen

Beispielbefehl:

    sudo sshd -T

Wichtige Parameter:

- port
- permitrootlogin
- passwordauthentication
- pubkeyauthentication
- permitemptypasswords
- maxauthtries
- x11forwarding

Bewertung:

- permitrootlogin sollte nicht unkontrolliert auf yes stehen.
- passwordauthentication yes kann ein Härtungskandidat sein.
- pubkeyauthentication yes ist für Key-basierte Anmeldung erforderlich.
- permitemptypasswords sollte no sein.
- x11forwarding yes kann ein Härtungskandidat sein, wenn nicht benötigt.
- Änderungen an SSH müssen mit Rückweg geplant werden.

## SSH-Dienst und Port prüfen

Beispielbefehle:

    systemctl is-active ssh
    systemctl is-enabled ssh
    ss -tlnH | grep ':22'

Bewertung:

- active bedeutet: Dienst läuft aktuell.
- enabled bedeutet: Dienst startet automatisch beim Boot.
- Ein lauschender Port 22 zeigt, dass SSH lokal erreichbar sein kann.
- Ob SSH extern erreichbar ist, hängt zusätzlich von Firewall, Bind-Adresse, Routing und Netzwerkpfad ab.

## Firewall-Status prüfen

Beispielbefehle:

    command -v ufw
    sudo ufw status verbose

Bewertung:

- Eine inaktive Firewall ist im Lab nicht automatisch ein Fehler.
- In Produktion muss klar sein, warum Firewall-Regeln aktiv oder inaktiv sind.
- Firewall-Änderungen dürfen Admin-Zugriff nicht versehentlich aussperren.
- Keine Firewall-Aktivierung ohne Rückfallplan.

## Updates und Reboot prüfen

Beispielbefehle:

    test -f /var/run/reboot-required && cat /var/run/reboot-required
    apt list --upgradable

Bewertung:

- Offene Updates sind ein Sicherheits- und Betriebsprüfpunkt.
- Ein Reboot-Marker zeigt, dass ein Neustart nach Updates nötig sein kann.
- Updates sollten als kontrollierter Change geplant werden.

## Kritische Datei-Rechte prüfen

Beispielbefehl:

    stat -c '%A %a %U:%G %n' /etc/passwd /etc/shadow /etc/group /etc/sudoers

Typische Bewertung:

- /etc/passwd ist lesbar, aber nicht für normale Benutzer schreibbar.
- /etc/shadow darf nicht allgemein lesbar sein.
- /etc/sudoers sollte stark geschützt sein.
- Abweichungen müssen geprüft werden.

## Failed systemd Units prüfen

Beispielbefehl:

    systemctl --failed --no-pager

Bewertung:

- Fehlgeschlagene Dienste können Sicherheits- oder Betriebsprobleme anzeigen.
- Nicht jede failed Unit ist ein Incident.
- Ursache, Zeitpunkt und betroffener Dienst müssen geprüft werden.

## Typische Befunde und Einordnung

### PasswordAuthentication steht auf yes

Bewertung:

- Kann im Lab akzeptabel sein.
- In Produktion oft ein Härtungskandidat.
- Änderung nur planen, wenn Key-Login sicher funktioniert.
- Alte Sitzung offen lassen und neuen Login testen.

### X11Forwarding steht auf yes

Bewertung:

- Kann unnötige Funktionalität darstellen.
- Wenn nicht benötigt, späterer Härtungskandidat.
- Änderung kontrolliert dokumentieren.

### UFW ist inaktiv

Bewertung:

- Im Lab dokumentierter Zustand.
- In Produktion muss bewertet werden, ob Firewall-Regeln an anderer Stelle greifen.
- Aktivierung nur mit Rückfallplan.

### Benutzer ist in sudo-Gruppe

Bewertung:

- Für Admin-Lab plausibel.
- In Produktion muss das Prinzip minimaler Rechte geprüft werden.
- Adminrechte sollten nachvollziehbar vergeben sein.

## Typische Anfängerfehler

- SSH-Konfiguration ändern und aktuelle Sitzung schließen, bevor neuer Login getestet wurde.
- Firewall aktivieren und sich selbst aussperren.
- sudo-Rechte vergeben, ohne Notwendigkeit zu dokumentieren.
- PasswordAuthentication deaktivieren, obwohl Key-Login nicht sicher funktioniert.
- Befunde sofort ändern, ohne Rückfallplan.
- private Schlüssel oder Secrets in Dokumentation oder Git übernehmen.

## Sicherer Change-Grundsatz

Vor Härtungsmaßnahmen gilt:

1. Ist-Zustand dokumentieren.
2. Risiko bewerten.
3. Änderung planen.
4. Rückfallweg festlegen.
5. Änderung klein halten.
6. prüfen, ob Admin-Zugriff erhalten bleibt.
7. Änderung testen.
8. Ergebnis dokumentieren.

## Lab-vs-Production-Einordnung

Im Lab reicht eine lokale Security-Baseline mit SSH-, sudo-, Rechte-, Firewall-, Update- und Serviceprüfung.

In Produktion kommen weitere Punkte dazu:

- zentrale Benutzerverwaltung.
- MFA, also Multi-Faktor-Authentifizierung.
- zentrale Protokollierung.
- SIEM, also Security Information and Event Management.
- Schwachstellenmanagement.
- Patch-Management.
- Incident-Response-Prozess.
- Notfallzugänge.
- Rollen- und Rechtekonzept.
- Netzwerksegmentierung.
- Geheimnisverwaltung für Secrets und Schlüssel.

## Merksätze

- Security beginnt mit Bestandsaufnahme.
- Rechte sind Türen, Gruppen sind Schlüsselbunde.
- SSH ist die Admin-Haustür.
- Erst prüfen, dann härten.
- Keine Härtung ohne Rückweg.
- Ein Befund ist noch kein Alarm.
- Eine Härtung ohne Test kann selbst zum Ausfall werden.
