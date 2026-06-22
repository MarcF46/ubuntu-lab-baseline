# Lab 13a – X11Forwarding-Härtung

## Ziel

Im Lab wurde X11Forwarding als kleiner kontrollierter SSH-Härtungschange deaktiviert. Ziel war, eine nicht benötigte SSH-Funktion zu reduzieren, ohne den normalen SSH-Key-Zugriff zu gefährden.

## Typisches Betriebsszenario

Ein Security-Baseline-Check zeigt X11Forwarding als Härtungskandidat. Die Änderung wird nicht direkt in der Hauptkonfiguration vorgenommen, sondern über eine kleine Drop-in-Datei mit klarer Zielsetzung, Syntaxprüfung, Reload, Login-Test und Rollback-Nachweis.

## Technischer Nachweis

Der vollständige Rohoutput und die private Rollback-Sicherung wurden bewusst privat abgelegt:

- docs/private/evidence/lab13a-ssh-hardening/lab13a-x11forwarding-change-raw.txt
- docs/private/evidence/lab13a-ssh-hardening/90-lab13a-disable-x11forwarding.conf.before-change

Die verwendete Repo-Konfigurationsvorlage liegt hier:

- configs/ssh/90-lab13a-disable-x11forwarding.conf

## Beobachteter Zustand

- X11Forwarding vorher: yes
- X11Forwarding nachher: no
- SSH Syntaxprüfung Exit-Code: 0
- SSH Reload Exit-Code: 0
- SSH Key-Login nach Änderung Exit-Code: 0
- Security Health Check nach Änderung Exit-Code: 0
- Change-Ergebnis: erfolgreich

## Betriebliche Bewertung

Die Änderung war bewusst klein und begrenzt. X11Forwarding wurde deaktiviert, während PasswordAuthentication unverändert blieb. Dadurch wurde ein weniger kritischer Härtungskandidat zuerst umgesetzt. Der SSH-Key-Login wurde nach der Änderung erneut geprüft.

## Nicht geändert

- PasswordAuthentication blieb unverändert.
- UFW wurde nicht aktiviert.
- SSH wurde nicht hart neu gestartet, sondern per reload neu geladen.

## Rollback-Idee

Bei Problemen kann die Drop-in-Datei entfernt oder aus der privaten Sicherung zurückgesetzt werden. Anschließend muss sshd -t erfolgreich laufen und SSH per reload neu geladen werden.

## Nächster professioneller Schritt

Als nächster Schritt wird der Security-Health-Check erneut bewertet und danach entschieden, ob PasswordAuthentication als separater, stärker abgesicherter Change geplant wird.

## Merksätze

- Kleine Änderung, klarer Zweck, vorher prüfen, nachher beweisen.
- Erst Syntax prüfen, dann reload.
- Alte Sitzung offen lassen, neue Sitzung testen.
- Keine Härtung ohne Rückweg.
