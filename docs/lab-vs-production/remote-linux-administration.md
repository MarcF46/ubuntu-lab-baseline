# Lab vs. Production: Remote Linux Administration

## Zweck

Dieses Dokument ordnet die SSH-Remote-Administration aus Lab 01 fachlich ein.

SSH bedeutet **Secure Shell**. Damit kann ein Linux-System über das Netzwerk per Terminal administriert werden.

Im Lab wurde geprüft:

* OpenSSH Server ist installiert.
* Der SSH-Dienst läuft aktiv.
* Der SSH-Dienst ist für den Systemstart aktiviert.
* Port 22 lauscht.
* technische Nachweise wurden gespeichert.
* ein Health-Check-Skript wurde erstellt und erfolgreich getestet.

Dieses Dokument erklärt, was davon für ein Lern- und Portfolio-Lab ausreicht und was in einer echten Produktionsumgebung zusätzlich berücksichtigt werden müsste.

---

## 1. Lab-Ziel

Im Lab ging es nicht darum, eine vollständige Enterprise-SSH-Architektur aufzubauen.

Das Ziel war:

```text
Linux-System remote administrierbar machen
→ Zustand prüfen
→ Dienst aktivieren
→ Port prüfen
→ Logs prüfen
→ Nachweise speichern
→ wiederholbaren Health Check erstellen
```

Damit wurde ein grundlegender Betriebsablauf trainiert:

```text
Prüfen → Ändern → Verifizieren → Dokumentieren → Automatisieren
```

---

## 2. Was im Lab umgesetzt wurde

| Bereich            | Lab-Umsetzung                           |
| ------------------ | --------------------------------------- |
| System             | lokales Ubuntu-Lab-System               |
| Benutzer           | lokaler Benutzer `marc`                 |
| Rechte             | Benutzer ist Mitglied der Gruppe `sudo` |
| Dienst             | OpenSSH Server                          |
| Service-Management | `systemctl`                             |
| Netzwerkprüfung    | `ip`, `ip route`, `ss`                  |
| Logprüfung         | `journalctl -u ssh`                     |
| Nachweise          | Textdateien unter `docs/operations/`    |
| Screenshots        | private Nachweise unter `docs/private/` |
| Automatisierung    | `scripts/check-ssh-baseline.sh`         |

---

## 3. Warum diese Lab-Umsetzung sinnvoll ist

Die Lab-Umsetzung ist sinnvoll, weil sie typische Junior-Admin-Grundlagen trainiert:

* Paketstatus prüfen
* Dienststatus prüfen
* Dienst starten und aktivieren
* Portstatus prüfen
* Logs lesen
* Ergebnisse dokumentieren
* Fehlerzustände einordnen
* wiederholbare Checks als Skript bauen

Das ist praxisnah, weil ähnliche Prüfungen auch im echten Betrieb regelmäßig vorkommen.

---

## 4. Was im Lab bewusst einfach gehalten wurde

| Thema              | Vereinfachung im Lab                                              |
| ------------------ | ----------------------------------------------------------------- |
| Benutzerverwaltung | lokaler Linux-Benutzer statt zentraler Identität                  |
| SSH-Zugriff        | Standardport 22                                                   |
| Netzwerk           | lokales Heimnetz                                                  |
| Firewall           | noch keine harte Segmentierung                                    |
| Authentifizierung  | grundlegende SSH-Baseline, noch kein vollständiges Key-Management |
| Monitoring         | manuelles Skript statt zentralem Monitoring-System                |
| Logging            | lokale Logs statt zentraler Logplattform                          |
| Change-Prozess     | Lernablauf statt formaler Change-Freigabe                         |
| Notfallzugang      | noch kein dokumentiertes Break-Glass-Konzept                      |

Break-Glass bedeutet ein Notfallzugang für Ausnahmesituationen, wenn normale Zugriffswege nicht funktionieren. Solche Zugänge müssen besonders streng geschützt und dokumentiert sein.

---

## 5. Produktionsanforderungen

In einer echten Umgebung würde SSH nicht einfach nur installiert und aktiviert.

Zusätzlich wären typischerweise folgende Punkte relevant:

### Zugriffsschutz

* SSH-Zugriff nur für berechtigte Personen
* möglichst keine allgemeinen Sammelaccounts
* klare Rollen und Verantwortlichkeiten
* zentrale Benutzerverwaltung, zum Beispiel Active Directory, LDAP oder Cloud Identity
* regelmäßige Prüfung nicht mehr benötigter Zugänge

LDAP bedeutet **Lightweight Directory Access Protocol**. Es wird genutzt, um Benutzer- und Verzeichnisinformationen zentral bereitzustellen.

### Authentifizierung

* SSH-Key-basierte Anmeldung bevorzugen
* Passwortlogin einschränken oder deaktivieren
* private Schlüssel sicher speichern
* Schlüsselrotation planen
* verlorene oder kompromittierte Schlüssel entfernen
* bei besonders kritischen Systemen zusätzliche Schutzmechanismen nutzen

SSH-Key bedeutet: Statt nur Benutzername und Passwort wird ein kryptografisches Schlüsselpaar verwendet. Der öffentliche Schlüssel liegt auf dem Server, der private Schlüssel bleibt beim Benutzer.

### Netzwerkzugriff

* SSH nicht unnötig aus dem Internet erreichbar machen
* Zugriff über VPN, Bastion Host oder Jump Host
* Firewall-Regeln nach Least-Privilege-Prinzip
* Zugriff nur aus erlaubten Netzen
* Trennung von Admin-Netz und normalen Client-Netzen

VPN bedeutet **Virtual Private Network**. Es ermöglicht einen geschützten Zugang in ein internes Netzwerk.

Ein Bastion Host oder Jump Host ist ein besonders geschützter Zwischenserver, über den Administratoren auf interne Systeme zugreifen.

### Logging und Monitoring

* SSH-Loginversuche überwachen
* fehlgeschlagene Logins erkennen
* ungewöhnliche Quell-IP-Adressen prüfen
* Logs zentral sammeln
* Alarmierung bei auffälligen Zugriffsmustern
* Health Checks in ein Monitoring-System integrieren

### Härtung

* SSH-Konfiguration prüfen
* unnötige Login-Methoden deaktivieren
* Root-Login über SSH vermeiden
* nur benötigte Benutzer zulassen
* Timeouts und Login-Versuche begrenzen
* Fail2ban oder vergleichbare Schutzmechanismen prüfen

Fail2ban ist ein Werkzeug, das wiederholte fehlgeschlagene Loginversuche erkennen und die Quelladresse temporär blockieren kann.

### Dokumentation und Betrieb

* Zugriffskonzept dokumentieren
* Änderungen über Tickets oder Change-Prozess steuern
* Rollback-Möglichkeit planen
* Notfallzugang dokumentieren
* Verantwortlichkeiten festlegen
* regelmäßige Überprüfung der Konfiguration

---

## 6. Typische Produktionsrisiken

| Risiko                       | Beschreibung                                                |
| ---------------------------- | ----------------------------------------------------------- |
| offener SSH-Port im Internet | Angriffsfläche für Brute-Force-Versuche                     |
| Passwortlogin aktiv          | erhöhtes Risiko bei schwachen Passwörtern                   |
| alte Benutzerkonten          | ehemalige Mitarbeiter oder alte Testkonten behalten Zugriff |
| fehlendes Logging            | Angriffe oder Fehlkonfigurationen werden spät erkannt       |
| fehlende Firewall-Regeln     | zu viele Systeme können SSH erreichen                       |
| ungetestete Änderungen       | Admin sperrt sich selbst aus                                |
| keine Break-Glass-Strategie  | kein sauberer Notfallzugang bei Ausfall                     |
| keine Dokumentation          | Betrieb ist personenabhängig und schwer nachvollziehbar     |

Brute Force bedeutet: Ein Angreifer probiert sehr viele Benutzername-/Passwort-Kombinationen automatisiert aus.

---

## 7. Sicheres Änderungsmuster bei SSH

Bei SSH-Änderungen gilt besonders:

```text
Nie eine funktionierende SSH-Sitzung schließen,
bevor eine neue Verbindung erfolgreich getestet wurde.
```

Sicheres Muster:

```text
1. Bestehende Sitzung offen lassen
2. Änderung vorbereiten
3. Konfiguration prüfen
4. Dienst neu laden oder neu starten
5. neue SSH-Verbindung testen
6. erst danach alte Sitzung schließen
```

Bei Konfigurationsänderungen wäre zusätzlich wichtig:

```bash
sudo sshd -t
```

Dieser Befehl prüft die SSH-Serverkonfiguration auf Syntaxfehler.

---

## 8. Bewertung des aktuellen Lab-Standes

| Kategorie               | Bewertung                                                 |
| ----------------------- | --------------------------------------------------------- |
| Lernzweck               | geeignet                                                  |
| Junior-Admin-Grundlagen | gut geeignet                                              |
| Portfolio-Nachweis      | geeignet, wenn sachlich dokumentiert                      |
| Produktionsnähe         | erste Grundlage, aber noch keine produktionsreife Härtung |
| Sicherheitsniveau       | Basisprüfung, kein vollständiges Hardening                |
| Automatisierung         | erster sinnvoller Schritt durch Health-Check-Skript       |

Wichtig:

Das Lab sollte öffentlich nicht als „produktionsfertige SSH-Härtung“ dargestellt werden.

Besser wäre:

```text
Im Lab wurde eine grundlegende SSH-Baseline aufgebaut, geprüft, dokumentiert und durch ein kleines Health-Check-Skript wiederholbar gemacht.
```

---

## 9. Mögliche nächste Ausbaustufen

### Technisch

* SSH-Key-Login einrichten
* Passwortlogin kontrolliert einschränken
* UFW-Firewall-Regel für SSH dokumentieren
* Fail2ban testen
* SSH-Konfiguration prüfen
* Health-Check-Skript erweitern
* Logs strukturierter auswerten

### Automatisierung

* Ansible Playbook für OpenSSH-Installation
* Ansible Role für SSH-Baseline
* automatisierte Verifikation nach Änderung
* Report-Ausgabe aus Health-Check-Skript
* später Monitoring-Anbindung

Ansible ist ein Automatisierungswerkzeug, mit dem Systeme wiederholbar konfiguriert werden können.

### Betrieb und Architektur

* Jump-Host-Konzept skizzieren
* Admin-Netz vs. Server-Netz unterscheiden
* Zugriffskonzept dokumentieren
* Risikoanalyse ergänzen
* Architekturdiagramm erstellen
* Lab-vs-Production-Entscheidungen als ADR dokumentieren

ADR bedeutet **Architecture Decision Record**. Das ist ein kurzes Dokument, in dem eine wichtige Architekturentscheidung mit Begründung festgehalten wird.

---

## 10. Kurze Statusmeldung

```text
Die SSH-Remote-Administration wurde im Ubuntu-Lab als grundlegende Baseline eingerichtet, geprüft und dokumentiert. Der Dienst läuft aktiv, ist für den Systemstart aktiviert und lauscht auf Port 22. Zusätzlich wurde ein Health-Check-Skript erstellt, erfolgreich ausgeführt und als Nachweis gespeichert. Für Produktionsumgebungen wären weitere Maßnahmen wie SSH-Key-Management, Zugriffsbeschränkung, zentrale Benutzerverwaltung, Firewall-Regeln, Logging, Monitoring und Härtung erforderlich.
```

---

## 11. Lessons Learned

* `history` speichert Befehle, aber nicht automatisch alle Ausgaben.
* Terminalausgaben sollten bei wichtigen Nachweisen gezielt gespeichert werden.
* `script` kann komplette Terminal-Sitzungen mitschneiden.
* private Mitschnitte gehören nicht ungeprüft in öffentliche Repositories.
* Platzhalter in Beispielbefehlen müssen durch echte Werte ersetzt werden.
* Health-Check-Skripte machen manuelle Prüfungen wiederholbar.
* Ein Lab kann sehr wertvoll sein, wenn klar dokumentiert wird, was Lab ist und was Produktion zusätzlich benötigt.

---

## 12. Merksatz

```text
Ein funktionierender Dienst ist noch kein sicher betriebener Dienst.
Ein guter Admin prüft Zustand, Risiko, Nachweis und Wiederholbarkeit.
```
