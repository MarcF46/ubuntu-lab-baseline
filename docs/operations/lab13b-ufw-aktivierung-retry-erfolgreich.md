# Lab 13b – UFW-Aktivierung Retry

## Ziel

Im Lab wurde die UFW-Aktivierung nach einem fehlgeschlagenen ersten SSH-Test erneut durchgeführt. Die Ursache des ersten Fehlversuchs lag im SSH-known_hosts-Verhalten, nicht in UFW selbst.

## Beobachteter Zustand

- UFW vorher: Status: Inaktiv
- UFW nachher: Status: Aktiv
- SSH vor UFW Exit-Code: 0
- SSH nach UFW Exit-Code: 0
- Security Health Check Exit-Code: 0
- Rollback: nicht_noetig
- Change-Ergebnis: erfolgreich

## Umgesetzte Regeln

- Default incoming: deny
- Default outgoing: allow
- SSH Port 22/tcp: allow

## Betriebliche Bewertung

Die Firewall wurde erst nach erfolgreichem SSH-Test und gesetzter SSH-Allow-Regel aktiviert. Der SSH-Zugriff wurde nach der Aktivierung erneut geprüft. Der vorherige Fehlversuch wurde als realistischer Precheck-/known_hosts-Fehler eingeordnet.

## Merksätze

- known_hosts ist das Ausweiskontrollbuch von SSH.
- Erst SSH erlauben, dann Firewall aktivieren.
- Nach dem Change zählt der neue Login-Test.
