# Lab18g – Betriebsnahe Agent-Incident-Kette

## Zweck

Dieses Dokument beschreibt betriebsnahe Störungsszenarien für den Lab18-Monitoring-Agenten.
Ziel ist nicht nur der Nachweis eines funktionierenden Agenten, sondern die kontrollierte Beherrschung typischer Fehlerbilder im Betrieb.

## Leitfrage

Was kann realistisch passieren, woran wird es erkannt, wie wird es behoben und wie wird die Recovery nachgewiesen?

## Baseline

- Der Monitoring-Agent läuft als systemd-User-Service.
- Der Service ist als Type=oneshot ausgeführt.
- Ein erfolgreicher Lauf endet mit Status OK und Exit-Code 0.
- Der Timer kann den Service regelmäßig auslösen, wurde für die Tests aber kontrolliert gestoppt.

## Incident A – Timer läuft nicht

**Fehlerbild:** Der Agent erzeugt keine neuen automatischen Logs.

**Typische Ursachen:**
- Timer nicht gestartet.
- Timer nicht enabled.
- Falscher User-Kontext.
- User-Session oder User-Service-Kontext nicht aktiv.

**Nachweis im Lab:**
- Timer-Status: inactive (dead).
- Trigger: n/a.
- journalctl zeigte seit Beobachtungsbeginn keine neuen Agent-Einträge.

**Recovery:**
- Timer mit systemctl --user start lab18-monitoring-agent.timer gestartet.
- Agent-Lauf wurde anschließend im Journal sichtbar.
- Agent meldete Status OK und Exit-Code 0.
- Timer wurde nach dem Lab-Test wieder kontrolliert gestoppt.

## Incident B – Skript nicht ausführbar

**Fehlerbild:** Der Service kann das Agent-Skript nicht starten.

**Typische Ursachen:**
- Execute-Bit fehlt nach Kopie, Checkout oder Deployment.
- Dateirechte wurden manuell oder automatisiert falsch gesetzt.

**Nachweis im Lab:**
- Dateirechte wechselten von ausführbar zu nicht ausführbar.
- systemd meldete status=203/EXEC.
- Journal meldete Permission denied beim EXEC-Schritt.

**Recovery:**
- Execute-Bit mit chmod +x wiederhergestellt.
- failed-Zustand mit systemctl --user reset-failed zurückgesetzt, soweit vorhanden.
- Service erneut gestartet.
- Agent meldete wieder Status OK und Exit-Code 0.

## Incident C – Aktive Unit zeigt auf falschen Pfad

**Fehlerbild:** Der Service existiert, aber ExecStart zeigt auf ein nicht vorhandenes Skript.

**Typische Ursachen:**
- Repository wurde verschoben.
- Skript wurde umbenannt.
- Aktive User-Unit unterscheidet sich vom Repository-Sollzustand.
- Nach einer Änderung wurde kein daemon-reload durchgeführt.

**Nachweis im Lab:**
- Aktive User-Unit zeigte auf lab18-agent-does-not-exist.sh.
- systemd meldete status=203/EXEC.
- Journal meldete No such file or directory beim EXEC-Schritt.

**Recovery:**
- Aktive User-Unit aus der Repository-Datei wiederhergestellt.
- systemctl --user daemon-reload ausgeführt.
- failed-Zustand zurückgesetzt, soweit vorhanden.
- Service erneut gestartet.
- Agent meldete wieder Status OK und Exit-Code 0.

## Incident D – Bash-Syntaxfehler im Agent-Skript

**Fehlerbild:** Das Skript enthält einen Syntaxfehler.

**Wichtiger Lerneffekt:**
- Ein Syntaxfehler hinter einem vorherigen exit kann durch bash -n erkannt werden, obwohl der Service-Lauf scheinbar erfolgreich bleibt.
- Ein grüner Service-Start ersetzt keine statische Syntaxprüfung.

**Nachweis im Lab:**
- bash -n meldete unexpected end of file und Exit-Code 2.
- Der Service konnte trotzdem Status OK liefern, weil der Fehler hinter einem vorherigen exit lag.

**Recovery:**
- Skript mit git restore auf den letzten Commit zurückgesetzt.
- bash -n meldete anschließend Exit-Code 0.
- Service-Start meldete anschließend Exit-Code 0.
- Agent meldete wieder Status OK und Exit-Code 0.

## Fehlerklassen und Diagnoseanker

| Fehlerklasse | Typisches Symptom | Erste Prüfung | Recovery |
|---|---|---|---|
| Timer-Problem | keine neuen Logs | systemctl --user status *.timer | Timer starten oder enable prüfen |
| Rechteproblem | Permission denied, 203/EXEC | ls -l Skript | chmod +x oder Rechte korrigieren |
| Pfadproblem | No such file or directory, 203/EXEC | systemctl --user cat Service | Unit korrigieren, daemon-reload |
| Syntaxproblem | bash -n Exit-Code 2 | bash -n Skript | Git-Restore oder Codekorrektur |
| Fachlicher Alarm | WARNING oder CRITICAL | Agent-Output lesen | Ursache im überwachten System prüfen |

## BSI-orientierte Einordnung

- Störungen werden nachvollziehbar erkannt, bewertet und behoben.
- Änderungen werden über Git prüfbar gemacht.
- Recovery wird nicht behauptet, sondern über Logs, Exit-Codes und Statusausgaben nachgewiesen.
- Private Rohdaten und öffentliche Bewertung bleiben getrennt.

## Merksätze

- Ein grüner Service-Start ersetzt keine statische Prüfung.
- 203/EXEC bedeutet: systemd kam nicht sauber in das Programm hinein.
- Erst klären, ob der Melder defekt ist oder ob er korrekt ein echtes Problem meldet.
- Betriebsnahe Simulation heißt: typische Fehlerzustände kontrolliert nachstellen und Recovery beweisen.

