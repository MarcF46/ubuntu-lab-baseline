# Runbook: SSH Remote Access Baseline

## Status

Lab: `Lab 01 – Remote Linux Server Baseline for Hybrid Infrastructure`
Teilauftrag: `Arbeitsauftrag 01.2 / 01.3`
System: `ubuntu-lab`
Benutzer: `marc`
Projektpfad: `~/projects/ubuntu-lab-baseline`

---

## 1. Arbeitsauftrag

Ein neuer Ubuntu-Linux-Lab-Server soll für spätere Remote-Administration vorbereitet werden.

Der Server soll per SSH erreichbar sein. Zusätzlich soll geprüft und dokumentiert werden, ob der SSH-Dienst aktiv ist und ob Port 22 auf dem System lauscht.

SSH bedeutet **Secure Shell**. Es ist ein Standardverfahren, um Linux-Systeme sicher über das Netzwerk per Terminal zu administrieren.

---

## 2. Ziel

Nach Abschluss dieses Runbooks soll nachgewiesen sein:

* OpenSSH Server ist installiert.
* Der SSH-Dienst läuft.
* Der SSH-Dienst ist für den Systemstart aktiviert.
* Port 22 lauscht.
* Textnachweise wurden gespeichert.
* Ein Screenshotnachweis wurde abgelegt.
* Private Nachweise sind vor versehentlichem Git-Upload geschützt.

---

## 3. Voraussetzungen

Dieses Runbook setzt voraus:

* Zugriff auf das lokale Ubuntu-System
* Benutzer mit `sudo`-Rechten
* aktive Netzwerkverbindung
* Projektordner vorhanden: `~/projects/ubuntu-lab-baseline`
* Git-Repository im Projektordner vorhanden
* private Nachweise über `.gitignore` geschützt

Prüfung des Benutzerkontexts:

```bash
whoami
id
```

Erwartung:

* `whoami` zeigt den aktuellen Benutzer.
* `id` zeigt unter anderem die Gruppe `sudo`.

---

## 4. Ausgangszustand

Beim ersten Statuscheck war der SSH-Dienst noch nicht vorhanden.

Prüfbefehl:

```bash
systemctl status ssh --no-pager
```

Beobachtung:

```text
Unit ssh.service could not be found.
```

Einordnung:

Der SSH-Dienst war noch nicht installiert oder dem System nicht als systemd-Service bekannt.

`systemd` ist der Dienstmanager vieler moderner Linux-Systeme. Er startet, stoppt und überwacht Dienste wie SSH, Webserver oder Datenbankdienste.

---

## 5. Durchführung

### 5.1 Paketlisten aktualisieren

```bash
sudo apt update
```

Bedeutung:

* `sudo` führt den Befehl mit administrativen Rechten aus.
* `apt` ist der Paketmanager auf Ubuntu/Debian-Systemen.
* `update` aktualisiert die lokale Paketliste.

---

### 5.2 OpenSSH Server installieren

```bash
sudo apt install -y openssh-server
```

Bedeutung:

* `openssh-server` installiert den SSH-Serverdienst.
* `-y` bestätigt die Installation automatisch.

Beobachtung im Lab:

Das Paket `openssh-server` wurde installiert. Zusätzlich wurden Abhängigkeiten wie `openssh-sftp-server`, `ncurses-term` und `ssh-import-id` installiert.

---

### 5.3 SSH-Dienst aktivieren und starten

```bash
sudo systemctl enable --now ssh
```

Bedeutung:

* `systemctl` steuert systemd-Dienste.
* `enable` aktiviert den Dienst für zukünftige Systemstarts.
* `--now` startet den Dienst sofort.
* `ssh` ist der Dienstname.

---

## 6. Verifikation

### 6.1 Dienststatus prüfen

```bash
systemctl status ssh --no-pager
```

Erwartete wichtige Zeilen:

```text
Loaded: loaded (...; enabled; ...)
Active: active (running)
```

Bedeutung:

* `loaded` bedeutet: systemd kennt den Dienst.
* `enabled` bedeutet: Dienst startet beim Systemstart automatisch.
* `active (running)` bedeutet: Dienst läuft aktuell.

Im Lab wurde zusätzlich beobachtet:

```text
Server listening on 0.0.0.0 port 22.
Server listening on :: port 22.
```

Bedeutung:

* `0.0.0.0:22` bedeutet: SSH lauscht auf allen IPv4-Adressen.
* `[::]:22` bedeutet: SSH lauscht auf IPv6.
* `port 22` ist der Standardport für SSH.

---

### 6.2 Lauschen auf Port 22 prüfen

```bash
sudo ss -tulpn | grep ':22'
```

Bedeutung der Optionen:

* `ss` zeigt Socket- und Netzwerkverbindungen.
* `-t` zeigt TCP-Verbindungen.
* `-u` zeigt UDP-Verbindungen.
* `-l` zeigt lauschende Ports.
* `-p` zeigt den zugehörigen Prozess.
* `-n` zeigt numerische Ports und Adressen.
* `grep ':22'` filtert die Ausgabe auf Port 22.

Erwartung:

```text
LISTEN ... 0.0.0.0:22 ... users:(("sshd",...))
LISTEN ... [::]:22 ... users:(("sshd",...))
```

Bedeutung:

* `LISTEN` bedeutet: Der Dienst wartet auf eingehende Verbindungen.
* `sshd` ist der SSH-Serverprozess.

---

## 7. Nachweise im Projekt

Die folgenden Nachweise wurden gespeichert:

```text
docs/operations/ssh-status.txt
docs/operations/ssh-listening-port-22.txt
docs/private/screenshots/lab-01-remote-baseline/ssh-service-active-port-22.png
```

Befehle zur Erstellung der Textnachweise:

```bash
systemctl status ssh --no-pager > docs/operations/ssh-status.txt

sudo ss -tulpn | grep ':22' > docs/operations/ssh-listening-port-22.txt
```

Bedeutung:

* `>` schreibt die Ausgabe eines Befehls in eine Datei.
* Dadurch kann der Zustand später nachvollzogen werden.

---

## 8. Private Screenshot-Ablage

Ubuntu speichert Screenshots standardmäßig im Bilderordner.

Im Lab wurde ein symbolischer Link eingerichtet:

```text
~/Bilder/Bildschirmfotos
→ ~/projects/ubuntu-lab-baseline/docs/private/screenshots/inbox
```

Ein symbolischer Link ist eine Art Weiterleitung im Dateisystem.

Dadurch landen neue Screenshots automatisch im privaten Projektordner.

Private Screenshots werden durch `.gitignore` geschützt:

```gitignore
# Private lab notes and screenshots
/docs/private/
```

Wichtig:

Private Screenshots dürfen nicht ungeprüft in ein öffentliches Repository übernommen werden, da sie Benutzernamen, Hostnamen, lokale IP-Adressen, Pfade oder später sensible Informationen enthalten können.

---

## 9. Typische Fehlerfälle

| Fehlerbild                                   | Mögliche Ursache                                                    | Prüfbefehl                                       |                      |
| -------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------ | -------------------- |
| `Unit ssh.service could not be found`        | OpenSSH Server nicht installiert                                    | `dpkg -l                                         | grep openssh-server` |
| SSH läuft nicht                              | Dienst nicht gestartet                                              | `systemctl status ssh`                           |                      |
| Port 22 lauscht nicht                        | Dienst nicht aktiv oder falsche Konfiguration                       | `sudo ss -tulpn                                  | grep ':22'`          |
| Verbindung von anderem System schlägt fehl   | Firewall, falsche IP, Dienst down                                   | `ip -brief a`, `ufw status`, `journalctl -u ssh` |                      |
| Zugriff verweigert                           | falscher Benutzer, Passwort/Key-Problem                             | `ssh -v user@host`                               |                      |
| Screenshot wird nicht im Projekt gespeichert | Screenshot-Tool speichert an anderem Ort oder nur in Zwischenablage | `find "$HOME" -type f -iname "*.png"`            |                      |

---

## 10. Diagnoseweg bei SSH-Problemen

Standard-Diagnosekette:

```text
Symptom erfassen
→ Netzwerk prüfen
→ SSH-Dienst prüfen
→ Port prüfen
→ Firewall prüfen
→ Logs prüfen
→ Benutzer/Key prüfen
→ Verifikation
→ Dokumentation
```

Konkrete Prüfungen:

```bash
ip -brief a
ip route
systemctl status ssh --no-pager
sudo ss -tulpn | grep ':22'
sudo ufw status
journalctl -u ssh --no-pager -n 50
id
ls -la ~/.ssh
```

---

## 11. Rollback- und Sicherheitsnotizen

### Dienst stoppen

Nur im Lab oder bei bewusstem Test:

```bash
sudo systemctl stop ssh
```

### Dienst wieder starten

```bash
sudo systemctl start ssh
```

### Autostart deaktivieren

Nur wenn SSH nicht dauerhaft laufen soll:

```bash
sudo systemctl disable ssh
```

### Wichtige Sicherheitsregel

Bei echter Remote-Administration niemals eine bestehende funktionierende SSH-Sitzung schließen, bevor eine neue getestete Verbindung erfolgreich aufgebaut wurde.

Sonst kann man sich selbst vom Server aussperren.

---

## 12. Lab vs. Produktion

### Im Lab

* SSH läuft auf Standardport 22.
* Lokaler Benutzer `marc` wird verwendet.
* Zugriff erfolgt in einer privaten Lernumgebung.
* Screenshots und Textnachweise werden lokal gespeichert.
* SSH-Härtung ist noch nicht vollständig umgesetzt.

### In Produktion zusätzlich nötig

* Zugriffskonzept mit Rollen und Verantwortlichkeiten
* SSH-Key-Management
* Deaktivierung oder Einschränkung von Passwortlogin
* Firewall-Regeln nach Least-Privilege-Prinzip
* zentrale Benutzerverwaltung, zum Beispiel Active Directory oder LDAP
* Logging und Monitoring
* regelmäßige Prüfung der SSH-Konfiguration
* Notfallzugang und Break-Glass-Konzept
* Change-Prozess vor sicherheitsrelevanten Änderungen

---

## 13. Kurze Statusmeldung

Beispiel für Teamlead oder Ticket:

```text
SSH wurde auf dem Ubuntu-Lab-System installiert und aktiviert. Der Dienststatus wurde mit `systemctl status ssh` geprüft und zeigt `active (running)`. Zusätzlich wurde mit `ss -tulpn` verifiziert, dass `sshd` auf Port 22 lauscht. Textnachweise und ein privater Screenshot wurden im Projektordner abgelegt.
```

---

## 14. Lessons Learned

* Der fehlende SSH-Dienst wurde über `systemctl status ssh` erkannt.
* Die Installation von `openssh-server` erzeugte den systemd-Dienst `ssh.service`.
* `systemctl enable --now ssh` startet und aktiviert den Dienst in einem Schritt.
* `ss -tulpn` ist ein wichtiger Diagnosebefehl, um lauschende Ports und Prozesse zu prüfen.
* Screenshots sollten projektbezogen abgelegt, aber private Nachweise nicht öffentlich committed werden.
* Der Ablauf folgt dem Betriebsprinzip: prüfen → ändern → verifizieren → dokumentieren.

---

## 15. Spätere Automatisierung

Dieses Runbook kann später in folgende Automatisierung überführt werden:

```text
scripts/check-ssh-baseline.sh
ansible/playbooks/ssh-baseline.yml
ansible/roles/ssh_hardening/
```

Ziel der späteren Automatisierung:

* SSH-Status prüfen
* Port 22 prüfen
* Logs auswerten
* Konfiguration validieren
* Ergebnis maschinenlesbar ausgeben
* bei Fehlern klare Diagnosehinweise liefern
