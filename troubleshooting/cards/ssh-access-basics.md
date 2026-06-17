# Incident Card: SSH Access Basics

## Zweck

Diese Incident Card hilft bei grundlegenden SSH-Problemen auf einem Linux-System.

SSH bedeutet **Secure Shell**. Es wird genutzt, um Linux-Systeme über das Netzwerk per Terminal zu administrieren.

Diese Karte ist für schnelle Diagnose gedacht, wenn ein SSH-Zugriff nicht funktioniert oder geprüft werden soll.

---

## 1. Typische Symptome

| Symptom                               | Erste Vermutung                                  |
| ------------------------------------- | ------------------------------------------------ |
| `Unit ssh.service could not be found` | OpenSSH Server ist nicht installiert             |
| SSH-Verbindung timeout                | Netzwerk, Firewall oder Port nicht erreichbar    |
| `Connection refused`                  | Server erreichbar, aber SSH-Dienst lauscht nicht |
| `Permission denied`                   | Benutzer, Passwort oder SSH-Key falsch           |
| Verbindung hängt                      | Netzwerkproblem, DNS-Problem oder Firewall       |
| Port 22 nicht sichtbar                | Dienst läuft nicht oder lauscht nicht            |
| Dienst startet nicht                  | Konfigurationsfehler oder Paketproblem           |

---

## 2. Diagnoseweg

Standardreihenfolge:

```text
1. Bin ich auf dem richtigen System?
2. Hat das System Netzwerk?
3. Ist OpenSSH Server installiert?
4. Läuft der SSH-Dienst?
5. Lauscht Port 22?
6. Blockiert eine Firewall?
7. Was sagen die Logs?
8. Stimmt Benutzer oder SSH-Key?
```

---

## 3. System und Benutzer prüfen

```bash
hostnamectl
whoami
id
```

Wichtig:

* `hostnamectl` zeigt den Hostnamen und Systeminformationen.
* `whoami` zeigt den aktuellen Benutzer.
* `id` zeigt Gruppenmitgliedschaften, zum Beispiel `sudo`.

Wenn der Benutzer keine `sudo`-Rechte hat, können viele Admin-Prüfungen nicht durchgeführt werden.

---

## 4. Netzwerk prüfen

```bash
ip -brief a
ip route
```

Erwartung:

* Eine Netzwerkschnittstelle ist `UP`.
* Eine IP-Adresse ist vorhanden.
* Eine Default Route ist gesetzt.

Beispiel:

```text
default via 192.168.178.1 dev eno1
```

Wenn keine Default Route vorhanden ist, kann der Server eventuell nicht sauber mit anderen Netzen kommunizieren.

---

## 5. OpenSSH Server prüfen

```bash
dpkg -l | grep openssh-server
```

Mögliche Bewertung:

| Ergebnis                     | Bedeutung                              |
| ---------------------------- | -------------------------------------- |
| Ausgabe mit `openssh-server` | Paket ist installiert                  |
| keine Ausgabe                | Paket ist vermutlich nicht installiert |

Installation:

```bash
sudo apt update
sudo apt install -y openssh-server
```

---

## 6. SSH-Dienst prüfen

```bash
systemctl status ssh --no-pager
```

Wichtige Zustände:

| Ausgabe                               | Bedeutung                                |
| ------------------------------------- | ---------------------------------------- |
| `active (running)`                    | Dienst läuft                             |
| `inactive`                            | Dienst ist installiert, aber nicht aktiv |
| `failed`                              | Dienst ist fehlgeschlagen                |
| `Unit ssh.service could not be found` | Dienst/Paket fehlt                       |

Starten und aktivieren:

```bash
sudo systemctl enable --now ssh
```

---

## 7. Port 22 prüfen

```bash
sudo ss -tulpn | grep ':22'
```

Bedeutung der Optionen:

* `-t` zeigt TCP-Verbindungen.
* `-u` zeigt UDP-Verbindungen.
* `-l` zeigt lauschende Ports.
* `-p` zeigt den Prozess.
* `-n` zeigt numerische Ports und IP-Adressen.

Erwartung:

```text
LISTEN ... 0.0.0.0:22 ... sshd
LISTEN ... [::]:22 ... sshd
```

Bewertung:

| Ergebnis                    | Bedeutung                     |
| --------------------------- | ----------------------------- |
| `LISTEN` auf `:22` sichtbar | SSH lauscht                   |
| keine Ausgabe               | SSH lauscht nicht auf Port 22 |
| Prozess ist `sshd`          | korrekter SSH-Serverprozess   |

---

## 8. Firewall prüfen

Auf Ubuntu-Systemen wird häufig `ufw` verwendet.

```bash
sudo ufw status
```

`ufw` bedeutet **Uncomplicated Firewall**. Es ist ein einfaches Werkzeug zur Verwaltung von Firewall-Regeln.

Mögliche Bewertung:

| Ausgabe              | Bedeutung                   |
| -------------------- | --------------------------- |
| `Status: inactive`   | lokale UFW-Firewall ist aus |
| `22/tcp ALLOW`       | SSH ist erlaubt             |
| kein 22/tcp sichtbar | SSH könnte blockiert sein   |

SSH erlauben:

```bash
sudo ufw allow 22/tcp
```

Wichtig:

Vor Firewall-Änderungen bei Remote-Systemen nie eine bestehende funktionierende SSH-Sitzung schließen, bevor eine neue Verbindung erfolgreich getestet wurde.

---

## 9. SSH-Logs prüfen

```bash
journalctl -u ssh --no-pager -n 50
```

Achte auf:

```text
failed
error
denied
refused
invalid user
authentication failure
```

Wenn der Dienst sauber startet, sieht man typischerweise:

```text
Started ssh.service - OpenBSD Secure Shell server.
Server listening on 0.0.0.0 port 22.
Server listening on :: port 22.
```

---

## 10. Client-Test

Von einem anderen System aus:

```bash
ssh user@server-ip
```

Beispiel:

```bash
ssh marc@192.168.178.25
```

Für detaillierte Diagnose:

```bash
ssh -v marc@192.168.178.25
```

`-v` bedeutet **verbose**. Die SSH-Verbindung gibt dann mehr Diagnoseinformationen aus.

---

## 11. Häufige Ursachen und Fixes

| Ursache                   | Diagnose                                     | Fix                                |                                          |
| ------------------------- | -------------------------------------------- | ---------------------------------- | ---------------------------------------- |
| OpenSSH Server fehlt      | `dpkg -l                                     | grep openssh-server`               | `sudo apt install -y openssh-server`     |
| Dienst läuft nicht        | `systemctl status ssh`                       | `sudo systemctl start ssh`         |                                          |
| Dienst nicht im Autostart | `systemctl status ssh` zeigt nicht `enabled` | `sudo systemctl enable ssh`        |                                          |
| Port 22 lauscht nicht     | `ss -tulpn                                   | grep ':22'` leer                   | Dienst starten oder Konfiguration prüfen |
| Firewall blockiert        | `sudo ufw status`                            | `sudo ufw allow 22/tcp`            |                                          |
| falscher Benutzer         | `Permission denied`                          | Benutzername prüfen                |                                          |
| falscher SSH-Key          | `ssh -v user@host`                           | Key prüfen, Public Key hinterlegen |                                          |
| DNS-Problem               | Zugriff per Name geht nicht, per IP schon    | DNS oder `/etc/hosts` prüfen       |                                          |

---

## 12. Verifikation nach Fix

Nach jeder Änderung erneut prüfen:

```bash
systemctl status ssh --no-pager
sudo ss -tulpn | grep ':22'
journalctl -u ssh --no-pager -n 20
```

Erwartung:

```text
Active: active (running)
LISTEN ... :22 ... sshd
keine offensichtlichen Fehler in den Logs
```

---

## 13. Dokumentationsoutput

Nach erfolgreicher Prüfung speichern:

```bash
systemctl status ssh --no-pager > docs/operations/ssh-status.txt
sudo ss -tulpn | grep ':22' > docs/operations/ssh-listening-port-22.txt
```

Optional Statusmeldung:

```text
SSH wurde geprüft. Der Dienst läuft aktiv, ist für den Systemstart aktiviert und lauscht auf Port 22. Nachweise wurden im Projektordner abgelegt.
```

---

## 14. Lab vs. Produktion

### Im Lab

* lokale IP-Adresse
* lokaler Benutzer
* SSH auf Standardport 22
* einfache Nachweise im Projektordner
* keine zentrale Benutzerverwaltung

### In Produktion zusätzlich wichtig

* SSH-Key-Management
* zentrale Benutzerverwaltung, zum Beispiel Active Directory oder LDAP
* Firewall- und Netzsegment-Regeln
* Logging und Monitoring
* Zugriff nur nach Rollenmodell
* Passwortlogin einschränken oder deaktivieren
* Notfallzugang dokumentieren
* Änderung über Ticket/Change-Prozess
