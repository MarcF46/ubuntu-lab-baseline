# Lab18a – Agent-Rechte-Vorprüfung: öffentliche Bewertung

## Zweck

Diese Bewertung fasst die private Agent-Rechte-Vorprüfung zusammen. Ziel ist zu erkennen, welche Monitoring-Checks ohne zusätzliche Rechte funktionieren und welche Checks für automatische Ausführung ein kontrolliertes Rechtemodell benötigen.

## Kernergebnis

Viele grundlegende Service- und Systemchecks funktionieren ohne sudo. Tiefere Log- und Dateisystemprüfungen benötigen dagegen sudo oder ein anderes kontrolliertes Ausführungsmodell.

## Ergebnisübersicht

| Prüfbereich | Ergebnis | Bewertung |
|---|---|---|
| Dienststatus über systemctl | ohne sudo möglich | gut für einfache Agent-Checks geeignet |
| TCP-Portübersicht ohne Prozessdetails | ohne sudo möglich | geeignet für einfache Erreichbarkeitsprüfung |
| DNS-Auflösung | ohne sudo möglich | geeignet für Funktionscheck |
| Speicherplatz mit df -h | ohne sudo möglich | geeignet für Basis-Monitoring |
| Inodes mit df -i | ohne sudo möglich | geeignet für Basis-Monitoring |
| sudo ohne Passwortabfrage | nicht möglich | Agent würde ohne Rechtemodell hängen oder fehlschlagen |
| /var/log-Größe mit sudo -n | nicht möglich | benötigt später kontrollierte Rechte oder anderen Ansatz |
| Logdateisuche mit sudo -n | nicht möglich | benötigt später kontrollierte Rechte oder anderen Ansatz |
| lsof für gelöschte offene Dateien mit sudo -n | nicht möglich | benötigt später kontrollierte Rechte oder anderen Ansatz |

## Bedeutung für den Agenten

Ein Agent darf nicht interaktiv nach einem Passwort fragen. Automatisierte Checks müssen wiederholbar, nicht-interaktiv und eindeutig auswertbar laufen.

Die Vorprüfung zeigt deshalb zwei Klassen von Checks:

| Klasse | Beschreibung | Beispiel |
|---|---|---|
| einfache Checks | funktionieren ohne erhöhte Rechte | systemctl is-active, df, getent, ss ohne Prozessdetails |
| privilegierte Checks | benötigen kontrollierte Rechte | sudo du, sudo find, sudo lsof |

## BSI-orientierte Einordnung

Diese Bewertung orientiert sich am Gedanken des BSI-IT-Grundschutzes: Rechte sollen nachvollziehbar, minimal, kontrolliert und dokumentiert vergeben werden.

Es handelt sich nicht um eine BSI-Zertifizierung, sondern um eine fachliche Orientierung an sicherem und betreibbarem Systembetrieb.

Wichtige Sicherheitsprinzipien:

- Least Privilege: nur notwendige Rechte vergeben.
- Keine pauschale Root-Ausführung für Bequemlichkeit.
- Keine Passwortabfrage in automatisierten Checks.
- Prüfbarkeit und Logging der Agent-Ausführung vorbereiten.
- Private Rohdaten nicht in öffentliche Dokumentation übernehmen.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Ausführung | manuell im Terminal | systemd-Service, Timer oder Monitoring-Agent |
| Rechte | sudo bei Bedarf manuell | minimal, dokumentiert und kontrolliert |
| Passwortabfrage | im Lab sichtbar und lehrreich | für Automatisierung ungeeignet |
| Logs | Terminal und private Evidence | journalctl, zentrale Logs, Auditierbarkeit |
| Risiko | gering im Einzelhost-Lab | kritisch bei mehreren Servern und zentralem Monitoring |

## Nächster Schritt

Der nächste Schritt ist ein Agent-Zielbild: Welche Checks laufen als normaler Benutzer, welche Checks brauchen privilegierte Ausführung und wie kann dies sicher über systemd, Timer, Logging und begrenzte Rechte abgebildet werden?

## Merksatz

Ein Agent bekommt keine Macht auf Vorrat. Er bekommt nur die Rechte, die seine Checks wirklich brauchen.
