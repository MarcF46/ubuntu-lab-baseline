# Runbook: systemd und journalctl am Beispiel ssh.service prüfen

## Zweck

Dieses Runbook beschreibt eine wiederholbare Prüfung eines systemd-Dienstes am Beispiel von `ssh.service`.

Im Fokus stehen:

- Dienststatus mit `systemctl`
- Autostart-Verhalten mit `is-enabled`
- Logauswertung mit `journalctl`
- Zeitprüfung mit `timedatectl`
- betriebliche Bewertung von Dienstzustand und Logs

## Ausgangslage

Im Lab wird `ssh.service` als Beispiel für einen produktionsnah relevanten Linux-Dienst verwendet.

Der Dienst wurde bereits installiert, aktiviert und im Rahmen von Lab 01 sowie Lab 03 geprüft.

Zugehörige Nachweise:

- `docs/operations/systemd-ssh-service-baseline-summary.md`
- `docs/operations/systemd-ssh-health-check-summary.md`
- `scripts/check-systemd-ssh.sh`

Private Rohlogs liegen unter:

- `docs/private/evidence/lab-03-systemd-logs/`

## Schritt 1: systemd-Version prüfen

Befehl:

    systemctl --version | head -n 2

Bedeutung:

Dieser Befehl zeigt die installierte systemd-Version und wichtige aktivierte Funktionen.

Betriebliche Einordnung:

Die systemd-Version ist relevant, weil Features, Verhalten und Ausgabeformate je nach Distribution und Version leicht unterschiedlich sein können.

## Schritt 2: Dienststatus prüfen

Befehl:

    systemctl status ssh --no-pager -l

Bedeutung:

`systemctl status` zeigt den aktuellen Zustand des Dienstes.

Wichtige Felder:

- `Loaded`
- `Active`
- `Main PID`
- `CGroup`
- letzte Logzeilen

Bewertung:

Ein gesunder SSH-Dienst sollte im Lab mindestens folgenden Zustand zeigen:

    Loaded: loaded
    Active: active (running)

## Schritt 3: Laufenden Zustand kurz prüfen

Befehl:

    systemctl is-active ssh

Erwartung:

    active

Bedeutung:

Dieser Befehl eignet sich gut für Skripte, weil er einen klaren Kurzstatus liefert.

## Schritt 4: Autostart prüfen

Befehl:

    systemctl is-enabled ssh

Erwartung:

    enabled

Bedeutung:

`enabled` bedeutet, dass der Dienst beim Systemstart automatisch gestartet werden soll.

Betriebliche Einordnung:

Ein Dienst kann aktuell laufen, aber nicht für den nächsten Boot aktiviert sein. Deshalb sind `active` und `enabled` zwei unterschiedliche Prüfungen.

Merksatz:

    active = läuft jetzt.
    enabled = startet beim Boot.

## Schritt 5: Logs mit journalctl prüfen

Befehl:

    journalctl -u ssh --no-pager -n 30 -o short-iso

Bedeutung:

`journalctl` zeigt Logs aus dem systemd-Journal.

Wichtige Optionen:

- `-u ssh` filtert auf die Unit `ssh`
- `--no-pager` verhindert interaktives Blättern
- `-n 30` zeigt die letzten 30 Einträge
- `-o short-iso` zeigt Zeitstempel in gut lesbarem ISO-ähnlichem Format

Betriebliche Einordnung:

Logs zeigen nicht nur, ob ein Dienst läuft, sondern was mit dem Dienst passiert ist. Dazu gehören Starts, Stopps, Fehler und erfolgreiche Anmeldungen.

Merksatz:

    systemctl zeigt den Zustand.
    journalctl zeigt die Geschichte.

## Schritt 6: Systemzeit prüfen

Befehl:

    timedatectl

Wichtige Felder:

- `Local time`
- `Universal time`
- `Time zone`
- `System clock synchronized`
- `NTP service`

Bewertung:

Für zuverlässige Logauswertung sollte gelten:

    System clock synchronized: yes
    NTP service: active

Betriebliche Einordnung:

Wenn Zeitstempel nicht stimmen, können Incident-Analyse, Log-Korrelation und Audit-Nachweise unzuverlässig werden.

Merksatz:

    Logs sind nur so zuverlässig wie die Systemzeit.

## Schritt 7: Wiederholbaren Health-Check ausführen

Befehl:

    ./scripts/check-systemd-ssh.sh

Erwartung:

    [RESULT] systemd / SSH Service Check erfolgreich.

Zusätzlich prüfen:

    echo $?

Erwartung:

    0

Bedeutung:

Exit-Code `0` bedeutet, dass der Health-Check erfolgreich abgeschlossen wurde.

## Typische Beobachtungen

### Dienst läuft

    Active: active (running)

Bewertung:

Der Dienst ist aktuell aktiv.

### Dienst ist aktiviert

    enabled

Bewertung:

Der Dienst ist für den automatischen Start beim Boot aktiviert.

### Dienst wurde gestoppt

Typische Logs:

    Stopping ssh.service
    Stopped ssh.service

Bewertung:

Das kann normal sein, zum Beispiel bei Wartung, Neustart oder Shutdown.

### Dienst wurde gestartet

Typische Logs:

    Starting ssh.service
    Started ssh.service

Bewertung:

Das zeigt einen erfolgreichen Dienststart.

## Risiko

Problematische Zustände wären unter anderem:

- Dienst ist `inactive`
- Dienst ist `failed`
- Dienst ist nicht `enabled`, obwohl Autostart erwartet wird
- Logs zeigen wiederholte Fehler
- Systemzeit ist nicht synchronisiert
- Logs enthalten unerklärliche Zeitabweichungen

## Lab-vs-Production-Einordnung

Im Lab reicht eine lokale Prüfung mit `systemctl`, `journalctl`, `timedatectl` und einem kleinen Health-Check-Skript aus.

In Production wären zusätzlich wichtig:

- zentrales Monitoring
- Alerting bei Service-Ausfällen
- zentrale Logsammlung
- NTP-Überwachung
- Zugriffskontrolle auf Logs
- dokumentierte Wartungsfenster
- klare Eskalationswege bei `failed` Units

## Verifikation

Der Lab-03-Abschnitt gilt für diesen Baustein als sauber geprüft, wenn:

- `ssh.service` aktiv ist
- `ssh.service` enabled ist
- Systemzeit synchronisiert ist
- NTP aktiv ist
- SSH-Logs abrufbar sind
- Health-Check-Skript Exit-Code `0` liefert
- Rohlogs privat abgelegt wurden
- öffentliche Bewertung ohne sensible Rohdaten erstellt wurde
