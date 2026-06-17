# Linux Command Pattern Library

## Zweck

Diese Datei sammelt wiederkehrende Linux-Administrationsmuster.

Ziel ist nicht, einzelne Befehle blind auswendig zu lernen. Ziel ist, typische Situationen zu erkennen und passende Prüfkommandos sicher auszuwählen.

Grundmuster:

```text
Symptom oder Aufgabe
→ betroffener Bereich
→ passendes Prüfkommando
→ Ergebnis bewerten
→ Maßnahme ableiten
→ Verifikation
→ Dokumentation
```

---

## 1. Aktuellen Kontext prüfen

### Situation

Vor einer Änderung soll geprüft werden, auf welchem System und mit welchem Benutzer gearbeitet wird.

### Befehle

```bash
hostnamectl
whoami
id
pwd
```

### Bedeutung

| Befehl        | Zweck                                                  |
| ------------- | ------------------------------------------------------ |
| `hostnamectl` | zeigt Hostname, Betriebssystem und Systeminformationen |
| `whoami`      | zeigt den aktuellen Benutzer                           |
| `id`          | zeigt Benutzer-ID und Gruppenmitgliedschaften          |
| `pwd`         | zeigt das aktuelle Arbeitsverzeichnis                  |

### Bewertung

Wichtig ist:

* richtiger Hostname
* richtiger Benutzer
* bei Admin-Aufgaben passende `sudo`-Rechte
* richtiger Projekt- oder Arbeitsordner

---

## 2. Netzwerk-Baseline prüfen

### Situation

Ein Server soll erreichbar sein oder ein Dienst funktioniert über das Netzwerk nicht.

### Befehle

```bash
ip -brief a
ip route
ping <ziel-ip-oder-name>
```

### Bedeutung

| Befehl        | Zweck                                            |
| ------------- | ------------------------------------------------ |
| `ip -brief a` | zeigt Netzwerkinterfaces und IP-Adressen kompakt |
| `ip route`    | zeigt Routing-Tabelle und Default Gateway        |
| `ping`        | prüft grundlegende Erreichbarkeit                |

### Bewertung

Wichtig ist:

* Interface ist `UP`
* IP-Adresse ist vorhanden
* Default Route existiert
* Zielsystem antwortet auf Ping, falls ICMP erlaubt ist

Hinweis:

ICMP bedeutet **Internet Control Message Protocol**. `ping` nutzt ICMP. Wenn `ping` nicht funktioniert, heißt das nicht automatisch, dass der Server komplett unerreichbar ist, weil ICMP durch Firewalls blockiert sein kann.

---

## 3. Paket prüfen

### Situation

Ein Dienst fehlt oder ein Befehl ist nicht verfügbar.

### Befehle

```bash
dpkg -l | grep <paketname>
apt list --installed | grep <paketname>
```

### Beispiel

```bash
dpkg -l | grep openssh-server
```

### Bedeutung

| Teil      | Zweck                                      |
| --------- | ------------------------------------------ |
| `dpkg -l` | listet installierte Debian/Ubuntu-Pakete   |
| `grep`    | filtert die Ausgabe nach einem Suchbegriff |

### Bewertung

* Ausgabe vorhanden: Paket ist installiert.
* keine Ausgabe: Paket ist wahrscheinlich nicht installiert.

---

## 4. Paket installieren

### Situation

Ein benötigtes Paket fehlt.

### Befehle

```bash
sudo apt update
sudo apt install -y <paketname>
```

### Beispiel

```bash
sudo apt install -y openssh-server
```

### Bedeutung

| Teil          | Zweck                                            |
| ------------- | ------------------------------------------------ |
| `sudo`        | führt den Befehl mit administrativen Rechten aus |
| `apt update`  | aktualisiert Paketlisten                         |
| `apt install` | installiert ein Paket                            |
| `-y`          | bestätigt automatisch mit Ja                     |

### Verifikation

Nach der Installation prüfen:

```bash
dpkg -l | grep <paketname>
```

---

## 5. Dienststatus prüfen

### Situation

Ein Dienst soll laufen oder ein Dienstproblem soll untersucht werden.

### Befehle

```bash
systemctl status <dienst> --no-pager
systemctl is-active <dienst>
systemctl is-enabled <dienst>
```

### Beispiel

```bash
systemctl status ssh --no-pager
systemctl is-active ssh
systemctl is-enabled ssh
```

### Bedeutung

| Befehl             | Zweck                                                    |
| ------------------ | -------------------------------------------------------- |
| `systemctl status` | zeigt ausführlichen Dienststatus                         |
| `is-active`        | prüft, ob der Dienst aktiv läuft                         |
| `is-enabled`       | prüft, ob der Dienst beim Systemstart aktiviert ist      |
| `--no-pager`       | zeigt die Ausgabe direkt im Terminal ohne Scrollprogramm |

### Bewertung

| Ausgabe            | Bedeutung                        |
| ------------------ | -------------------------------- |
| `active (running)` | Dienst läuft                     |
| `inactive`         | Dienst ist nicht aktiv           |
| `failed`           | Dienst ist fehlgeschlagen        |
| `enabled`          | Dienst startet automatisch       |
| `disabled`         | Dienst startet nicht automatisch |

---

## 6. Dienst starten, stoppen und aktivieren

### Situation

Ein Dienst muss gestartet, gestoppt oder für den Systemstart aktiviert werden.

### Befehle

```bash
sudo systemctl start <dienst>
sudo systemctl stop <dienst>
sudo systemctl restart <dienst>
sudo systemctl enable <dienst>
sudo systemctl enable --now <dienst>
```

### Bedeutung

| Befehl         | Zweck                                  |
| -------------- | -------------------------------------- |
| `start`        | startet den Dienst                     |
| `stop`         | stoppt den Dienst                      |
| `restart`      | startet den Dienst neu                 |
| `enable`       | aktiviert Autostart                    |
| `enable --now` | aktiviert Autostart und startet sofort |

### Sicherheitsnotiz

Bei Remote-Diensten wie SSH nie leichtfertig stoppen, wenn man über genau diesen Dienst verbunden ist. Sonst kann man sich aussperren.

---

## 7. Offene Ports prüfen

### Situation

Ein Dienst läuft angeblich, ist aber von außen nicht erreichbar.

### Befehl

```bash
sudo ss -tulpn
```

### Beispiel

```bash
sudo ss -tulpn | grep ':22'
```

### Bedeutung der Optionen

| Option | Bedeutung                              |
| ------ | -------------------------------------- |
| `-t`   | TCP anzeigen                           |
| `-u`   | UDP anzeigen                           |
| `-l`   | nur lauschende Ports anzeigen          |
| `-p`   | Prozess anzeigen                       |
| `-n`   | numerische Adressen und Ports anzeigen |

TCP bedeutet **Transmission Control Protocol**. Viele Dienste wie SSH, HTTP und HTTPS nutzen TCP.
UDP bedeutet **User Datagram Protocol**. Es wird z. B. häufig bei DNS oder bestimmten Streaming-/Monitoring-Szenarien genutzt.

### Bewertung

| Ergebnis                  | Bedeutung                            |
| ------------------------- | ------------------------------------ |
| `LISTEN ... :22 ... sshd` | SSH lauscht auf Port 22              |
| keine Ausgabe             | Dienst lauscht nicht auf diesem Port |
| falscher Prozess          | anderer Dienst nutzt den Port        |

---

## 8. Logs eines Dienstes prüfen

### Situation

Ein Dienst läuft nicht, startet nicht oder zeigt unerwartetes Verhalten.

### Befehle

```bash
journalctl -u <dienst> --no-pager -n 50
journalctl -u <dienst> --since "1 hour ago"
```

### Beispiel

```bash
journalctl -u ssh --no-pager -n 50
```

### Bedeutung

| Teil          | Zweck                       |
| ------------- | --------------------------- |
| `journalctl`  | liest systemd-Logs          |
| `-u <dienst>` | filtert nach Dienst         |
| `-n 50`       | zeigt die letzten 50 Zeilen |
| `--since`     | filtert nach Zeitraum       |
| `--no-pager`  | direkte Ausgabe ohne Pager  |

### Bewertung

Achten auf:

```text
failed
error
denied
refused
invalid user
permission
timeout
```

---

## 9. Ausgabe in Datei speichern

### Situation

Ein Prüfergebnis soll dokumentiert werden.

### Befehle

```bash
befehl > datei.txt
befehl >> datei.txt
```

### Bedeutung

| Zeichen | Zweck                                                     |
| ------- | --------------------------------------------------------- |
| `>`     | schreibt neu in Datei und überschreibt vorhandenen Inhalt |
| `>>`    | hängt Ausgabe an bestehende Datei an                      |

### Beispiel

```bash
systemctl status ssh --no-pager > docs/operations/ssh-status.txt
sudo ss -tulpn | grep ':22' > docs/operations/ssh-listening-port-22.txt
```

### Sicherheitsnotiz

`>` überschreibt Dateien. Bei wichtigen Nachweisen vorher prüfen, ob die Datei schon existiert.

---

## 10. Exit-Code prüfen

### Situation

Nach einem Befehl oder Skript soll geprüft werden, ob es erfolgreich war.

### Befehle

```bash
echo $?
```

### Beispiel

```bash
./scripts/check-ssh-baseline.sh
echo $?
```

### Bedeutung

`$?` enthält den Exit-Code des zuletzt ausgeführten Befehls.

|    Exit-Code | Bedeutung                               |
| -----------: | --------------------------------------- |
|          `0` | erfolgreich                             |
| ungleich `0` | Fehler, Warnung oder spezieller Zustand |

### Wichtig

`$?` muss direkt nach dem relevanten Befehl geprüft oder gespeichert werden, weil jeder weitere Befehl den Wert überschreibt.

Sicheres Muster:

```bash
./scripts/check-ssh-baseline.sh
status=$?
echo "Exit-Code: $status"
```

---

## 11. History nutzen

### Situation

Ein früher eingegebener Befehl soll wiedergefunden werden.

### Befehle

```bash
history
history | grep <suchbegriff>
```

### Beispiel

```bash
history | grep check-ssh
```

### Tastenkürzel

```text
Strg + R
```

Damit kann rückwärts in der Befehlshistory gesucht werden.

### Wichtig

`history` speichert normalerweise Befehle, aber nicht die kompletten Ausgaben dieser Befehle.

Für vollständige Terminalmitschnitte kann `script` genutzt werden.

---

## 12. Terminal-Sitzung mitschneiden

### Situation

Eine Trainingseinheit oder ein Arbeitsablauf soll vollständig nachvollziehbar dokumentiert werden.

### Befehl

```bash
script -a docs/private/transcripts/lab-01-session.log
```

### Beenden

```bash
exit
```

### Bedeutung

| Teil                           | Zweck                               |
| ------------------------------ | ----------------------------------- |
| `script`                       | startet Terminalaufzeichnung        |
| `-a`                           | hängt an bestehende Datei an        |
| `docs/private/transcripts/...` | privater Speicherort für Mitschnitt |

### Sicherheitsnotiz

Terminalmitschnitte können private Daten, Pfade, IP-Adressen oder Secrets enthalten. Deshalb zunächst privat speichern und nicht ungeprüft veröffentlichen.

---

## 13. Dateien und Ordner anzeigen

### Situation

Man möchte prüfen, ob Dateien oder Ordner existieren.

### Befehle

```bash
ls -la
ls -lh <ordner>
find . -maxdepth 4 -type f | sort
```

### Bedeutung

| Befehl   | Zweck                                            |
| -------- | ------------------------------------------------ |
| `ls -la` | zeigt alle Dateien inklusive versteckter Dateien |
| `ls -lh` | zeigt Größen menschenlesbar                      |
| `find`   | sucht Dateien oder Ordner                        |
| `sort`   | sortiert Ausgabe                                 |

### Git-Ordner ausblenden

```bash
find . -maxdepth 4 -path ./.git -prune -o -type f -print | sort
```

---

## 14. Platzhalter in Befehlen

### Situation

Ein Beispielbefehl enthält einen Platzhalter wie `DATEINAME.png`.

### Beispiel

Falsch, wenn der Platzhalter nicht ersetzt wurde:

```bash
mv "docs/private/screenshots/inbox/DATEINAME.png" \
"docs/private/screenshots/lab-01-remote-baseline/ssh-health-check-script-success.png"
```

Richtig mit echtem Dateinamen:

```bash
mv "docs/private/screenshots/inbox/Bildschirmfoto vom 2026-06-17 19-44-57.png" \
"docs/private/screenshots/lab-01-remote-baseline/ssh-health-check-script-success.png"
```

### Merksatz

Platzhalter aus Anleitungen müssen vor dem Ausführen durch echte Werte ersetzt werden.

---

## 15. Standardmuster: Prüfen → Ändern → Verifizieren → Dokumentieren

### Situation

Jede Admin-Aufgabe soll sicher und nachvollziehbar erledigt werden.

### Muster

```text
1. Ausgangszustand prüfen
2. Änderung durchführen
3. Ergebnis verifizieren
4. Nachweis speichern
5. Risiko oder Produktionsunterschied dokumentieren
6. optional automatisieren
```

### Beispiel SSH

```bash
systemctl status ssh --no-pager
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
systemctl status ssh --no-pager
sudo ss -tulpn | grep ':22'
./scripts/check-ssh-baseline.sh
```

---

## 16. Bezug zu späterer Automatisierung

Viele manuelle Muster können später automatisiert werden.

Beispiele:

| Manuelles Muster     | Spätere Automatisierung |
| -------------------- | ----------------------- |
| Dienst prüfen        | Health-Check-Skript     |
| Paket installieren   | Ansible Playbook        |
| Config-Datei ändern  | Ansible Template        |
| Port prüfen          | Monitoring Check        |
| Logs prüfen          | Alert/Log Query         |
| Status dokumentieren | CI/CD-Job oder Report   |

CI/CD bedeutet **Continuous Integration / Continuous Deployment**. Dabei werden Build-, Test- und Deployment-Schritte automatisiert.
