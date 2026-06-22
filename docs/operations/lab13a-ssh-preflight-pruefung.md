# Lab 13a – SSH-Preflight-Prüfung

## Ziel

Im Lab wurde eine SSH-Preflight-Prüfung durchgeführt. Ziel war die sichere Vorbereitung einer möglichen späteren SSH-Härtung, ohne bereits Änderungen an der SSH-Konfiguration vorzunehmen.

## Typisches Betriebsszenario

Vor Änderungen an SSH muss geprüft werden, ob Dienst, Syntax, Key-Login und Rückfallweg funktionieren. Dadurch wird verhindert, dass eine Härtung den administrativen Zugriff blockiert.

## Technischer Nachweis

Der vollständige Rohoutput und die private Sicherung der SSH-Konfiguration wurden bewusst privat abgelegt:

- docs/private/evidence/lab13a-ssh-hardening/lab13a-ssh-preflight-raw.txt
- docs/private/evidence/lab13a-ssh-hardening/sshd_config.preflight-backup

## Beobachteter Zustand

- SSH Dienststatus: active
- SSH Autostartstatus: enabled
- SSH Port 22 lokal sichtbar: ja
- PermitRootLogin: prohibit-password
- PasswordAuthentication: yes
- PubkeyAuthentication: yes
- PermitEmptyPasswords: no
- X11Forwarding: yes
- SSH Syntaxprüfung Exit-Code: 0
- SSH Key-Login localhost Exit-Code: 0
- Preflight-Ergebnis: bereit_fuer_geplanten_lab_change

## Betriebliche Bewertung

Die SSH-Syntaxprüfung und der Key-Login-Test sind zentrale Sicherheitsprüfungen vor jeder SSH-Härtung. Eine spätere Änderung an PasswordAuthentication oder X11Forwarding darf nur erfolgen, wenn die bestehende Sitzung offen bleibt, ein neuer Login getestet wird und ein Rollback-Pfad vorhanden ist.

## Nicht geändert

- keine Änderung an /etc/ssh/sshd_config
- kein Reload oder Restart von SSH
- keine Änderung an UFW
- keine Deaktivierung von Passwortlogin

## Nächster professioneller Schritt

Als nächster Schritt kann eine kleine, klar begrenzte SSH-Härtung als kontrollierter Lab-Change geplant werden. Geeigneter erster Kandidat ist X11Forwarding, weil diese Änderung normalerweise weniger kritisch ist als die sofortige Deaktivierung von PasswordAuthentication.

## Merksätze

- Preflight ist der Sicherheitscheck vor dem Abheben.
- SSH ist die Admin-Haustür.
- Alte Sitzung offen lassen, neue Sitzung testen.
- Erst Syntax prüfen, dann reload.
- Keine Härtung ohne Rückweg.
