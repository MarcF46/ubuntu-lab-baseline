# Checkliste: Benutzer, Gruppen und sudo prüfen

## Zweck

Diese Checkliste dient zur schnellen Kontrolle von Benutzeridentität, Gruppenmitgliedschaften, sudo-Rechten und grundlegender Rechtevergabe auf einem Ubuntu-System.

## Basisprüfung

- [ ] Aktueller Benutzer wurde mit `whoami` geprüft.
- [ ] Benutzer-ID und Gruppen wurden mit `id` geprüft.
- [ ] Gruppenmitgliedschaften wurden mit `groups` geprüft.
- [ ] Benutzerkonto wurde mit `getent passwd <benutzer>` geprüft.
- [ ] Home-Verzeichnis wurde mit `ls -ld /home/<benutzer>` geprüft.

## sudo-Prüfung

- [ ] Mitgliedschaft in der Gruppe `sudo` wurde mit `getent group sudo` geprüft.
- [ ] sudo-Rechte wurden mit `sudo -l` geprüft.
- [ ] Weitreichende sudo-Rechte wurden fachlich bewertet.
- [ ] Kritische Adminrechte wurden nicht nur technisch, sondern betrieblich eingeordnet.

## Testbenutzer ohne sudo-Rechte

- [ ] Testbenutzer ohne sudo-Rechte ist vorhanden.
- [ ] Gruppen des Testbenutzers wurden mit `id <benutzer>` geprüft.
- [ ] Testbenutzer ist nicht Mitglied der Gruppe `sudo`.
- [ ] sudo-Test als Testbenutzer wurde durchgeführt.
- [ ] Zugriff auf `/etc/shadow` wurde als normaler Benutzer verweigert.
- [ ] Erwartete Fehlermeldungen wurden als Schutzverhalten bewertet.

## Kritische Gruppen

Folgende Gruppen wurden bewusst geprüft oder für spätere Prüfungen markiert:

- [ ] `sudo`
- [ ] `adm`
- [ ] `lxd`
- [ ] `docker`
- [ ] `lpadmin`
- [ ] `plugdev`

## Dokumentation

- [ ] Technischer Nachweis wurde gespeichert.
- [ ] Betriebliche Einordnung wurde erstellt.
- [ ] Runbook wurde erstellt oder aktualisiert.
- [ ] Git-Commit wurde erstellt.
- [ ] Arbeitsbaum wurde mit `git status --short` geprüft.

## Lab-vs-Production-Bewertung

- [ ] Lab-Berechtigungen wurden als Lernumgebung eingeordnet.
- [ ] Production-Unterschiede wurden dokumentiert.
- [ ] Prinzip der minimal notwendigen Rechte wurde erwähnt.
- [ ] Kritische Gruppenmitgliedschaften wurden als prüfpflichtig markiert.

## Abschlusskriterien

Lab 02 gilt für diesen Abschnitt als sauber dokumentiert, wenn folgende Punkte erfüllt sind:

- Benutzer- und Gruppenrechte sind nachvollziehbar geprüft.
- sudo-Rechte sind technisch belegt und fachlich bewertet.
- Ein normaler Benutzer ohne sudo-Rechte wurde getestet.
- Schutzverhalten bei verweigertem Zugriff wurde nachgewiesen.
- Dokumentation liegt im Repository vor.
