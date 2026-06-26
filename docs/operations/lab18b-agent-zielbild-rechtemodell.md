# Lab18b – Agent-Zielbild und Rechtemodell

## Zweck

Dieses Dokument beschreibt das Zielbild für einen lokalen Monitoring-Agenten im Lab. Der Agent soll Prüfungen regelmäßig, kontrolliert, nachvollziehbar und mit möglichst geringen Rechten ausführen.

## Grundidee des Agenten

Ein Agent ist ein lokaler Prüfer auf dem System. Er sammelt Zustände vor Ort und macht sie später für Monitoring, Logs oder Auswertung nutzbar.

Merksatz:

Nicht die Monitoring-Zentrale bekommt den Generalschlüssel. Jeder Server bekommt einen kleinen, kontrollierten Hausmeister.

## Agent-Kette

| Baustein | Aufgabe |
|---|---|
| Skript | führt die eigentlichen Checks aus |
| systemd-Service | startet den Check kontrolliert |
| systemd-Timer | führt den Check regelmäßig aus |
| journalctl | macht Ausführung und Ergebnis nachvollziehbar |
| Rechtemodell | begrenzt, was der Agent darf |
| Runbook | erklärt Bewertung und Reaktion |

## Check-Klassen aus Lab18a

| Check-Klasse | Beispiele | Rechtebedarf | Bewertung |
|---|---|---|---|
| einfache Checks | systemctl is-active, df, getent, ss ohne Prozessdetails | normaler Benutzer reicht | agent-tauglich für ersten Aufbau |
| privilegierte Checks | du /var/log, find /var/log, lsof +L1 | benötigt kontrollierte erhöhte Rechte | später gesondert absichern |

## Was der Agent im ersten Schritt darf

- Dienstzustände lesen.
- Speicherplatz und Inodes lesen.
- DNS-Auflösung testen.
- lauschende Ports ohne Prozessdetails prüfen.
- Ergebnisse ausgeben und später protokollieren.

## Was der Agent im ersten Schritt nicht darf

- Dienste starten, stoppen oder neustarten.
- Firewall-Regeln ändern.
- Dateien löschen oder verändern.
- sudo-Rechte pauschal nutzen.
- private Rohdaten ungefiltert öffentlich schreiben.

## BSI-orientierte Einordnung

Das Zielbild orientiert sich am BSI-IT-Grundschutz-Gedanken. Es wird keine Zertifizierung behauptet. Die Orientierung liegt auf sicherem, nachvollziehbarem und betreibbarem Systembetrieb.

Wichtige Prinzipien:

- Least Privilege: nur notwendige Rechte vergeben.
- Kontrollierte Ausführung: Ausführung über systemd statt zufällige manuelle Starts.
- Nachvollziehbarkeit: Ergebnisse später über journalctl oder Logs prüfen.
- Auditierbarkeit: sicherheitsrelevante Prüfungen nachvollziehbar machen.
- Datenminimierung: keine unnötigen Systemdetails öffentlich speichern.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Agent-Ausführung | lokales Skript und später systemd-Timer | zentral verwalteter Agent, Richtlinien und Monitoring-Anbindung |
| Rechte | möglichst ohne sudo starten | dediziertes Servicekonto, minimale sudoers-Regeln oder native Agent-Rechte |
| Logs | journalctl lokal | zentrale Logplattform, SIEM oder Monitoring-System |
| Änderungen | read-only | read-only bevorzugt, Änderungen nur über kontrollierte Automatisierung |
| Sicherheitsbewertung | Lernmodell | Teil des Betriebs- und Sicherheitskonzepts |

## Nächster Schritt

Der nächste praktische Schritt ist ein erster systemd-Service, der den vorhandenen Healthcheck kontrolliert ausführt. Danach folgt ein systemd-Timer für regelmäßige Ausführung.

## Merksatz

Ein Agent ist kein Admin-Ersatz. Ein Agent ist ein kontrollierter Messfühler mit begrenztem Auftrag.
