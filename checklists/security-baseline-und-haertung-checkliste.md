# Checkliste – Security-Baseline und Härtungsprüfung

## Zweck

Diese Checkliste dient zur strukturierten Prüfung eines Linux-Systems aus Sicherheitssicht. Ziel ist zuerst die Bestandsaufnahme, nicht die sofortige Härtung.

## Grundregel

Erst prüfen, dann härten. Keine sicherheitsrelevante Änderung ohne Rückweg.

## Benutzer und Gruppen prüfen

- aktueller Benutzer bekannt?
- Gruppenmitgliedschaften geprüft?
- sudo-Mitgliedschaft nachvollziehbar?
- unnötige Admin-Gruppen erkannt?
- ungewöhnliche Benutzer oder Gruppen auffällig?

Basisprüfung:

    whoami
    id
    groups
    getent group sudo

Bewertung:

- sudo-Mitgliedschaft ist im Admin-Lab plausibel.
- In Produktion muss jede Admin-Berechtigung fachlich begründet sein.
- Gruppen sind Schlüsselbunde: Wer in der Gruppe ist, kann bestimmte Türen öffnen.

## sudo prüfen

- sudo-Rechte geprüft?
- sudo-Ausgabe dokumentiert?
- breite Rechte fachlich eingeordnet?
- keine unnötigen sudo-Regeln erstellt?

Basisprüfung:

    sudo -l

Bewertung:

- Breite sudo-Rechte sind nicht automatisch falsch.
- Sie müssen aber bewusst vergeben, dokumentiert und begründbar sein.

## Home- und SSH-Rechte prüfen

- Home-Verzeichnisrechte geprüft?
- .ssh-Verzeichnis vorhanden und geschützt?
- authorized_keys vorhanden und geschützt?
- keine privaten Schlüssel öffentlich lesbar?
- SSH-Key-Dateien nicht in öffentliche Dokumentation übernommen?

Basisprüfung:

    ls -ld "$HOME"
    ls -ld "$HOME/.ssh"
    ls -l "$HOME/.ssh/authorized_keys"
    stat -c '%A %a %U:%G %n' "$HOME" "$HOME/.ssh" "$HOME/.ssh/authorized_keys"

Typische Zielwerte:

- Home-Verzeichnis: 750 oder 700, je nach Betriebsmodell.
- .ssh: 700.
- authorized_keys: 600.

## SSH-Konfiguration prüfen

- effektive SSH-Konfiguration geprüft?
- PermitRootLogin bewertet?
- PasswordAuthentication bewertet?
- PubkeyAuthentication geprüft?
- PermitEmptyPasswords geprüft?
- X11Forwarding bewertet?
- Änderungen nicht sofort umgesetzt?

Basisprüfung:

    sudo sshd -T

Wichtige Parameter:

- permitrootlogin
- passwordauthentication
- pubkeyauthentication
- permitemptypasswords
- maxauthtries
- x11forwarding

Bewertung:

- PasswordAuthentication yes ist ein Härtungskandidat.
- X11Forwarding yes ist ein Härtungskandidat, wenn nicht benötigt.
- Änderungen an SSH nur mit offener bestehender Sitzung und neuem Login-Test.

## SSH-Dienst und Port prüfen

- SSH-Dienst läuft?
- SSH startet automatisch?
- Port 22 lauscht lokal?
- Bind-Adresse fachlich verstanden?
- externe Erreichbarkeit nicht mit lokalem Lauschen verwechselt?

Basisprüfung:

    systemctl is-active ssh
    systemctl is-enabled ssh
    ss -tlnH | grep ':22'

Bewertung:

- Dienst aktiv bedeutet: SSH läuft.
- Port sichtbar bedeutet: SSH lauscht lokal.
- Erreichbarkeit hängt zusätzlich von Firewall, Route, Bind-Adresse und Netzwerkpfad ab.

## Firewall prüfen

- UFW vorhanden?
- UFW aktiv oder inaktiv?
- Status dokumentiert?
- keine Firewall-Aktivierung ohne Rückweg?
- Admin-Zugriff vor Änderungen abgesichert?

Basisprüfung:

    command -v ufw
    sudo ufw status verbose

Bewertung:

- UFW inaktiv ist im Lab ein dokumentierter Zustand.
- In Produktion muss dieser Zustand fachlich bewertet werden.
- Firewall inaktiv ist kein Terminalfehler, sondern eine Betriebsentscheidung oder ein Risiko.

## Updates und Reboot prüfen

- offene Updates geprüft?
- Reboot-Marker geprüft?
- kritische Pakete erkannt?
- Update nicht ungeplant gestartet?

Basisprüfung:

    test -f /var/run/reboot-required && cat /var/run/reboot-required
    apt list --upgradable

Bewertung:

- Offene Updates sind ein Sicherheits- und Betriebsprüfpunkt.
- Updates bleiben ein kontrollierter Change, nicht nur ein Befehl.

## Kritische Datei-Rechte prüfen

- /etc/passwd geprüft?
- /etc/shadow geprüft?
- /etc/group geprüft?
- /etc/sudoers geprüft?
- auffällige Rechte dokumentiert?

Basisprüfung:

    stat -c '%A %a %U:%G %n' /etc/passwd /etc/shadow /etc/group /etc/sudoers

Bewertung:

- /etc/shadow darf nicht allgemein lesbar sein.
- /etc/sudoers muss stark geschützt sein.
- Abweichungen sind ein Prüfpunkt.

## systemd prüfen

- fehlgeschlagene Units geprüft?
- betroffene Dienste bewertet?
- keine failed Units ignoriert?
- kein Alarm ohne Ursache?

Basisprüfung:

    systemctl --failed --no-pager

Bewertung:

- Failed Units sind Warnsignale.
- Nicht jede failed Unit ist ein Incident.
- Ursache und Auswirkung müssen geprüft werden.

## Typische Härtungskandidaten

- PasswordAuthentication deaktivieren, aber nur nach sicherem Key-Login-Test.
- X11Forwarding deaktivieren, wenn nicht benötigt.
- UFW kontrolliert aktivieren, aber nur mit Rückfallplan.
- sudo-Rechte enger definieren, wenn fachlich möglich.
- unnötige Dienste deaktivieren, aber nur nach Betriebsprüfung.
- Updates planen und nachprüfen.

## Nicht sofort tun

- SSH-Konfiguration ohne Test ändern.
- Firewall aktivieren und aktuelle Verbindung schließen.
- sudo-Rechte entfernen, ohne zweiten Admin-Zugang zu prüfen.
- PasswordAuthentication deaktivieren, ohne funktionierenden Key-Login.
- sensible Rohdaten committen.
- private Schlüssel dokumentieren.
- Härtung ohne Rollback planen.

## Erfolgreicher Mindestnachweis

Eine Security-Baseline gilt im Lab als erfolgreich dokumentiert, wenn:

- Benutzer und Gruppen geprüft wurden.
- sudo-Zustand geprüft wurde.
- Home- und SSH-Rechte geprüft wurden.
- SSH-Konfiguration bewertet wurde.
- SSH-Dienst und Port geprüft wurden.
- Firewall-Status geprüft wurde.
- Update- und Reboot-Hinweise geprüft wurden.
- kritische Datei-Rechte geprüft wurden.
- failed systemd Units geprüft wurden.
- Befunde nicht unkontrolliert geändert wurden.
- nächste Härtungsschritte als separate Changes geplant werden.

## Lab-vs-Production-Einordnung

Im Lab reicht eine lokale Baseline-Prüfung.

In Produktion zusätzlich relevant:

- zentrale Benutzerverwaltung.
- Multi-Faktor-Authentifizierung.
- zentrale Logs.
- SIEM.
- Patch-Management.
- Schwachstellenmanagement.
- Netzwerksegmentierung.
- Backup-/Restore-Konzept.
- Incident Response.
- Notfallzugänge.
- Rollen- und Rechtekonzept.
- Audit-Anforderungen.

## Merksätze

- Security beginnt mit Bestandsaufnahme.
- Rechte sind Türen, Gruppen sind Schlüsselbunde.
- SSH ist die Admin-Haustür.
- Erst prüfen, dann härten.
- Keine Härtung ohne Rückweg.
- Ein Befund ist noch kein Alarm.
- Eine Härtung ohne Test kann selbst zum Ausfall werden.
