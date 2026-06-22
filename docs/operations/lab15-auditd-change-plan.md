# Lab 15 – auditd Security-Auditing Change-Plan

## Ziel

Im Lab wird geprüft, ob auditd als Audit-Dienst für sicherheitsrelevante Linux-Ereignisse eingesetzt werden kann. Der Fokus liegt zunächst auf kontrollierter Bestandsaufnahme und einer sicheren Planung, nicht auf maximaler Protokollierung.

## Beobachteter Zustand

- auditd Paketstatus: nicht_installiert
- auditctl Pfad: nicht_gefunden
- ausearch Pfad: nicht_gefunden
- aureport Pfad: nicht_gefunden
- auditd Unit-Datei: nicht_ermittelt
- auditd Dienststatus: inactive
nicht_aktiv
- auditd Autostartstatus: not-found
nicht_enabled
- /etc/audit/auditd.conf: nicht_vorhanden
- /etc/audit/rules.d: nicht_vorhanden
- /var/log/audit/audit.log: nicht_vorhanden

## Geplanter Ablauf

1. auditd-Paketstatus und Werkzeuge prüfen.
2. auditd installieren, falls nicht vorhanden.
3. Dienststatus und Autostart prüfen.
4. vorhandene Konfiguration kontrollieren.
5. Basisregeln für ausgewählte sicherheitsrelevante Dateien planen.
6. Audit-Regeln kontrolliert aktivieren.
7. Audit-Status und Regelzustand prüfen.
8. wiederverwendbaren Health-Check erstellen.
9. Ergebnis dokumentieren.

## Geplante Audit-Ziele

Für das Lab kommen als erste sinnvolle Audit-Ziele infrage:

- /etc/passwd
- /etc/shadow
- /etc/group
- /etc/sudoers
- /etc/sudoers.d/

Diese Dateien betreffen Benutzer, Gruppen, Passwort-/Shadow-Daten und administrative Rechte.

## Risiken

Audit-Regeln können große Logmengen erzeugen. Audit-Logs können sensible Informationen enthalten. Deshalb werden Rohdaten nur unter docs/private/evidence abgelegt. Öffentliche Dokumentation enthält nur technische Zusammenfassungen und Bewertungen.

## Rollback-Idee

Neue Audit-Regeln werden als eigene Lab-Regeldatei abgelegt. Bei Problemen kann diese Datei entfernt oder deaktiviert werden. Anschließend werden die Audit-Regeln neu geladen und der Zustand erneut geprüft.

## Betriebliche Einordnung

auditd ergänzt vorhandene Schutzschichten um Nachvollziehbarkeit. Es verhindert Angriffe nicht direkt, hilft aber bei späterer Analyse, Prüfung und Forensik.

## Merksätze

- Logs zeigen, was passiert ist.
- Auditing zeigt, wer sicherheitsrelevant etwas getan hat.
- Audit-Regeln müssen gezielt sein, nicht maximal laut.
- Rohdaten privat, Bewertung öffentlich.
