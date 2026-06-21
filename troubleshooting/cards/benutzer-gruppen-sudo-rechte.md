# Troubleshooting-Karte: Benutzer, Gruppen und sudo-Rechte

## Zweck

Diese Karte unterstützt bei typischen Problemen mit Benutzerkonten, Gruppenmitgliedschaften, sudo-Rechten und Dateiberechtigungen auf einem Ubuntu-System.

## Symptom 1: sudo wird verweigert

Typische Meldungen:

- sudo wird abgelehnt
- Benutzer ist nicht in der sudo-Gruppe
- Benutzer darf keine administrativen Befehle ausführen

Prüfung mit echtem Benutzernamen, zum Beispiel labuser01:

    id labuser01
    groups labuser01
    getent group sudo

Bewertung:

Wenn ein normaler Benutzer keine sudo-Rechte besitzt, ist die Verweigerung korrektes Schutzverhalten.

## Symptom 2: Zugriff auf /etc/shadow wird verweigert

Typische Meldung:

    Permission denied

Prüfung:

    ls -l /etc/shadow
    id labuser01

Bewertung:

Bei /etc/shadow ist die Zugriffssperre für normale Benutzer korrekt. Diese Datei enthält sensible Passwort-Hash-Informationen.

## Symptom 3: Benutzer hat unerwartet zu viele Rechte

Prüfung:

    id marc
    groups marc
    getent group sudo
    getent group lxd
    getent group docker
    getent group adm

Besonders relevante Gruppen:

- sudo
- lxd
- docker
- adm

Bewertung:

Zu weitreichende Gruppenrechte erhöhen das Risiko von Fehlbedienung, Missbrauch oder größerem Schaden bei kompromittierten Benutzerkonten.

## Symptom 4: Benutzerwechsel funktioniert, aber Arbeitsordner bleibt gleich

Beispiel:

    sudo -u labuser01 bash -lc 'whoami; id; pwd'

Bewertung:

Das ist normal. sudo -u wechselt den Benutzer, aber nicht automatisch in dessen Home-Verzeichnis.

Login-ähnliche Alternative:

    sudo -iu labuser01

Interaktive Benutzerwechsel werden mit folgendem Befehl beendet:

    exit

## Symptom 5: Home-Verzeichnis-Rechte prüfen

Prüfung:

    ls -ld /home/marc
    ls -ld /home/labuser01

Bewertung:

Andere Benutzer sollten nicht unkontrolliert auf persönliche Home-Verzeichnisse zugreifen können. Zu offene Rechte können Daten preisgeben.

## Sofortmaßnahmen im Lab

Bei unerwarteten Rechten:

    id marc
    id labuser01
    groups marc
    groups labuser01
    getent group sudo
    sudo -l

Bei unerwarteter sudo-Mitgliedschaft eines Testbenutzers:

    sudo deluser labuser01 sudo

Achtung:

Vor dem Entzug von sudo-Rechten sollte geprüft werden, ob mindestens ein anderer administrativer Zugang vorhanden ist.

## Rollback für den Testbenutzer

Falls der Testbenutzer entfernt werden soll:

    sudo userdel -r labuser01

Bedeutung:

- userdel entfernt das Benutzerkonto.
- -r entfernt zusätzlich das Home-Verzeichnis und zugehörige Benutzerdaten.

## Professionelle Statusmeldung

Benutzer- und Gruppenrechte wurden geprüft. Der administrative Lab-Benutzer besitzt erwartungsgemäß sudo-Rechte. Der Testbenutzer ohne sudo-Rechte konnte keine administrativen Befehle ausführen und keinen Zugriff auf /etc/shadow erhalten. Das Schutzverhalten entspricht der erwarteten Rechtevergabe.

## Lab-vs-Production-Einordnung

Im Lab dienen starke Rechte der Lern- und Administrationsfähigkeit.

In Production sollten Benutzerrechte nach dem Prinzip der minimal notwendigen Rechte vergeben werden. Kritische Gruppenmitgliedschaften wie sudo, lxd, docker und adm sollten regelmäßig geprüft, dokumentiert und fachlich begründet sein.
