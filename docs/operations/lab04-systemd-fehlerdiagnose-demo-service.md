# Lab 04 – systemd-Fehlerdiagnose mit Demo-Service

## Ziel

Im Lab wurde ein ungefährlicher systemd-Demo-Dienst erstellt, kontrolliert in einen Fehlerzustand versetzt und anschließend wiederhergestellt.

Der Schwerpunkt lag auf dieser Diagnosekette:

- Status prüfen
- Logs lesen
- Exit-Code bewerten
- Ursache erkennen
- Fix setzen
- erneut verifizieren

## Typisches Betriebsszenario

Ein Dienst, Wartungsskript, Backupjob oder Importprozess startet nach einer Änderung nicht mehr. Im Betrieb reicht die Aussage Service failed nicht aus. Entscheidend ist eine nachvollziehbare Analyse.

Wichtige Fragen:

- Welcher Dienst ist betroffen?
- Wann trat der Fehler auf?
- Welcher Exit-Code wurde gemeldet?
- Welche Logzeile beschreibt die Ursache?
- Welche Maßnahme wurde gesetzt?
- Ist der Dienst nach dem Fix wieder erfolgreich?

## Technischer Nachweis

Der Demo-Dienst wurde als systemd-Unit angelegt:

- configs/systemd/lab04-demo.service

Das ausgeführte Skript liegt im Repository unter:

- scripts/lab04-demo-service.sh

Der Dienst arbeitet mit einer Steuerdatei:

- /tmp/lab04-demo-service-mode

Mögliche Modi:

- ok: Dienst endet erfolgreich mit Exit-Code 0
- fail: Dienst endet absichtlich fehlerhaft mit Exit-Code 42

## Beobachtete Zustände

Normalzustand:

- Current mode: ok
- Simulated success: service completed normally
- Result=success
- ExecMainStatus=0

Fehlerzustand:

- Current mode: fail
- Simulated failure: mode is fail
- Active: failed (Result: exit-code)
- status=42

Wiederherstellung:

- Current mode: ok
- Simulated success: service completed normally
- Start-Exit-Code nach Fix: 0
- Result=success
- ExecMainStatus=0

## Betriebliche Einordnung

Ein failed-Status ist noch keine vollständige Diagnose, sondern nur das Warnsignal. Die eigentliche Ursache ergibt sich aus der Kombination von systemd-Status, Exit-Code und journalctl-Logs.

Bei einem Type=oneshot-Dienst ist inactive (dead) nach erfolgreicher Ausführung normal. Entscheidend sind Result=success und ExecMainStatus=0.

## Merksätze

- failed ist nicht die Diagnose. failed ist nur das Warnschild. Die Ursache steht meistens im Log.
- systemctl-Exit-Code = Hat systemd den Auftrag erfolgreich ausgeführt?
- Service-Exit-Code = Warum ist der Dienst selbst gescheitert?
- Ein gutes Log erzählt die Geschichte: vorher, Fehler, danach.

## Nächster professioneller Schritt

Als nächster Schritt sollte ein Health-Check-Skript entstehen, das den Demo-Service kontrolliert startet, Statuswerte ausliest und Erfolg oder Fehler maschinenlesbar bewertet.
