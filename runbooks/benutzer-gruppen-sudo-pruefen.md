# Runbook: Benutzer, Gruppen und sudo prüfen

## Zweck

Dieses Runbook beschreibt eine wiederholbare Prüfung von Benutzeridentität, Gruppenmitgliedschaften, sudo-Rechten und einfachen Rechteunterschieden zwischen administrativ berechtigtem Benutzer und normalem Benutzer.

Das Runbook gehört zu Lab 02 des Linux-Junior-Admin-/Cloud-Ops-Lernprojekts.

## Ausgangslage

Im Lab existieren mindestens zwei Benutzerrollen:

- `marc` als administrativ berechtigter Lab-Benutzer
- `labuser01` als Testbenutzer ohne sudo-Rechte

Die technischen Nachweise liegen unter:

- `docs/operations/user-groups-sudo-baseline.txt`
- `docs/operations/testbenutzer-ohne-sudo-baseline.txt`
- `docs/operations/benutzer-gruppen-sudo-einordnung.md`

## Voraussetzungen

- Zugriff auf das Ubuntu-Lab-System
- Terminalzugang als administrativ berechtigter Benutzer
- sudo-Rechte für administrative Prüfungen
- vorhandenes Projektverzeichnis `~/projects/ubuntu-lab-baseline`

## Schritt 1: Aktuellen Benutzer prüfen

Befehl:

~~~bash
whoami
~~~

Erwartung:

~~~text
marc
~~~

Bedeutung:

Der Befehl zeigt, mit welchem Benutzerkonto aktuell gearbeitet wird.

## Schritt 2: Benutzer-ID und Gruppen prüfen

Befehl:

~~~bash
id
~~~

Bedeutung:

`id` zeigt die Benutzer-ID, die primäre Gruppe und alle zusätzlichen Gruppenmitgliedschaften des aktuellen Benutzers.

Wichtige Gruppen im Lab:

- `sudo` für administrative Befehle
- `adm` für bestimmte Log-Zugriffe
- `lxd` für LXD-Containerverwaltung
- `lpadmin` für Druckeradministration
- `plugdev` für bestimmte Gerätezugriffe

## Schritt 3: Gruppen kompakt anzeigen

Befehl:

~~~bash
groups
~~~

Bedeutung:

`groups` zeigt die Gruppenmitgliedschaften kompakter als `id`.

## Schritt 4: Benutzer aus der Systemdatenbank prüfen

Befehl:

~~~bash
getent passwd marc
~~~

Bedeutung:

`getent passwd` liest den Benutzer aus der Systemdatenbank. Dabei werden lokale Benutzer und mögliche zentrale Benutzerquellen einheitlich abgefragt.

Wichtige Felder:

~~~text
Benutzername:Passwortplatzhalter:UID:GID:Kommentar:Home-Verzeichnis:Login-Shell
~~~

## Schritt 5: sudo-Gruppe prüfen

Befehl:

~~~bash
getent group sudo
~~~

Bedeutung:

Dieser Befehl zeigt, welche Benutzer Mitglied der Gruppe `sudo` sind.

Betriebliche Bedeutung:

Mitgliedschaft in `sudo` bedeutet in Ubuntu typischerweise, dass ein Benutzer administrative Befehle mit `sudo` ausführen darf.

## Schritt 6: sudo-Rechte prüfen

Befehl:

~~~bash
sudo -l
~~~

Bedeutung:

`sudo -l` zeigt, welche Befehle der aktuelle Benutzer mit sudo ausführen darf.

Beispielausgabe:

~~~text
(ALL : ALL) ALL
~~~

Betriebliche Einordnung:

Diese Ausgabe bedeutet sehr weitreichende administrative Rechte. Im Lab ist das sinnvoll. In Production sollte diese Berechtigung begründet, dokumentiert und kontrolliert sein.

## Schritt 7: Home-Verzeichnis prüfen

Befehl:

~~~bash
ls -ld /home/marc
~~~

Bedeutung:

`ls -ld` zeigt Rechte, Besitzer, Gruppe und Metadaten des Home-Verzeichnisses selbst.

Beispiel:

~~~text
drwxr-x--- marc marc /home/marc
~~~

Betriebliche Einordnung:

Andere Benutzer sollten keinen unkontrollierten Zugriff auf persönliche Home-Verzeichnisse erhalten.

## Schritt 8: Testbenutzer ohne sudo-Rechte prüfen

Befehl:

~~~bash
id labuser01
groups labuser01
~~~

Erwartung:

Der Benutzer `labuser01` sollte nur Mitglied seiner eigenen Gruppe sein und nicht in `sudo` erscheinen.

## Schritt 9: Befehl als Testbenutzer ausführen

Befehl:

~~~bash
sudo -u labuser01 bash -lc 'whoami; id; pwd'
~~~

Bedeutung:

Der Befehl führt eine kleine Shell-Prüfung als Benutzer `labuser01` aus.

Wichtige Optionen:

- `sudo -u labuser01` führt den Befehl als anderer Benutzer aus.
- `bash -lc` startet eine Bash und führt den übergebenen Befehl aus.
- `whoami` prüft die aktive Benutzeridentität.
- `id` prüft die Gruppenrechte.
- `pwd` zeigt den aktuellen Arbeitsordner.

Hinweis:

Der Benutzerwechsel ändert nicht automatisch den Arbeitsordner. Es ist daher normal, wenn `pwd` weiterhin auf das aktuelle Projektverzeichnis zeigt.

## Schritt 10: sudo-Verweigerung testen

Befehl:

~~~bash
sudo -u labuser01 bash -lc 'sudo -n true'
echo $?
~~~

Erwartung:

Der Befehl soll fehlschlagen, weil `labuser01` keine sudo-Rechte besitzt.

Betriebliche Bedeutung:

Ein normaler Benutzer ohne Adminrechte darf keine administrativen Befehle ausführen.

## Schritt 11: Zugriff auf sensible Systemdatei testen

Befehl:

~~~bash
sudo -u labuser01 bash -lc 'head -n 1 /etc/shadow'
echo $?
~~~

Erwartung:

Der Zugriff soll mit `Permission denied` abgelehnt werden.

Betriebliche Bedeutung:

`/etc/shadow` enthält sensible Passwort-Hash-Informationen. Normale Benutzer dürfen diese Datei nicht lesen.

## Risiko

Zu weitreichende Gruppenrechte können zu Sicherheitsproblemen führen. Besonders relevante Gruppen sind:

- `sudo`
- `lxd`
- `docker`
- `adm`

Diese Gruppen sollten in produktiven Umgebungen nur vergeben werden, wenn sie fachlich notwendig sind.

## Rollback im Lab

Falls der Testbenutzer entfernt werden soll:

~~~bash
sudo userdel -r labuser01
~~~

Bedeutung:

- `userdel` löscht den Benutzer.
- `-r` entfernt zusätzlich das Home-Verzeichnis und die Mail-Spool-Datei des Benutzers.

Achtung:

Dieser Befehl löscht Daten des Benutzers. Vorher prüfen, ob relevante Dateien gesichert werden müssen.

## Verifikation

Nach der Prüfung sollten folgende Punkte erfüllt sein:

- aktueller Benutzer wurde identifiziert
- Gruppenmitgliedschaften wurden geprüft
- sudo-Rechte wurden bewertet
- Testbenutzer ohne sudo-Rechte wurde geprüft
- Zugriff auf administrative Funktionen wurde korrekt verweigert
- Ergebnisse wurden dokumentiert

## Lab-vs-Production-Einordnung

Im Lab ist ein stark berechtigter Hauptbenutzer sinnvoll, um Administration und Diagnose zu üben.

In Production sollte gelten:

- minimale notwendige Rechte vergeben
- administrative Rechte dokumentieren
- sudo-Nutzung nachvollziehbar halten
- kritische Gruppenmitgliedschaften regelmäßig prüfen
- normale Benutzerkonten von Admin-Konten trennen
