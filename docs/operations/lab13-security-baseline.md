# Lab 13 – Security-Baseline

## Ziel

Im Lab wurde eine erste Security-Baseline des Ubuntu-Systems erstellt. Geprüft wurden Benutzer- und Gruppenstatus, sudo-Grundzustand, SSH-Sicherheitsparameter, Datei- und Verzeichnisrechte, Firewall-Status, Update-/Reboot-Hinweise und fehlgeschlagene systemd Units.

## Typisches Betriebsszenario

Ein System soll vor weiteren Härtungsmaßnahmen bewertet werden. Vor Änderungen wird geprüft, wie der aktuelle Sicherheitszustand tatsächlich aussieht und welche Punkte später kontrolliert verbessert werden müssen.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab13-security/lab13-security-baseline-raw.txt

## Beobachteter Zustand

- Aktueller Benutzer: marc
- Gruppen des Benutzers: marc,adm,cdrom,sudo,dip,plugdev,users,lpadmin,lxd
- Mitglied der sudo-Gruppe: ja
- Home-Verzeichnis-Rechte: 750
- SSH-Verzeichnis-Rechte: 700
- authorized_keys-Rechte: 600
- SSH Dienststatus: active
- SSH Autostartstatus: enabled
- SSH Port 22 lokal sichtbar: ja
- SSH PermitRootLogin: prohibit-password
- SSH PasswordAuthentication: yes
- SSH PubkeyAuthentication: yes
- SSH PermitEmptyPasswords: no
- SSH X11Forwarding: yes
- UFW vorhanden: ja
- UFW aktiv: nein
- Reboot erforderlich: nein
- Offene Paketupdates: 0
- Fehlgeschlagene systemd Units: 0
- /etc/shadow Rechte: 640 root:shadow
- /etc/sudoers Rechte: 440 root:root

## Betriebliche Bewertung

Die Security-Baseline zeigt den aktuellen Grundzustand, ohne bereits Änderungen vorzunehmen. Besonders wichtig sind SSH-Zugriff, sudo-Mitgliedschaften, Datei- und Verzeichnisrechte, Firewall-Status, Update-Zustand und fehlgeschlagene Dienste.

Ein einzelner Befund ist nicht automatisch ein Incident. Security-Bewertung bedeutet, technische Zustände sauber zu erfassen, Risiken einzuordnen und spätere Änderungen kontrolliert mit Rückfallplan umzusetzen.

## Nächster professioneller Schritt

Als nächster Schritt werden ein Runbook und eine Checkliste für Security-Baseline und Härtungsprüfung erstellt. Danach können ausgewählte Verbesserungen als kontrollierte Changes geplant werden.

## Merksätze

- Security beginnt mit Bestandsaufnahme.
- Rechte sind Türen, Gruppen sind Schlüsselbunde.
- SSH ist die Admin-Haustür.
- Erst prüfen, dann härten.
- Keine Härtung ohne Rückweg.
