# Lab 16 – Arbeitsauftrag: Logrotate und Log-Aufbewahrung

## Ausgangslage

Das Lab-System enthält inzwischen mehrere sicherheits- und betriebsrelevante Dienste. Besonders auditd erzeugt Nachweise über Änderungen an sensiblen Systemdateien. Zusätzlich existieren Logs von SSH, Fail2ban, UFW, systemd/journald und weiteren Systemdiensten.

Ohne geregelte Log-Aufbewahrung können zwei gegensätzliche Probleme entstehen:

- Logs wachsen unkontrolliert und belegen zu viel Speicherplatz.
- Logs werden zu früh oder unkontrolliert gelöscht und fehlen später bei Diagnose, Audit oder Incident Response.

## Auftrag

Es soll geprüft und dokumentiert werden, wie Logrotation auf dem System funktioniert und wie relevante Logdateien kontrolliert aufbewahrt werden.

Der Schwerpunkt liegt auf Verständnis, Prüfung und sicherer Einordnung, nicht auf aggressiver Änderung produktionsnaher Einstellungen.

## Anforderungen

- logrotate Installation und Status prüfen
- vorhandene logrotate-Konfigurationen identifizieren
- relevante Systempfade prüfen
- auditd-Logrotation gesondert einordnen
- journald-Aufbewahrung grob einordnen
- Risiken bei falscher Logrotation dokumentieren
- Health-Check oder Prüfskript vorbereiten
- Lab-vs-Production-Unterschiede festhalten

## Erfolgskriterien

- Es ist klar, ob logrotate installiert ist.
- Die wichtigsten Konfigurationspfade sind bekannt.
- Mindestens eine bestehende logrotate-Konfiguration wurde gelesen und verstanden.
- auditd-Logs wurden bewusst als besonderer Fall erkannt.
- Es gibt eine dokumentierte betriebliche Bewertung.
- Es wird nichts gelöscht, was später noch als Nachweis gebraucht wird.

## Risiken

- Zu kurze Aufbewahrung kann wichtige Diagnose- oder Auditdaten vernichten.
- Zu lange Aufbewahrung kann Speicherplatzprobleme erzeugen.
- Falsche Rotation kann Dienste stören oder Logs unlesbar machen.
- Komprimierte Logs müssen bei Analyse bewusst berücksichtigt werden.
- Datenschutz und Zugriffsschutz sind bei Logs besonders wichtig.

## Rollback

In dieser ersten Lab16-Phase werden nur vorhandene Konfigurationen gelesen und dokumentiert. Es werden keine produktiven Rotationseinstellungen verändert.

Falls später Änderungen vorgenommen werden, müssen vorher Backups der betroffenen Konfigurationsdateien erstellt und ein Rückbau dokumentiert werden.

## Betriebliche Einordnung

Logrotation ist kein reines Aufräumthema. Sie verbindet Betriebssicherheit, Speicherplatzmanagement, Incident Response, Datenschutz und Nachweisfähigkeit.

Besonders bei Security-Logs gilt:

- Zu wenig Logging erschwert Aufklärung.
- Zu viel Logging kann Systeme belasten.
- Falsche Aufbewahrung kann Compliance- und Datenschutzrisiken erzeugen.

## Merksätze

- Logs sind Spuren, aber Spuren brauchen Ordnung.
- Rotation ist nicht Löschen, sondern kontrolliertes Weiterreichen.
- Speicher voll ist ein Betriebsproblem. Fehlende Logs sind ein Diagnoseproblem.
- Rohdaten brauchen Schutz, Zusammenfassungen brauchen Kontext.
