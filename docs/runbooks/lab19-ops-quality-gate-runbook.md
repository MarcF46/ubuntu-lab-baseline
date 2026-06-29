# Lab19 – Runbook: Ops-Quality-Gate

## Zweck

Dieses Runbook beschreibt die Bedienung und Auswertung des Lab19-Ops-Quality-Gates.

Das Quality Gate prüft zentrale Betriebs-, Rechte-, Syntax-, systemd-, Git- und Agent-Zustände vor Commit, Deployment oder produktionsnahem Start.

## Wann ausführen?

Das Quality Gate sollte ausgeführt werden:

- nach Änderungen am Monitoring-Agenten,
- nach Änderungen an systemd-Service- oder Timer-Units,
- vor einem Commit,
- nach einem Commit zur Abschlussprüfung,
- vor einer Übergabe in ein anderes System,
- nach manuellen Änderungen im User-systemd-Kontext.

## Standardbefehl

1. In das Repository wechseln: `cd ~/projects/ubuntu-lab-baseline || exit 1`
2. Quality Gate starten: `scripts/lab19-ops-quality-gate.sh`
3. Exit-Code prüfen: `echo "quality_gate_exit=$?"`

## Exit-Codes

| Exit-Code | Bedeutung | Bewertung |
|---:|---|---|
| 0 | OK | Keine akute Auffälligkeit erkannt |
| 1 | WARNING | Prüfen, aber nicht zwingend akuter Ausfall |
| 2 | CRITICAL | Blockierender Fehler oder kritischer Betriebszustand |

## Prüfbereiche

Das Skript prüft:

- Git-Repository-Kontext,
- Agent-Skript vorhanden,
- Agent-Skript ausführbar,
- Bash-Syntax des Agent-Skripts,
- Bash-Syntax des Quality-Gate-Skripts,
- sudo-Nutzung im Agent-Skript,
- Service-Unit vorhanden,
- Timer-Unit vorhanden,
- erwartete ExecStart-Zeile,
- erwartete Timer-Unit-Zeile,
- installierte User-Units,
- Abweichungen zwischen Repository-Sollzustand und installierten User-Units,
- systemd-analyze verify,
- private Rohdaten unter docs/private,
- staged private Rohdaten,
- Git-Arbeitsstand,
- Agent-Smoke-Test.

## Bewertung: Status OK

Typisches Ergebnis: `Status: OK` und `Exit-Code: 0`.

Bedeutung:

- Agent ist ausführbar.
- Syntax ist sauber.
- Units stimmen.
- private Rohdaten sind nicht getrackt oder staged.
- Git-Arbeitsstand ist sauber.
- Smoke-Test erfolgreich.

## Bewertung: Status WARNING

Typische Ursachen:

- Git-Arbeitsstand enthält offene Änderungen.
- Installierte User-Unit weicht vom Repository-Sollzustand ab.
- systemd-analyze verify meldet eine Auffälligkeit.
- Agent-Smoke-Test meldet eine Auffälligkeit, aber kein harter Strukturfehler liegt vor.

Erstreaktion:

1. Ausgabe vollständig lesen.
2. WARNING-Zeile identifizieren.
3. betroffene Schicht bestimmen.
4. Git-, Unit-, Rechte- oder Agent-Zustand gezielt prüfen.
5. Recovery durchführen.
6. Quality Gate erneut starten.

## Bewertung: Status CRITICAL

Typische Ursachen:

- Agent-Skript fehlt.
- Agent-Skript ist nicht ausführbar.
- Bash-Syntax ist fehlerhaft.
- Service-Unit fehlt.
- Timer-Unit fehlt.
- ExecStart zeigt nicht auf das erwartete Skript.
- Timer triggert nicht den erwarteten Service.
- private Rohdaten sind getrackt oder staged.

Erstreaktion:

1. Keine weiteren Commits durchführen.
2. Keine produktionsnahe Aktivierung durchführen.
3. Ursache anhand der CRITICAL-Zeile bestimmen.
4. Recovery durchführen.
5. Quality Gate erneut ausführen.
6. Erst bei Exit-Code 0 oder bewusst akzeptierter WARNING fortfahren.

## Bekannte Fremdmeldung

Auf dem aktuellen Lab-System kann folgende Meldung erscheinen:

`/usr/lib/systemd/user/spice-vdagent.service:23: Unknown key StandardError in section [Install], ignoring.`

Diese Meldung stammt nicht von der Lab18-/Lab19-Konfiguration. Wenn das Quality Gate gleichzeitig meldet, dass systemd-analyze verify ohne kritischen Rückgabefehler beendet wurde, ist diese Meldung kein Blocker für Lab19.

## BSI-orientierte Einordnung

Das Quality Gate unterstützt:

- nachvollziehbare Änderungen,
- frühe Fehlererkennung,
- Schutz vor versehentlicher Veröffentlichung privater Rohdaten,
- minimale Rechte,
- dokumentierte Recovery,
- wiederholbare Prüfungen,
- prüfbare Betriebsübergaben.

## Lab-vs-Production

Im Lab wird das Skript manuell ausgeführt.

In produktionsnahen Umgebungen könnte es eingebunden werden in:

- Pre-Commit-Hooks,
- CI/CD-Pipelines,
- Staging-Deployments,
- Release-Freigaben,
- Betriebsübergaben,
- regelmäßige Health-Checks.

## Merksätze

- Ein Quality Gate ist eine Bremse für bekannte Fehler, nicht für produktives Arbeiten.
- WARNING bedeutet: prüfen und bewusst entscheiden.
- CRITICAL bedeutet: stoppen, Ursache klären, Recovery nachweisen.
- Ein grüner Service-Start ersetzt keine systematische Vorprüfung.
