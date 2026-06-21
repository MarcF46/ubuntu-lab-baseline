# Runbook: SSH-Key-Authentifizierung gegen localhost

## Zweck

Dieses Runbook dokumentiert den Aufbau und Test einer SSH-Key-Authentifizierung auf dem Ubuntu-Lab-System.

SSH bedeutet **Secure Shell**. Damit kann ein Linux-System über das Netzwerk per Terminal administriert werden.

In diesem Lab wurde bereits geprüft:

* der SSH-Dienst läuft,
* Port 22 lauscht,
* Passwortlogin gegen `127.0.0.1` funktioniert,
* SSH-Logs bestätigen erfolgreiche Anmeldung.

Dieses Runbook ergänzt nun den nächsten Schritt: Login per SSH-Key.

---

## 1. Job-Szenario

Auftrag:

```text
Passwortlogin funktioniert. Bitte bereite SSH-Key-Login vor, teste den Zugriff und dokumentiere den Unterschied zwischen Passwortlogin und Schlüssel-Authentifizierung.
```

Ziel:

```text
Nicht nur SSH-Dienst prüfen,
sondern echten Login per SSH-Key nachweisen.
```

---

## 2. Wichtige Begriffe

| Begriff           | Bedeutung                                                   |
| ----------------- | ----------------------------------------------------------- |
| Private Key       | geheimer Schlüssel, bleibt nur beim Benutzer                |
| Public Key        | öffentlicher Schlüssel, darf auf Zielsysteme kopiert werden |
| `authorized_keys` | Datei mit erlaubten Public Keys für eingehende Logins       |
| `known_hosts`     | Datei mit bekannten Server-Host-Keys                        |
| Fingerprint       | kurzer Prüfabdruck eines Schlüssels                         |
| Ed25519           | moderner SSH-Schlüsseltyp                                   |

Merksatz:

```text
Private Key = echter Schlüssel in der Tasche.
Public Key = Eintrag im Türsystem.
authorized_keys = Gästeliste an der Tür.
```

---

## 3. Ausgangszustand prüfen

Vor dem Erzeugen des Keys wurde geprüft:

```bash
ls -la ~/.ssh
ls -la ~/.ssh/ubuntu_lab_ed25519*
```

Ergebnis:

* `authorized_keys` war vorhanden,
* `known_hosts` war vorhanden,
* `ubuntu_lab_ed25519` existierte noch nicht.

Damit war klar: Der spezielle Lab-Key wird neu erzeugt und überschreibt keinen bestehenden Key.

---

## 4. SSH-Keypair erzeugen

Befehl:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ubuntu_lab_ed25519 -C "marc@ubuntu-lab lab ssh key $(date +%F)" -N ""
```

Bedeutung:

| Teil                           | Bedeutung                                  |
| ------------------------------ | ------------------------------------------ |
| `ssh-keygen`                   | erzeugt SSH-Schlüssel                      |
| `-t ed25519`                   | nutzt den Schlüsseltyp Ed25519             |
| `-f ~/.ssh/ubuntu_lab_ed25519` | legt den Dateinamen fest                   |
| `-C "..."`                     | fügt einen Kommentar in den Public Key ein |
| `-N ""`                        | setzt für dieses Lab eine leere Passphrase |

Im Lab wurde bewusst eine leere Passphrase genutzt, damit der Ablauf verständlich und automatisierbar bleibt.

In Produktion müsste geprüft werden, ob eine Passphrase, ein SSH-Agent, zentrale Verwaltung oder andere Schutzmechanismen erforderlich sind.

---

## 5. Erzeugte Dateien prüfen

Befehl:

```bash
ls -la ~/.ssh/ubuntu_lab_ed25519*
```

Erwartetes Muster:

```text
-rw------- ... ubuntu_lab_ed25519
-rw-r--r-- ... ubuntu_lab_ed25519.pub
```

Bewertung:

| Datei                    | Bedeutung              | Schutz               |
| ------------------------ | ---------------------- | -------------------- |
| `ubuntu_lab_ed25519`     | privater Schlüssel     | geheim halten        |
| `ubuntu_lab_ed25519.pub` | öffentlicher Schlüssel | darf verteilt werden |

Wichtig:

```text
Der private Schlüssel darf niemals veröffentlicht, gepostet oder committed werden.
```

---

## 6. Public Key erlauben

Der Public Key wurde in `authorized_keys` eingetragen:

```bash
cat ~/.ssh/ubuntu_lab_ed25519.pub >> ~/.ssh/authorized_keys
```

Bedeutung:

```text
Der Server akzeptiert ab jetzt Logins, die zum passenden privaten Schlüssel gehören.
```

Wichtig:

Der Befehl nutzt `>>` und hängt den Public Key an.

| Zeichen | Bedeutung           |
| ------- | ------------------- |
| `>`     | Datei überschreiben |
| `>>`    | an Datei anhängen   |

Für `authorized_keys` ist `>>` sicherer, weil vorhandene erlaubte Keys nicht gelöscht werden.

---

## 7. Dateirechte setzen

Befehle:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/ubuntu_lab_ed25519
chmod 644 ~/.ssh/ubuntu_lab_ed25519.pub
```

Bedeutung:

| Pfad              | Rechte | Bedeutung                                       |
| ----------------- | -----: | ----------------------------------------------- |
| `~/.ssh`          |  `700` | nur Benutzer darf lesen, schreiben und betreten |
| `authorized_keys` |  `600` | nur Benutzer darf lesen und schreiben           |
| privater Key      |  `600` | nur Benutzer darf lesen und schreiben           |
| Public Key        |  `644` | Benutzer darf schreiben, andere dürfen lesen    |

Merksatz:

```text
Der private Schlüssel liegt im Tresor.
Der öffentliche Schlüssel darf am Türschild stehen.
```

---

## 8. SSH-Key-Login testen

Befehl:

```bash
ssh -i ~/.ssh/ubuntu_lab_ed25519 -o IdentitiesOnly=yes -o ConnectTimeout=5 marc@127.0.0.1 "hostname; whoami; echo SSH_KEY_LOGIN_OK"
```

Bedeutung:

| Teil                           | Bedeutung                                       |
| ------------------------------ | ----------------------------------------------- |
| `-i ~/.ssh/ubuntu_lab_ed25519` | nutzt genau diesen privaten Schlüssel           |
| `IdentitiesOnly=yes`           | verhindert, dass andere Keys ausprobiert werden |
| `ConnectTimeout=5`             | bricht nach 5 Sekunden ab                       |
| `marc@127.0.0.1`               | Login als Benutzer `marc` gegen localhost       |
| `SSH_KEY_LOGIN_OK`             | Erfolgsmarker für die Dokumentation             |

Erfolgreiches Ergebnis:

```text
ubuntu-lab
marc
SSH_KEY_LOGIN_OK
```

Exit-Code:

```text
Exit-Code SSH Key Login Test: 0
```

Bewertung:

```text
0 = erfolgreich
nicht 0 = Fehlerzustand
```

---

## 9. Lognachweis prüfen

Befehl:

```bash
journalctl -u ssh --since today --no-pager | grep "Accepted publickey"
```

Erwartetes Muster:

```text
Accepted publickey for marc from 127.0.0.1
```

Bedeutung:

```text
Der SSH-Server bestätigt, dass der Login per Public-Key-Authentifizierung akzeptiert wurde.
```
### Operator Notes: Warum dieser Lognachweis wichtig ist

Der Lognachweis wurde nicht nur als formaler Schritt gespeichert. Er zeigt, dass der SSH-Server die Anmeldung tatsächlich als Public-Key-Authentifizierung akzeptiert hat.

Das ist wichtig, weil ein erfolgreicher SSH-Befehl allein noch nicht eindeutig beweist, welcher Authentifizierungsweg verwendet wurde. Erst die Logzeile `Accepted publickey` bestätigt, dass der Login wirklich über den gewünschten SSH-Key erfolgt ist und nicht über Passwort oder eine andere Methode.

Betrieblich ist dieser Nachweis wertvoll, weil er drei Fragen beantwortet:

```text
1. Hat der Login funktioniert?
2. Welcher Benutzer hat sich angemeldet?
3. Welche Authentifizierungsmethode wurde tatsächlich verwendet?
```

In einem echten Betrieb hilft diese Denkweise bei Audits, Fehlersuche, Sicherheitsprüfungen und späterem Monitoring. Der nächste professionelle Schritt wäre nicht nur, SSH-Key-Login einzurichten, sondern daraus ein Zugriffskonzept abzuleiten:

```text
Wer darf sich anmelden?
Welche Keys sind erlaubt?
# Runbook: SSH-Key-Authentifizierung gegen localhost

## Zweck

Dieses Runbook dokumentiert den Aufbau und Test einer SSH-Key-Authentifizierung auf dem Ubuntu-Lab-System.

SSH bedeutet **Secure Shell**. Damit kann ein Linux-System über das Netzwerk per Terminal administriert werden.

In diesem Lab wurde bereits geprüft:

* der SSH-Dienst läuft,
* Port 22 lauscht,
* Passwortlogin gegen `127.0.0.1` funktioniert,
* SSH-Logs bestätigen erfolgreiche Anmeldung.

Dieses Runbook ergänzt nun den nächsten Schritt: Login per SSH-Key.

---

## 1. Job-Szenario

Auftrag:

```text
Passwortlogin funktioniert. Bitte SSH-Key-Login vorbereiten, den Zugriff testen und den Unterschied zwischen Passwortlogin und Schlüssel-Authentifizierung dokumentieren.
```

Ziel:

```text
Nicht nur SSH-Dienst prüfen,
sondern echten Login per SSH-Key nachweisen.
```

---

## 2. Wichtige Begriffe

| Begriff           | Bedeutung                                                   |
| ----------------- | ----------------------------------------------------------- |
| Private Key       | geheimer Schlüssel, bleibt nur beim Benutzer                |
| Public Key        | öffentlicher Schlüssel, darf auf Zielsysteme kopiert werden |
| `authorized_keys` | Datei mit erlaubten Public Keys für eingehende Logins       |
| `known_hosts`     | Datei mit bekannten Server-Host-Keys                        |
| Fingerprint       | kurzer Prüfabdruck eines Schlüssels                         |
| Ed25519           | moderner SSH-Schlüsseltyp                                   |

Merksatz:

```text
Private Key = echter Schlüssel in der Tasche.
Public Key = Eintrag im Türsystem.
authorized_keys = Gästeliste an der Tür.
```

---

## 3. Ausgangszustand prüfen

Vor dem Erzeugen des Keys wurde geprüft:

```bash
ls -la ~/.ssh
ls -la ~/.ssh/ubuntu_lab_ed25519*
```

Ergebnis:

* `authorized_keys` war vorhanden,
* `known_hosts` war vorhanden,
* `ubuntu_lab_ed25519` existierte noch nicht.

Damit war klar: Der spezielle Lab-Key wird neu erzeugt und überschreibt keinen bestehenden Key.

---

## 4. SSH-Keypair erzeugen

Befehl:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ubuntu_lab_ed25519 -C "marc@ubuntu-lab lab ssh key $(date +%F)" -N ""
```

Bedeutung:

| Teil                           | Bedeutung                                  |
| ------------------------------ | ------------------------------------------ |
| `ssh-keygen`                   | erzeugt SSH-Schlüssel                      |
| `-t ed25519`                   | nutzt den Schlüsseltyp Ed25519             |
| `-f ~/.ssh/ubuntu_lab_ed25519` | legt den Dateinamen fest                   |
| `-C "..."`                     | fügt einen Kommentar in den Public Key ein |
| `-N ""`                        | setzt für dieses Lab eine leere Passphrase |

Im Lab wurde bewusst eine leere Passphrase genutzt, damit der Ablauf verständlich und automatisierbar bleibt.

In Produktion müsste geprüft werden, ob eine Passphrase, ein SSH-Agent, zentrale Verwaltung oder andere Schutzmechanismen erforderlich sind.

---

## 5. Erzeugte Dateien prüfen

Befehl:

```bash
ls -la ~/.ssh/ubuntu_lab_ed25519*
```

Erwartetes Muster:

```text
-rw------- ... ubuntu_lab_ed25519
-rw-r--r-- ... ubuntu_lab_ed25519.pub
```

Bewertung:

| Datei                    | Bedeutung              | Schutz               |
| ------------------------ | ---------------------- | -------------------- |
| `ubuntu_lab_ed25519`     | privater Schlüssel     | geheim halten        |
| `ubuntu_lab_ed25519.pub` | öffentlicher Schlüssel | darf verteilt werden |

Wichtig:

```text
Der private Schlüssel darf niemals veröffentlicht, gepostet oder committed werden.
```

---

## 6. Public Key erlauben

Der Public Key wurde in `authorized_keys` eingetragen:

```bash
cat ~/.ssh/ubuntu_lab_ed25519.pub >> ~/.ssh/authorized_keys
```

Bedeutung:

```text
Der Server akzeptiert ab jetzt Logins, die zum passenden privaten Schlüssel gehören.
```

Wichtig:

Der Befehl nutzt `>>` und hängt den Public Key an.

| Zeichen | Bedeutung           |
| ------- | ------------------- |
| `>`     | Datei überschreiben |
| `>>`    | an Datei anhängen   |

Für `authorized_keys` ist `>>` sicherer, weil vorhandene erlaubte Keys nicht gelöscht werden.

---

## 7. Dateirechte setzen

Befehle:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/ubuntu_lab_ed25519
chmod 644 ~/.ssh/ubuntu_lab_ed25519.pub
```

Bedeutung:

| Pfad              | Rechte | Bedeutung                                       |
| ----------------- | -----: | ----------------------------------------------- |
| `~/.ssh`          |  `700` | nur Benutzer darf lesen, schreiben und betreten |
| `authorized_keys` |  `600` | nur Benutzer darf lesen und schreiben           |
| privater Key      |  `600` | nur Benutzer darf lesen und schreiben           |
| Public Key        |  `644` | Benutzer darf schreiben, andere dürfen lesen    |

Merksatz:

```text
Der private Schlüssel liegt im Tresor.
Der öffentliche Schlüssel darf am Türschild stehen.
```

---

## 8. SSH-Key-Login testen

Befehl:

```bash
ssh -i ~/.ssh/ubuntu_lab_ed25519 -o IdentitiesOnly=yes -o ConnectTimeout=5 marc@127.0.0.1 "hostname; whoami; echo SSH_KEY_LOGIN_OK"
```

Bedeutung:

| Teil                           | Bedeutung                                       |
| ------------------------------ | ----------------------------------------------- |
| `-i ~/.ssh/ubuntu_lab_ed25519` | nutzt genau diesen privaten Schlüssel           |
| `IdentitiesOnly=yes`           | verhindert, dass andere Keys ausprobiert werden |
| `ConnectTimeout=5`             | bricht nach 5 Sekunden ab                       |
| `marc@127.0.0.1`               | Login als Benutzer `marc` gegen localhost       |
| `SSH_KEY_LOGIN_OK`             | Erfolgsmarker für die Dokumentation             |

Erfolgreiches Ergebnis:

```text
ubuntu-lab
marc
SSH_KEY_LOGIN_OK
```

Exit-Code:

```text
Exit-Code SSH Key Login Test: 0
```

Bewertung:

```text
0 = erfolgreich
nicht 0 = Fehlerzustand
```

---

## 9. Lognachweis prüfen

Befehl:

```bash
journalctl -u ssh --since today --no-pager | grep "Accepted publickey"
```

Erwartetes Muster:

```text
Accepted publickey for marc from 127.0.0.1
```

Bedeutung:

```text
Der SSH-Server bestätigt, dass der Login per Public-Key-Authentifizierung akzeptiert wurde.
```

### Fachliche Einordnung des Lognachweises

Der SSH-Key-Login wurde nicht nur durch die erfolgreiche Terminalausgabe geprüft, sondern zusätzlich über den SSH-Log verifiziert.

Diese Vorgehensweise orientiert sich an typischen Linux-Administrations- und Zertifizierungszielen: Ein Dienst wird nicht nur gestartet oder benutzt, sondern sein tatsächlicher Betriebszustand wird über passende Nachweise geprüft. Bei SSH gehört dazu insbesondere die Unterscheidung zwischen Passwortlogin und Public-Key-Authentifizierung.

Der technische Login-Test zeigte:

```text
ubuntu-lab
marc
SSH_KEY_LOGIN_OK
```

Damit ist belegt, dass der Login funktioniert hat. Der zusätzliche Lognachweis zeigte:

```text
Accepted publickey for marc from 127.0.0.1
```

Dieser Eintrag ist fachlich wichtig, weil er bestätigt, dass der SSH-Server die Anmeldung tatsächlich als Public-Key-Login akzeptiert hat. Ohne diesen Lognachweis wäre nur sichtbar, dass ein SSH-Login funktioniert hat, aber nicht eindeutig, welche Authentifizierungsmethode verwendet wurde.

Daraus ergibt sich für dieses Lab ein klares Prüfmuster:

```text
Befehl ausführen
→ Ergebnis sichtbar prüfen
→ Log des Dienstes gegenprüfen
→ Nachweis speichern
→ betriebliche Bedeutung einordnen
```

Für spätere Betriebsumgebungen ist dieser Unterschied wichtig, weil SSH-Zugriffe nicht nur funktionieren, sondern nachvollziehbar, kontrollierbar und auswertbar sein müssen. Daraus ergeben sich weitere Themen wie Key-Verwaltung, Entfernen alter Schlüssel, Login-Monitoring, Alarmierung bei Fehlversuchen und ein dokumentierter Notfallzugang.

Merksatz:

```text
Der Befehl zeigt den Versuch.
Die Ausgabe zeigt das Ergebnis.
Der Log zeigt, was der Dienst wirklich bestätigt.
```

---

## 10. Nachweise im Projekt

Gespeicherte technische Nachweise:

```text
docs/operations/ssh-key-login-test-localhost.txt
docs/operations/ssh-key-login-accepted-log.txt
```

Privater Screenshot-Nachweis:

```text
docs/private/screenshots/lab-01-remote-baseline/ssh-key-login-success.png
docs/private/screenshots/lab-01-remote-baseline/git-commit-ssh-key-login-evidence.png
```

Wichtig:

Private Screenshots liegen unter `docs/private/` und werden durch `.gitignore` geschützt.

---

## 11. Sicherheitsbewertung

### Im Lab

* lokaler Test gegen `127.0.0.1`,
* eigener Lab-Key,
* leere Passphrase für Lern- und Automatisierungszweck,
* private Screenshots und Terminalmitschnitte nicht im Git-Commit.

### In Produktion zusätzlich wichtig

* Private Keys niemals teilen,
* Schlüssel möglichst mit Passphrase schützen,
* SSH-Agent gezielt nutzen,
* alte Keys regelmäßig entfernen,
* Zugriff an Rollen und Verantwortlichkeiten koppeln,
* zentrale Verwaltung prüfen,
* Passwortlogin kontrolliert einschränken,
* Logging und Monitoring aktivieren,
* Notfallzugang dokumentieren.

---

## 12. Rollback im Lab

Wenn der Lab-Key entfernt werden soll:

```bash
rm ~/.ssh/ubuntu_lab_ed25519 ~/.ssh/ubuntu_lab_ed25519.pub
```

Zusätzlich müsste der passende Public-Key-Eintrag aus `~/.ssh/authorized_keys` entfernt werden.

Wichtig:

Nicht einfach blind `authorized_keys` löschen, weil dort auch andere erlaubte Schlüssel stehen könnten.

Sicherer wäre:

```bash
nano ~/.ssh/authorized_keys
```

und dann nur die passende Zeile entfernen.

---

## 13. Typische Fehlerbilder

| Symptom                                  | Mögliche Ursache                      | Diagnose                             |
| ---------------------------------------- | ------------------------------------- | ------------------------------------ |
| `Permission denied (publickey,password)` | Key nicht erlaubt oder falscher Key   | `ssh -v ...`                         |
| Passwortabfrage trotz Key                | Key wird nicht genutzt                | `-i` und `IdentitiesOnly=yes` prüfen |
| `Bad permissions`                        | Dateirechte zu offen                  | `ls -la ~/.ssh`                      |
| kein Logeintrag                          | Verbindung kommt nicht beim Dienst an | `journalctl -u ssh`                  |
| falscher Fingerprint                     | anderer Key als erwartet              | Public Key und Log vergleichen       |

---

## 14. Lessons Learned

* Passwortlogin und Key-Login sind unterschiedliche Authentifizierungswege.
* Ein funktionierender SSH-Dienst beweist noch keinen erfolgreichen Login.
* `authorized_keys` entscheidet, welche Public Keys für den Benutzer akzeptiert werden.
* Der Private Key ist besonders schützenswert.
* Logs liefern den stärksten technischen Nachweis für den tatsächlich verwendeten Login-Typ.
* Screenshots sind gute private Lernnachweise, aber öffentliche Doku sollte bereinigt werden.
* Kleine Befehlsmuster wie `grep "Accepted publickey"` machen Logdiagnose deutlich effizienter.

---

## 15. Statusmeldung

```text
SSH-Key-Authentifizierung wurde im Ubuntu-Lab vorbereitet, getestet und dokumentiert. Ein Ed25519-Keypair wurde erzeugt, der Public Key in authorized_keys eingetragen und der Login gegen 127.0.0.1 erfolgreich verifiziert. Der SSH-Log bestätigt Accepted publickey für den Benutzer marc. Technische Nachweise wurden unter docs/operations/ gespeichert, private Screenshots liegen geschützt unter docs/private/.
```
Wie werden alte Keys entfernt?
Wie werden erfolgreiche und fehlgeschlagene Logins überwacht?
Welcher Notfallzugang existiert, falls der normale Zugriff ausfällt?
```

Merksatz:

```text
Der Befehl zeigt, was getan wurde.
Der Log zeigt, was wirklich passiert ist.
Die Bewertung zeigt, dass du verstanden hast, warum es wichtig ist.
```

---

## 10. Nachweise im Projekt

Gespeicherte technische Nachweise:

```text
docs/operations/ssh-key-login-test-localhost.txt
docs/operations/ssh-key-login-accepted-log.txt
```

Privater Screenshot-Nachweis:

```text
docs/private/screenshots/lab-01-remote-baseline/ssh-key-login-success.png
docs/private/screenshots/lab-01-remote-baseline/git-commit-ssh-key-login-evidence.png
```

Wichtig:

Private Screenshots liegen unter `docs/private/` und werden durch `.gitignore` geschützt.

---

## 11. Sicherheitsbewertung

### Im Lab

* lokaler Test gegen `127.0.0.1`,
* eigener Lab-Key,
* leere Passphrase für Lern- und Automatisierungszweck,
* private Screenshots und Terminalmitschnitte nicht im Git-Commit.

### In Produktion zusätzlich wichtig

* Private Keys niemals teilen,
* Schlüssel möglichst mit Passphrase schützen,
* SSH-Agent gezielt nutzen,
* alte Keys regelmäßig entfernen,
* Zugriff an Rollen und Verantwortlichkeiten koppeln,
* zentrale Verwaltung prüfen,
* Passwortlogin kontrolliert einschränken,
* Logging und Monitoring aktivieren,
* Notfallzugang dokumentieren.

---

## 12. Rollback im Lab

Wenn der Lab-Key entfernt werden soll:

```bash
rm ~/.ssh/ubuntu_lab_ed25519 ~/.ssh/ubuntu_lab_ed25519.pub
```

Zusätzlich müsste der passende Public-Key-Eintrag aus `~/.ssh/authorized_keys` entfernt werden.

Wichtig:

Nicht einfach blind `authorized_keys` löschen, weil dort auch andere erlaubte Schlüssel stehen könnten.

Sicherer wäre:

```bash
nano ~/.ssh/authorized_keys
```

und dann nur die passende Zeile entfernen.

---

## 13. Typische Fehlerbilder

| Symptom                                  | Mögliche Ursache                      | Diagnose                             |
| ---------------------------------------- | ------------------------------------- | ------------------------------------ |
| `Permission denied (publickey,password)` | Key nicht erlaubt oder falscher Key   | `ssh -v ...`                         |
| Passwortabfrage trotz Key                | Key wird nicht genutzt                | `-i` und `IdentitiesOnly=yes` prüfen |
| `Bad permissions`                        | Dateirechte zu offen                  | `ls -la ~/.ssh`                      |
| kein Logeintrag                          | Verbindung kommt nicht beim Dienst an | `journalctl -u ssh`                  |
| falscher Fingerprint                     | anderer Key als erwartet              | Public Key und Log vergleichen       |

---

## 14. Lessons Learned

* Passwortlogin und Key-Login sind unterschiedliche Authentifizierungswege.
* Ein funktionierender SSH-Dienst beweist noch keinen erfolgreichen Login.
* `authorized_keys` entscheidet, welche Public Keys für den Benutzer akzeptiert werden.
* Der Private Key ist besonders schützenswert.
* Logs liefern den stärksten technischen Nachweis für den tatsächlich verwendeten Login-Typ.
* Screenshots sind gute private Lernnachweise, aber öffentliche Doku sollte bereinigt werden.
* Kleine Befehlsmuster wie `grep "Accepted publickey"` machen Logdiagnose deutlich effizienter.

---

## 15. Statusmeldung

```text
SSH-Key-Authentifizierung wurde im Ubuntu-Lab vorbereitet, getestet und dokumentiert. Ein Ed25519-Keypair wurde erzeugt, der Public Key in authorized_keys eingetragen und der Login gegen 127.0.0.1 erfolgreich verifiziert. Der SSH-Log bestätigt Accepted publickey für den Benutzer marc. Technische Nachweise wurden unter docs/operations/ gespeichert, private Screenshots liegen geschützt unter docs/private/.
```
