# Lab18h – Quality Gates und Schutzstufen für Monitoring-Agenten

## Zweck

Dieses Dokument beschreibt Quality Gates für den Lab18-Monitoring-Agenten. Ziel ist es, typische Fehler vor dem Betrieb zu erkennen, bevor sie zu Störungen im produktionsnahen Ablauf führen.

Ein Quality Gate ist eine kontrollierte Prüfstufe. Es verhindert nicht jeden Fehler, reduziert aber bekannte und wiederkehrende Fehlerklassen deutlich.

## Ausgangslage

In Lab18 wurden mehrere betriebsnahe Fehlerbilder nachgestellt:

- Timer läuft nicht.
- Agent-Skript ist nicht ausführbar.
- Aktive systemd-Unit zeigt auf einen falschen Pfad.
- Bash-Syntaxfehler wird durch bash -n erkannt.
- Ein Service-Lauf kann scheinbar erfolgreich sein, obwohl eine statische Prüfung bereits einen Fehler findet.

Daraus folgt: Ein grüner Service-Start allein reicht nicht als Qualitätsnachweis.

## Zielbild

Vor einem Commit, Deployment oder produktionsnahen Start sollen mindestens folgende Punkte geprüft werden:

1. Agent-Skript existiert.
2. Agent-Skript ist ausführbar.
3. Bash-Syntax ist fehlerfrei.
4. Agent-Skript enthält kein ungeprüftes sudo.
5. Service-Unit existiert.
6. Timer-Unit existiert.
7. ExecStart zeigt auf das erwartete Agent-Skript.
8. Timer triggert den erwarteten Service.
9. systemd-Units sind syntaktisch prüfbar.
10. Dokumentationsdateien enthalten keine auffälligen Formatfehler.
11. Recovery ist dokumentiert.
12. Git-Status ist vor Abschluss sauber.

## Schutzstufen

| Stufe | Prüfung | Zweck |
|---:|---|---|
| 1 | Datei vorhanden | Verhindert fehlende Artefakte |
| 2 | Datei ausführbar | Verhindert Permission denied und 203/EXEC |
| 3 | bash -n | Erkennt Bash-Syntaxfehler vor Laufzeit |
| 4 | Prüfung auf sudo | Verhindert unkontrollierte Rechteausweitung |
| 5 | Unit-Inhaltsprüfung | Verhindert falsche Pfade und falsche Targets |
| 6 | systemd-analyze verify | Prüft systemd-Service- und Timer-Dateien |
| 7 | Smoke-Test | Beweist, dass der Agent grundsätzlich läuft |
| 8 | Journal-Prüfung | Beweist, dass Logs nachvollziehbar entstehen |
| 9 | Git-Prüfung | Beweist, dass Änderungen kontrolliert sind |
| 10 | Dokumentationsprüfung | Sichert spätere Offline-Handlungsfähigkeit |

## Typische Fehler, die Quality Gates verhindern

### Fehlendes Execute-Bit

**Symptom:** Permission denied, status=203/EXEC

**Prüfung:** Dateirechte des Agent-Skripts kontrollieren.

**Recovery:** Execute-Bit wiederherstellen und Service erneut starten.

### Falscher ExecStart-Pfad

**Symptom:** No such file or directory, status=203/EXEC

**Prüfung:** Aktive Unit und Repository-Unit vergleichen.

**Recovery:** Unit aus Repository-Sollzustand zurückkopieren und daemon-reload ausführen.

### Bash-Syntaxfehler

**Symptom:** bash -n meldet Syntaxfehler, beispielsweise unexpected end of file.

**Prüfung:** bash -n vor jedem produktionsnahen Start ausführen.

**Recovery:** Fehler korrigieren oder per Git auf bekannten funktionierenden Stand zurücksetzen.

### Unkontrolliertes sudo

**Symptom:** Agent benötigt interaktive Authentifizierung oder scheitert in nicht-interaktiver Umgebung.

**Prüfung:** Agent-Skript auf sudo prüfen.

**Recovery:** Rechtemodell sauber definieren oder Agent ohne erhöhte Rechte betreiben.

## BSI-orientierte Einordnung

Quality Gates unterstützen einen nachvollziehbaren, prüfbaren und kontrollierten Betrieb. Änderungen werden nicht nur technisch ausgeführt, sondern vorab geprüft, dokumentiert und über Git nachvollziehbar gemacht.

Wichtige Prinzipien:

- Änderungen müssen überprüfbar sein.
- Recovery muss nachweisbar sein.
- Rechte müssen begründet und minimal gehalten werden.
- Logs und Exit-Codes dienen als Betriebsnachweis.
- Rohdaten und öffentliche Bewertung bleiben getrennt.

## Lab-vs-Production

Im Lab werden Quality Gates lokal und manuell ausgeführt. In produktionsnahen Umgebungen sollten vergleichbare Prüfungen automatisiert werden, beispielsweise über CI/CD-Pipelines, Pre-Commit-Hooks, Staging-Systeme oder zentrale Deployment-Prozesse.

## Merksätze

- Ein Quality Gate verhindert, dass bekannte Fehler überhaupt erst in den Betrieb wandern.
- Ein grüner Service-Start ersetzt keine statische Prüfung.
- Syntax, Rechte, Pfade, Unit-Dateien und Logs sind getrennte Prüfschichten.
- Produktionsreifer Betrieb beginnt dort, wo Fehler vorab erwartet und kontrolliert abgefangen werden.
