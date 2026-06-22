# Lab 13a – PasswordAuthentication-Härtung

## Ziel

Im Lab wurde die passwortbasierte SSH-Anmeldung als kontrollierter Change deaktiviert. Ziel war, SSH stärker auf Key-basierte Anmeldung auszurichten, ohne den administrativen Zugriff zu verlieren.

## Technischer Nachweis

Der vollständige Rohoutput und die private Rollback-Sicherung wurden bewusst privat abgelegt:

- docs/private/evidence/lab13a-ssh-hardening/lab13a-password-auth-change-raw.txt
- docs/private/evidence/lab13a-ssh-hardening/91-lab13a-disable-password-authentication.conf.before-change

Die verwendete Repo-Konfigurationsvorlage liegt hier:

- configs/ssh/91-lab13a-disable-password-authentication.conf

## Beobachteter Zustand

- PasswordAuthentication vorher: yes
- PubkeyAuthentication vorher: yes
- PasswordAuthentication nachher: no
- PubkeyAuthentication nachher: yes
- SSH Syntaxprüfung Exit-Code: 0
- SSH Reload Exit-Code: 0
- SSH Key-Login nach Änderung Exit-Code: 0
- Security Health Check nach Änderung Exit-Code: 0
- Change-Ergebnis: erfolgreich

## Betriebliche Bewertung

Die Änderung deaktiviert Passwortlogin über SSH und lässt Key-basierte Anmeldung aktiv. Der Change wurde nur durchgeführt, weil vorher ein SSH-Key-Login erfolgreich getestet wurde. Nach der Änderung wurden SSH-Syntax, Reload und Key-Login erneut geprüft.

## Nicht geändert

- UFW wurde nicht aktiviert.
- Der SSH-Port wurde nicht geändert.
- PubkeyAuthentication blieb aktiv.

## Rollback-Idee

Bei Problemen kann die Drop-in-Datei entfernt oder aus der privaten Sicherung zurückgesetzt werden. Danach muss sshd -t erfolgreich laufen und SSH per reload neu geladen werden.

## Merksätze

- Passwortlogin abschalten geht erst, wenn der Schlüssel wirklich funktioniert.
- Alte Sitzung offen lassen, neue Sitzung testen.
- Erst Syntax prüfen, dann reload.
- Keine Härtung ohne Rückweg.
