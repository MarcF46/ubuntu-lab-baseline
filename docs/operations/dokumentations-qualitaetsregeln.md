# Dokumentations-Qualitätsregeln

## Zweck

Diese Datei beschreibt die Dokumentationsregeln für das Linux-Junior-Admin- und Cloud-Ops-Lab.

Ziel ist eine Dokumentation, die für drei Zwecke nutzbar bleibt:

```text
1. privates Lernen und Wiederholen
2. spätere Arbeitsabläufe und Runbooks
3. öffentliches Portfolio und Bewerbungsprozesse
```

Dabei gilt:

```text
Private Doku zeigt den Lernweg.
Öffentliche Doku zeigt die Arbeitsweise.
```

---

## 1. Dokumentationsebenen

### Private Dokumentation

Private Dokumentation darf vollständig und roh sein.

Dazu gehören:

* Terminal-Transcripts
* private Screenshots
* persönliche Lernnotizen
* Fehlversuche
* vollständige Terminalausgaben
* lokale Pfade
* lokale IP-Adressen
* Zwischengedanken
* Tagesablauf-Endberichte

Speicherort:

```text
docs/private/
```

Dieser Ordner wird durch `.gitignore` geschützt und nicht in Git aufgenommen.

---

### Arbeitsnahe Dokumentation

Arbeitsnahe Dokumentation beschreibt wiederholbare Abläufe.

Dazu gehören:

* Runbooks
* Checklisten
* Troubleshooting Cards
* Health-Check-Skripte
* Lab-vs-Production-Einordnungen
* Statusmeldungen
* Betriebsbewertungen

Diese Dateien dürfen im Repository liegen, müssen aber sachlich und sauber formuliert sein.

---

### Öffentliche Portfolio-Dokumentation

Öffentliche Portfolio-Dokumentation soll kurz, konkret und bereinigt sein.

Sie soll zeigen:

* welches technische Problem gelöst wurde,
* welcher Betriebszustand geprüft wurde,
* welcher Nachweis erbracht wurde,
* welche Risiken erkannt wurden,
* welcher nächste professionelle Schritt daraus entsteht.

Nicht jeder private Lernschritt gehört in die öffentliche Darstellung.

---

## 2. Inhalte, die nicht öffentlich werden sollen

Folgende Inhalte bleiben privat oder müssen vor Veröffentlichung bereinigt werden:

```text
private SSH-Keys
Secrets
Tokens
Passwörter
vollständige Terminal-Transcripts
private Screenshots
Browserleisten
private Ordnernamen
lokale IPv6-Adressen
vollständige Login-Historien
unbereinigte System- und Netzwerkdetails
```

Besonders zu prüfen:

```text
system-baseline/ip-a.txt
```

Diese Datei kann lokale IP-Adressen, IPv6-Adressen und Interface-Details enthalten.

---

## 3. Technischer Nachweis und betriebliche Bewertung

Für wichtige Labs gilt folgendes Muster:

```text
Technischer Nachweis
→ betriebliche Bewertung
→ nächster professioneller Gedanke
```

Beispiel:

```text
Der SSH-Key-Login wurde technisch erfolgreich getestet.
Der SSH-Log bestätigte Accepted publickey.
Damit ist nicht nur ein erfolgreicher Login sichtbar, sondern auch die tatsächlich verwendete Authentifizierungsmethode.
Der nächste professionelle Schritt ist die Einordnung in Key-Verwaltung, Monitoring und Zugriffskonzept.
```

Merksatz:

```text
Der Befehl zeigt den Versuch.
Die Ausgabe zeigt das Ergebnis.
Der Log zeigt, was der Dienst wirklich bestätigt.
Die Bewertung zeigt, warum der Nachweis betrieblich wichtig ist.
```

---

## 4. Keine KI-Ratgeber-Optik in Dokumenten

Dokumente sollen nicht so wirken, als würde eine KI dem Lernenden Anweisungen geben.

Zu vermeiden:

```text
du solltest
ich empfehle dir
achte darauf
mach jetzt
```

Besser für öffentliche oder arbeitsnahe Dokumente:

```text
Im Lab wurde geprüft ...
Der Nachweis zeigt ...
Daraus ergibt sich ...
Betrieblich bedeutet das ...
Der nächste professionelle Schritt wäre ...
```

Für private Lernnotizen ist auch Ich-Form möglich:

```text
Mir ist aufgefallen ...
Ich habe geprüft ...
Ich habe daraus gelernt ...
```

---

## 5. Screenshots

Screenshots sind sinnvoll, wenn sie sichtbare technische Zustände belegen.

Geeignete Screenshot-Momente:

* erfolgreicher Health Check
* sichtbarer Fehlerzustand
* sichtbarer Fix
* erfolgreicher SSH-Login
* erfolgreicher Service-Status
* finaler Lab-Abschluss
* wichtiger Ops-Pack-Nachweis

Nicht jeder erfolgreiche Git-Commit braucht einen Screenshot.

Merksatz:

```text
Git beweist den Commit.
Screenshots beweisen sichtbare Zustände.
```

Private Screenshots werden abgelegt unter:

```text
docs/private/screenshots/
```

Öffentliche Screenshots werden nur nach Bereinigung verwendet.

---

## 6. Screenshot-Ablage

Neue Screenshots landen zuerst in:

```text
docs/private/screenshots/inbox/
```

Danach wird der neueste Screenshot gezielt verschoben.

Muster:

```bash
latest_screenshot=$(ls -t docs/private/screenshots/inbox/*.png | head -n 1)

mv "$latest_screenshot" \
"docs/private/screenshots/lab-01-remote-baseline/passender-dateiname.png"
```

Bedeutung:

```text
ls -t sortiert nach Zeit.
head -n 1 nimmt die neueste Datei.
Die Variable latest_screenshot merkt sich den Dateinamen.
mv verschiebt die Datei an den passenden Zielort.
```

---

## 7. Dateinamen-Konvention

Ordnernamen dürfen technisch und englisch bleiben.

Beispiele:

```text
docs/
runbooks/
scripts/
checklists/
troubleshooting/
```

Portfolio-sichtbare Dokumentdateien sollen möglichst deutsch benannt werden.

Beispiele:

```text
ssh-schluessel-authentifizierung-localhost.md
spaetere-lab-themen.md
dokumentations-qualitaetsregeln.md
remote-linux-administration-lab-vs-produktion.md
```

Regeln:

```text
klein schreiben
Bindestriche verwenden
keine Leerzeichen
möglichst keine Umlaute
sprechende Namen
```

Skripte und technische Tool-Dateien können weiterhin englisch bleiben, wenn das fachlich sinnvoll ist.

Beispiele:

```text
check-ssh-baseline.sh
ssh-health-check-output.txt
```

Merksatz:

```text
Ordner sind die Werkstattregale.
Dateinamen sind die sichtbaren Etiketten.
```

---

## 8. Umgang mit Logs

Logs sind starke technische Nachweise, müssen aber eingeordnet und ggf. bereinigt werden.

Geeignet für öffentliche oder arbeitsnahe Dokumentation:

```text
Accepted publickey for user from localhost
Service active running
Port 22 listening
Health check successful
```

Vor Veröffentlichung prüfen:

* Benutzername
* lokale IP-Adresse
* Hostname
* Fingerprints
* interne Pfade
* Zeitstempel
* private Systemdetails

Merksatz:

```text
Logs sind der Flugschreiber des Systems.
Vor Veröffentlichung wird der Flugschreiber ausgewertet, nicht ungeprüft kopiert.
```

---

## 9. Private Schlüssel und Secrets

Private Schlüssel, Tokens und Passwörter dürfen nicht in Git aufgenommen werden.

Besonders kritisch:

```text
~/.ssh/ubuntu_lab_ed25519
.env
secrets/
API tokens
Cloud credentials
SSH private keys
```

Der Public Key darf technisch verteilt werden, sollte aber im Portfolio trotzdem nur bewusst und nicht unnötig veröffentlicht werden.

Merksatz:

```text
Private Key = echter Schlüssel in der Tasche.
Public Key = Eintrag im Türsystem.
authorized_keys = Gästeliste an der Tür.
```

---

## 10. Public-Readiness-Check vor Veröffentlichung

Vor einem öffentlichen Push oder Portfolio-Link wird geprüft:

```text
1. Enthält das Repo private Dateien?
2. Ist docs/private/ wirklich ignoriert?
3. Enthalten Nachweise lokale IPs oder private Pfade?
4. Sind Dateinamen verständlich und deutsch genug?
5. Wirken Dokumente wie eigene geprüfte Arbeit?
6. Sind technische Nachweise und betriebliche Bewertung getrennt?
7. Wird nichts als produktionsreif dargestellt, was nur Lab-Status hat?
```

Technische Prüfung:

```bash
git status --short --ignored
git check-ignore -v docs/private/
find . -maxdepth 4 -path ./.git -prune -o -path ./docs/private -prune -o -type f -print | sort
```

Merksatz:

```text
Vor Öffentlichkeit gilt: bereinigen, prüfen, einordnen.
```

---

## 11. Leitprinzip

```text
Nicht alles dokumentieren, nur weil es dokumentierbar ist.
Nicht alles veröffentlichen, nur weil es technisch korrekt ist.
```

Ziel ist eine Dokumentation, die zeigt:

```text
Zustand geprüft.
Nachweis erbracht.
Risiko erkannt.
Nächster Schritt verstanden.
```
