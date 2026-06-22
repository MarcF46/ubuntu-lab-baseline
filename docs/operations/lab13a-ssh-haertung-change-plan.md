# Lab 13a – SSH-Härtung als kontrollierter Change-Plan

## Ziel

Im Lab wurde ein kontrollierter Change-Plan für spätere SSH-Härtung erstellt. Es werden noch keine produktiven Änderungen durchgeführt. Ziel ist, die in Lab 13 gefundenen Härtungskandidaten sicher zu bewerten und einen Rückfallweg zu planen.

## Typisches Betriebsszenario

Ein Team erkennt in einer Security-Baseline mehrere Härtungskandidaten. Änderungen an SSH dürfen nicht spontan durchgeführt werden, weil ein Fehler den administrativen Zugriff auf das System blockieren kann.

## Aktueller technischer Zustand

- SSH Dienststatus: active
- SSH Autostartstatus: enabled
- SSH Port 22 lokal sichtbar: ja
- PermitRootLogin: prohibit-password
- PasswordAuthentication: yes
- PubkeyAuthentication: yes
- PermitEmptyPasswords: no
- X11Forwarding: yes

## Härtungskandidaten

### 1. PasswordAuthentication

PasswordAuthentication ist ein Härtungskandidat, wenn Key-basierter SSH-Zugriff zuverlässig funktioniert. Eine Deaktivierung darf erst erfolgen, wenn ein zweiter Login-Test mit SSH-Key erfolgreich war und ein Rückfallweg existiert.

### 2. X11Forwarding

X11Forwarding ist ein Härtungskandidat, wenn keine grafische Weiterleitung über SSH benötigt wird. Eine Deaktivierung reduziert unnötige Funktionalität.

### 3. Firewall-Zustand

UFW ist ein separater Härtungskandidat. Die Aktivierung einer Firewall wird nicht zusammen mit SSH-Änderungen durchgeführt, sondern als eigener kontrollierter Change geplant.

## Nicht in diesem Change enthalten

- keine sofortige Änderung an /etc/ssh/sshd_config
- keine sofortige Änderung an UFW-Regeln
- keine Deaktivierung von Passwortlogin ohne erfolgreichen Key-Test
- keine Änderung ohne Syntaxprüfung
- keine Änderung ohne Rollback-Plan

## Sicherer Ablauf für spätere Umsetzung

1. bestehenden SSH-Zustand dokumentieren.
2. aktuelle Sitzung offen lassen.
3. SSH-Konfiguration sichern.
4. geplante Änderung minimal halten.
5. Syntax mit sshd -t prüfen.
6. SSH per reload neu laden, nicht unnötig hart restarten.
7. zweite neue SSH-Sitzung testen.
8. Health-Check erneut ausführen.
9. Ergebnis dokumentieren.
10. erst danach Commit erstellen.

## Rollback-Idee

Vor einer echten Änderung muss eine Sicherung der SSH-Konfiguration erstellt werden. Wenn der neue Login-Test scheitert, bleibt die alte Sitzung offen, die Sicherung wird zurückkopiert, die Konfiguration mit sshd -t geprüft und SSH per reload neu geladen.

## Betriebliche Bewertung

Die erkannten Security-Befunde sind keine akuten kritischen Fehler, sondern kontrolliert zu planende Härtungskandidaten. Der wichtigste Risikopunkt ist der mögliche Verlust des Admin-Zugriffs durch falsche SSH- oder Firewall-Änderungen.

## Nächster professioneller Schritt

Als nächster Schritt wird eine praktische, sichere SSH-Preflight-Prüfung erstellt. Erst danach kann eine kleine Härtungsänderung im Lab geplant werden.

## Merksätze

- SSH ist die Admin-Haustür.
- Keine Härtung ohne Rückweg.
- Alte Sitzung offen lassen, neue Sitzung testen.
- Erst Syntax prüfen, dann reload.
- Security-Change ist Änderung am Betrieb, nicht nur ein Text in einer Config.
