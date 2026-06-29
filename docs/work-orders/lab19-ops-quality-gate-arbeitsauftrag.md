# Lab19 – Arbeitsauftrag: Ops-Quality-Gate für Monitoring-Agent

## Ausgangslage

Lab18 hat einen lokalen Monitoring-Agenten mit systemd-User-Service, systemd-User-Timer, Runbook, Incident-Karte, betriebsnaher Incident-Kette, Quality-Gate-Konzept und Offline-Notfallkarte aufgebaut.

Die wichtigsten Fehlerbilder aus Lab18 waren:

- Timer läuft nicht.
- Agent-Skript ist nicht ausführbar.
- Aktive systemd-Unit zeigt auf falschen Pfad.
- Bash-Syntaxfehler wird durch statische Prüfung erkannt.
- Private Rohdaten dürfen nicht öffentlich committed werden.
- Ein grüner Service-Start ersetzt keine statische Prüfung.

## Ziel

Lab19 automatisiert zentrale Prüfungen als Quality Gate. Das Quality Gate soll typische Fehler früh erkennen, bevor sie in Commit, Deployment oder Betrieb wandern.

## Anforderungen

Das Quality-Gate-Skript soll prüfen:

1. Repository-Kontext ist erkennbar.
2. Agent-Skript existiert.
3. Agent-Skript ist ausführbar.
4. Agent-Skript ist syntaktisch korrekt.
5. Agent-Skript enthält kein sudo.
6. Service-Unit existiert.
7. Timer-Unit existiert.
8. ExecStart zeigt auf das erwartete Agent-Skript.
9. Timer triggert den erwarteten Service.
10. systemd-Units sind prüfbar.
11. installierte User-Units weichen nicht vom Repository-Sollzustand ab.
12. Private Rohdaten sind nicht versehentlich getrackt oder staged.
13. Agent-Smoke-Test liefert einen verwertbaren Status.
14. Git-Status wird am Ende sichtbar gemacht.

## Erfolgskriterien

- Das Skript liegt unter `scripts/lab19-ops-quality-gate.sh`.
- Das Skript ist ausführbar.
- Das Skript liefert verständliche OK-, WARNING- und CRITICAL-Meldungen.
- Das Skript beendet sich mit Exit-Code 0, 1 oder 2.
- Das Ergebnis kann später in Runbooks, Pre-Commit-Hooks oder CI/CD-Pipelines weiterverwendet werden.

## Lab-vs-Production

Im Lab wird das Quality Gate lokal ausgeführt. In produktionsnahen Umgebungen wären ähnliche Prüfungen Teil von Pre-Commit-Hooks, CI/CD-Pipelines, Staging-Deployments oder zentralen Release-Prozessen.

## BSI-orientierte Einordnung

Das Quality Gate unterstützt Nachvollziehbarkeit, Änderungsprüfung, minimal notwendige Rechte, dokumentierte Recovery und Schutz vor versehentlicher Veröffentlichung privater Rohdaten.

## Merksatz

Ein Quality Gate ist kein Ersatz für Verständnis. Es ist ein Sicherheitsnetz gegen bekannte und wiederholbare Fehler.
