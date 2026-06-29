# Lab19c – Incident-Karte: Ops-Quality-Gate meldet WARNING oder CRITICAL

## Zweck

Diese Incident-Karte beschreibt die Erstreaktion, wenn das Lab19-Ops-Quality-Gate den Status WARNING oder CRITICAL meldet.

Das Ziel ist eine schnelle, kontrollierte und dokumentierte Eingrenzung, bevor weitere Commits, Deployments oder produktionsnahe Starts durchgeführt werden.

## Sofortbewertung

| Status | Bedeutung | Sofortreaktion |
|---|---|---|
| OK | Keine akute Auffälligkeit | Fortfahren möglich |
| WARNING | Auffälligkeit vorhanden | Prüfen, bewerten, bewusst entscheiden |
| CRITICAL | Blockierender Fehler | Stoppen, Ursache klären, Recovery nachweisen |

## Erste Diagnosebefehle

1. Repository prüfen: `git status --short --untracked-files=all`
2. Quality Gate starten: `scripts/lab19-ops-quality-gate.sh`
3. Exit-Code anzeigen: `echo "quality_gate_exit=$?"`
4. Agent-Syntax prüfen: `bash -n scripts/lab18-monitoring-agent-safe.sh`
5. Quality-Gate-Syntax prüfen: `bash -n scripts/lab19-ops-quality-gate.sh`
6. Agent-Rechte prüfen: `ls -l scripts/lab18-monitoring-agent-safe.sh`
7. Service-Unit prüfen: `systemctl --user cat lab18-monitoring-agent.service`
8. Timer-Unit prüfen: `systemctl --user cat lab18-monitoring-agent.timer`
9. Agent-Logs prüfen: `journalctl --user -u lab18-monitoring-agent.service -n 100 --no-pager -l`

## Entscheidungsbaum

### 1. Status OK

Wenn das Quality Gate Status OK und Exit-Code 0 meldet, ist keine akute Auffälligkeit erkannt.

Fortfahren ist möglich, sofern der fachliche Kontext ebenfalls passt.

### 2. Status WARNING

WARNING bedeutet: Es liegt eine Auffälligkeit vor, aber nicht zwingend ein blockierender Fehler.

Typische Beispiele:

- Git-Arbeitsstand enthält offene Änderungen.
- installierte User-Unit weicht vom Repository-Sollzustand ab.
- systemd-analyze verify erzeugt eine Fremdmeldung.
- Agent-Smoke-Test meldet eine Auffälligkeit.

Erstreaktion:

1. WARNING-Zeile vollständig lesen.
2. betroffene Schicht bestimmen.
3. Ursache prüfen.
4. entscheiden, ob bewusst fortgefahren oder korrigiert wird.
5. Entscheidung dokumentieren.

### 3. Status CRITICAL

CRITICAL bedeutet: Es liegt ein blockierender Fehler oder ein Sicherheits-/Betriebsrisiko vor.

Typische Beispiele:

- Agent-Skript fehlt.
- Agent-Skript ist nicht ausführbar.
- Bash-Syntax ist fehlerhaft.
- Service-Unit fehlt.
- Timer-Unit fehlt.
- ExecStart zeigt auf falsches Skript.
- private Rohdaten sind getrackt oder staged.

Erstreaktion:

1. Keine weiteren Commits durchführen.
2. Keine produktionsnahe Aktivierung durchführen.
3. Ursache anhand der CRITICAL-Zeile bestimmen.
4. betroffene Datei oder Unit prüfen.
5. Recovery durchführen.
6. Quality Gate erneut ausführen.
7. Recovery über Status OK oder bewusst bewertete WARNING nachweisen.

## Fehlerklasse: Git-Arbeitsstand offen

Symptom: Das Quality Gate meldet offene Änderungen oder untracked Dateien.

Prüfung: `git status --short --untracked-files=all`

Recovery:

- Änderungen prüfen.
- fachlich passende Dateien committen.
- unerwünschte Änderungen zurücksetzen.
- Quality Gate erneut ausführen.

## Fehlerklasse: private Rohdaten getrackt oder staged

Symptom: Das Quality Gate meldet private Rohdaten unter docs/private.

Bewertung: Das ist ein CRITICAL-Befund.

Recovery:

- Keine weiteren Commits durchführen.
- Staging prüfen.
- private Dateien aus dem Staging entfernen.
- Ignore-Regel prüfen.
- Quality Gate erneut ausführen.

## Fehlerklasse: Unit-Drift

Symptom: Installierte User-Unit weicht vom Repository-Sollzustand ab.

Mögliche Ursachen:

- manuelle Änderung unter ~/.config/systemd/user,
- Repository-Datei geändert, aber nicht installiert,
- alter Testzustand nicht zurückgebaut.

Recovery:

- Abweichung prüfen.
- Repository-Sollzustand bewusst installieren oder Repository-Datei bewusst anpassen.
- systemctl --user daemon-reload ausführen.
- Quality Gate erneut ausführen.

## Fehlerklasse: Skript- oder Syntaxfehler

Symptome:

- bash -n schlägt fehl.
- Agent-Smoke-Test schlägt fehl.
- Service meldet Fehler im Journal.

Recovery:

- Syntaxfehler korrigieren oder per git restore zurücksetzen.
- Rechte mit ls -l prüfen.
- bash -n erneut ausführen.
- Agent direkt oder über systemd erneut testen.
- Quality Gate erneut ausführen.

## Stop-Regel

Bei CRITICAL wird nicht weitergebaut, nicht committed und nicht deployed, bevor die Ursache verstanden und Recovery nachgewiesen wurde.

Bei WARNING wird bewusst entschieden und dokumentiert, ob die Warnung akzeptiert oder behoben wird.

## Merksätze

- WARNING heißt: prüfen, bewerten, bewusst entscheiden.
- CRITICAL heißt: stoppen, Ursache klären, Recovery nachweisen.
- Das Quality Gate ist kein Gegner des Betriebs, sondern ein Schutz vor bekannten Fehlern.
- Erst prüfen, dann ändern.
