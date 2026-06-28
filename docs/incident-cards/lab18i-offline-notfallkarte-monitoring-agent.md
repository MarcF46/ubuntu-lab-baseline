# Lab18i – Offline-Notfallkarte Monitoring-Agent und systemd-Timer

## Zweck

Diese Notfallkarte dient als kompakte Offline-Hilfe bei Störungen des Lab18-Monitoring-Agenten. Sie ist für Situationen gedacht, in denen keine KI, keine Internetrecherche oder keine externe Hilfe verfügbar ist.

Ziel ist eine schnelle Eingrenzung: Ist der Agent selbst defekt, oder meldet der Agent korrekt ein echtes Problem?

## Sofortregel

Nicht blind reparieren.

Zuerst prüfen:

1. Läuft der Timer?
2. Läuft der Service manuell?
3. Zeigt die Unit auf den richtigen Pfad?
4. Ist das Skript ausführbar?
5. Ist die Bash-Syntax sauber?
6. Gibt es Logs?
7. Meldet der Agent OK, WARNING oder CRITICAL?

## Erste Diagnose

### Timer prüfen

Befehl:

systemctl --user status lab18-monitoring-agent.timer --no-pager -l

Bewertung:

- active (waiting) bedeutet: Timer ist aktiv und wartet auf den nächsten Lauf.
- inactive (dead) bedeutet: Timer läuft nicht.
- Trigger: n/a bedeutet: Kein nächster Lauf geplant.

Recovery:

systemctl --user start lab18-monitoring-agent.timer

Nachweis:

systemctl --user list-timers --all | grep lab18-monitoring-agent

## Service prüfen

Befehl:

systemctl --user status lab18-monitoring-agent.service --no-pager -l

Bewertung:

- inactive (dead) ist bei Type=oneshot nach erfolgreichem Lauf normal.
- failed bedeutet: Service-Lauf oder Start fehlgeschlagen.
- status=203/EXEC bedeutet: systemd konnte das Programm aus ExecStart nicht sauber starten.

Recovery je nach Ursache:

- Dateirechte korrigieren.
- Pfad korrigieren.
- Unit zurückkopieren.
- daemon-reload ausführen.
- failed-Zustand zurücksetzen.

## Logs prüfen

Befehl:

journalctl --user -u lab18-monitoring-agent.service -n 100 --no-pager -l

Wichtige Suchmuster:

- Status: OK
- Status: WARNING
- Status: CRITICAL
- Exit-Code: 0
- Permission denied
- No such file or directory
- status=203/EXEC
- syntax error
- unexpected end of file
- Failed with result

## Fehlerklasse: Timer läuft nicht

Symptom:

- Keine neuen Logs.
- Timer inactive (dead).
- Kein nächster Trigger.

Wahrscheinliche Ursache:

- Timer nicht gestartet.
- Falscher User-Kontext.
- User-Service-Kontext nicht aktiv.

Recovery:

1. Timer starten.
2. nächsten Trigger prüfen.
3. Agent-Lauf im Journal nachweisen.
4. Timer nach Lab-Test kontrolliert stoppen.

## Fehlerklasse: Skript nicht ausführbar

Symptom:

- Permission denied
- status=203/EXEC
- Failed at step EXEC

Prüfung:

ls -l scripts/lab18-monitoring-agent-safe.sh

Bewertung:

- x vorhanden: Skript ist ausführbar.
- kein x: Skript ist nicht ausführbar.

Recovery:

chmod +x scripts/lab18-monitoring-agent-safe.sh

Danach:

1. failed-Zustand zurücksetzen, falls vorhanden.
2. Service erneut starten.
3. Journal prüfen.
4. Git-Status prüfen.

## Fehlerklasse: falscher Pfad in aktiver Unit

Symptom:

- No such file or directory
- status=203/EXEC

Prüfung:

systemctl --user cat lab18-monitoring-agent.service

Wichtige Zeile:

ExecStart=...

Recovery:

1. Repository-Unit zurückkopieren.
2. systemctl --user daemon-reload
3. failed-Zustand zurücksetzen, falls vorhanden.
4. Service erneut starten.
5. Journal prüfen.

## Fehlerklasse: Bash-Syntaxfehler

Symptom:

- bash -n meldet Fehler.
- möglich: Service läuft scheinbar trotzdem, wenn der Fehler hinter einem vorherigen exit liegt.

Prüfung:

bash -n scripts/lab18-monitoring-agent-safe.sh

Bewertung:

- Exit-Code 0: Syntax sauber.
- Exit-Code ungleich 0: Syntaxfehler vorhanden.

Recovery:

1. Fehler korrigieren oder git restore verwenden.
2. bash -n erneut ausführen.
3. Service starten.
4. Journal prüfen.
5. Git-Status prüfen.

## Fehlerklasse: Agent meldet WARNING oder CRITICAL

Wichtig:

Ein WARNING oder CRITICAL bedeutet nicht automatisch, dass der Agent defekt ist.

Mögliche Bedeutung:

- Der Agent läuft korrekt.
- Der überwachte Zustand ist auffällig.

Prüfung:

1. Agent-Ausgabe lesen.
2. betroffene Schicht bestimmen.
3. passenden Dienst, Port, DNS oder Dateisystem prüfen.
4. Recovery dokumentieren.

## Diagnoseanker

| Symptom | Wahrscheinliche Richtung |
|---|---|
| keine neuen Logs | Timer oder User-Kontext |
| 203/EXEC | Startproblem vor Skriptlauf |
| Permission denied | Rechte, Execute-Bit oder noexec |
| No such file or directory | falscher Pfad |
| syntax error | Bash-Codeproblem |
| Status: WARNING | fachliche Auffälligkeit |
| Status: CRITICAL | dringende fachliche Auffälligkeit |
| Service inactive (dead) nach Lauf | bei oneshot normal |

## Stop-Regel

Nicht weiter reparieren, wenn:

- mehrere Fehler gleichzeitig auftreten,
- die Ursache nicht eindeutig ist,
- produktionsähnliche Daten betroffen wären,
- Rechteausweitung nötig wäre,
- Änderungen nicht dokumentiert werden können.

Dann gilt: Zustand sichern, Logs erfassen, Bewertung dokumentieren, Eskalation vorbereiten.

## Merksätze

- Erst klären, ob der Melder defekt ist oder ob er korrekt ein echtes Problem meldet.
- 203/EXEC heißt: systemd kam nicht sauber in das Programm hinein.
- inactive (dead) ist bei oneshot nach erfolgreichem Lauf kein Fehler.
- Ohne Logs keine belastbare Betriebsbewertung.
- Offline-fähig ist ein Betrieb erst, wenn die wichtigsten Diagnosepfade dokumentiert sind.
