# Spätere Lab-Themen

## Zweck

Diese Datei sammelt spätere Lab-Themen, die während der praktischen Linux-Junior-Admin- und Cloud-Ops-Übungen als wichtig erkannt wurden.

Die Themen werden nicht sofort umgesetzt, sondern bewusst als eigene spätere Lerneinheiten geplant. Dadurch bleibt das aktuelle Lab fokussiert, ohne wichtige Betriebsaspekte zu verlieren.

---

## 1. Monitoring für SSH- und Service-Zustände

### Ausgangspunkt

Im aktuellen SSH-Lab wurden SSH-Dienststatus, Port 22, Passwortlogin, SSH-Key-Login und passende Lognachweise geprüft.

Dabei wurde sichtbar:

```text
Ein Dienst kann technisch laufen,
aber Betriebssicherheit entsteht erst durch kontinuierliche Überwachung.
```

### Spätere Lab-Idee

Monitoring soll als eigene Lerneinheit aufgebaut werden.

Mögliche Schwerpunkte:

* SSH-Dienststatus überwachen
* Port-22-Erreichbarkeit prüfen
* erfolgreiche und fehlgeschlagene SSH-Logins auswerten
* auffällige Loginversuche erkennen
* einfache Health Checks automatisieren
* Alerting bei Dienst-Ausfall vorbereiten
* Logauswertung mit `journalctl`, später eventuell zentraler Logging- oder Monitoring-Lösung

### Betriebliche Einordnung

Monitoring ist nicht nur ein Dashboard-Thema. Es beantwortet im Betrieb die Frage:

```text
Merkt das Team rechtzeitig, wenn ein wichtiger Zugriff oder Dienst ausfällt?
```

Merksatz:

```text
Logs erklären den Brand.
Monitoring riecht den Rauch.
```

---

## 2. Notfallzugang / Break-Glass-Konzept

### Ausgangspunkt

SSH-Key-Login wurde im Lab erfolgreich vorbereitet und getestet. In späteren produktionsnahen Umgebungen reicht ein normaler Login-Weg aber nicht immer aus.

Mögliche Störfälle:

* zentrale Anmeldung fällt aus
* SSH-Key-Verwaltung ist fehlerhaft
* falsche Firewall-Regel blockiert Zugriff
* Admin sperrt sich selbst aus
* Identity-System ist nicht erreichbar
* Passwortlogin wurde deaktiviert, aber Key-Zugriff funktioniert nicht wie erwartet

### Spätere Lab-Idee

Notfallzugänge sollen als eigene Lerneinheit geplant werden.

Mögliche Schwerpunkte:

* Break-Glass-Konzept erklären
* Notfallkonto im Lab simulieren
* Zugriff besonders schützen
* Nutzung dokumentieren
* Testbarkeit sicherstellen
* Missbrauchsrisiken bewerten
* Lab-vs-Production-Unterschiede dokumentieren
* Notfallzugang nicht als Komfortzugang missverstehen

### Betriebliche Einordnung

Ein Notfallzugang ist kein normaler Admin-Alltag, sondern ein kontrollierter Rettungsweg.

Merksatz:

```text
Der Notfallzugang ist der versiegelte Generalschlüssel.
Selten benutzt, streng geschützt, aber im Ernstfall getestet.
```

---

## 3. Geplanter Platz in der Lernreihenfolge

Voraussichtliche Reihenfolge:

```text
Lab 01: SSH-Baseline und SSH-Key-Login
Lab 02: Benutzer, Gruppen und sudo-Grundlagen
Lab 03: systemd-Services und Logs
Lab 04: Firewall-Grundlagen
Lab 05: Monitoring für SSH- und Service-Zustände
Lab 06: Notfallzugang / Break-Glass-Konzept
```

Die Reihenfolge kann später angepasst werden, wenn vorher andere Grundlagen notwendig sind.

---

## 4. Dokumentationsprinzip

Für diese späteren Labs soll weiterhin folgendes Muster gelten:

```text
Technischer Nachweis
→ betriebliche Bewertung
→ nächster professioneller Gedanke
```

Ziel ist nicht nur, Befehle auszuführen, sondern Betriebszustände nachvollziehbar zu prüfen, Risiken zu erkennen und daraus saubere nächste Schritte abzuleiten.
