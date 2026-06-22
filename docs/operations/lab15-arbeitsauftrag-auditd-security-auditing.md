# Lab 15 – Arbeitsauftrag: auditd Security-Auditing

## Ticket / Arbeitsauftrag

Ein Ubuntu-Lab-Server wurde bereits mit SSH-Key-Login, deaktiviertem Passwortlogin, deaktiviertem X11Forwarding, aktiver UFW-Host-Firewall und Fail2ban für SSH geschützt.

Als nächster Security-Baustein soll geprüft werden, ob auditd als Audit-Dienst für sicherheitsrelevante Ereignisse eingesetzt werden kann. Ziel ist, sicherheitsrelevante Aktionen nachvollziehbarer zu machen, ohne das System unnötig zu belasten oder unkontrolliert große Logmengen zu erzeugen.

## Ausgangslage

- SSH-Key-Login ist aktiv.
- PasswordAuthentication ist deaktiviert.
- X11Forwarding ist deaktiviert.
- UFW ist aktiv.
- Fail2ban ist aktiv.
- sshd-Jail ist aktiv.
- Security-Health-Check ist erfolgreich.
- Fail2ban-Health-Check ist erfolgreich.
- auditd wurde in diesem Lab noch nicht geprüft oder eingerichtet.

## Anforderungen

- auditd-Paketstatus prüfen.
- auditd-Dienststatus prüfen.
- vorhandene Audit-Konfiguration prüfen.
- sichere Basisregeln für typische Linux-Admin-Sicherheitsereignisse planen.
- Änderungen an sensiblen Dateien wie /etc/passwd, /etc/shadow, /etc/group und /etc/sudoers als mögliche Audit-Ziele bewerten.
- sudo- und Admin-relevante Ereignisse fachlich einordnen.
- Audit-Logs prüfen.
- wiederverwendbaren Audit-Health-Check vorbereiten.
- Lab-vs-Production-Unterschiede dokumentieren.

## Erfolgskriterien

- auditd ist installiert oder sein Fehlen ist sauber dokumentiert.
- auditd-Dienststatus ist bekannt.
- Audit-Konfiguration wurde geprüft.
- sinnvolle Audit-Ziele wurden fachlich begründet.
- keine sensiblen Logdaten werden öffentlich dokumentiert.
- Rohdaten werden nur unter docs/private/evidence abgelegt.
- öffentliche Dokumentation enthält nur zusammengefasste Bewertung.
- Git-Arbeitsstand ist nach jedem Schritt sauber.

## Risiken

- Zu viele Audit-Regeln können große Logmengen erzeugen.
- Falsch gesetzte Audit-Regeln können Performance und Übersichtlichkeit verschlechtern.
- Audit-Logs können sensible Informationen enthalten.
- In Produktion müssen Datenschutz, Aufbewahrung, Zugriffsschutz und SIEM-Anbindung berücksichtigt werden.
- Ein Audit-System ersetzt keine Härtung, kein Monitoring und keine Zugriffskontrolle.

## Rollback-Idee

Bei Problemen können neue Audit-Regeln deaktiviert oder entfernt werden. Danach wird auditd neu geladen oder neu gestartet und der Zustand erneut geprüft. Bestehende Systemhärtung wie SSH, UFW und Fail2ban bleibt unverändert.

## Betriebliche Einordnung

auditd ergänzt die vorhandenen Schutzschichten um Nachvollziehbarkeit. Während UFW Verbindungen begrenzt und Fail2ban auf auffällige Login-Fehler reagiert, hilft auditd bei der späteren Analyse sicherheitsrelevanter Aktionen auf dem System.

## Merksätze

- Logs zeigen, was passiert ist.
- Auditing zeigt, wer sicherheitsrelevant etwas getan hat.
- Schutz verhindert nicht alles; Nachvollziehbarkeit ist Teil von Sicherheit.
- Audit-Regeln müssen gezielt sein, nicht maximal laut.
- Rohdaten privat, Bewertung öffentlich.
