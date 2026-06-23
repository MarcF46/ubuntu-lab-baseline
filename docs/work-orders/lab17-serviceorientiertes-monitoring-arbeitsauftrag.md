# Lab17a – Arbeitsauftrag: Serviceorientiertes Monitoring

## Ausgangslage
Lab16 hat technische Einzelprüfungen zu Logrotate, Speicherplatz, Inodes, /var/log, offenen gelöschten Dateien und Healthcheck-Skripten aufgebaut.

Der nächste professionelle Schritt ist serviceorientiertes Monitoring. Dabei wird nicht nur geprüft, ob ein Host technisch läuft, sondern ob ein Dienst aus Benutzer- und Betriebssicht wirklich nutzbar ist.

## Ziel
In Lab17 wird ein erstes serviceorientiertes Monitoring-Konzept aufgebaut. Der Fokus liegt auf klaren Prüfschichten, sinnvollen Alarmen, Runbooks, Incident-Karten und späterer Automatisierung.

## Leitfrage
Nicht nur: Läuft der Server?

Sondern: Funktioniert der Service zuverlässig, nachvollziehbar und so, dass im Störungsfall die richtige Reaktion möglich ist?

## Monitoring-Schichten

| Schicht | Frage | Beispiel |
|---|---|---|
| Host | Ist das System erreichbar? | Ping, SSH (Secure Shell, verschlüsselter Fernzugriff), CPU (Central Processing Unit, Prozessor), RAM (Random Access Memory, Arbeitsspeicher), Disk (Datenträger- und Speicherbelegung). |
| Prozess | Läuft der Dienstprozess? | systemctl status nginx. |
| Port | Antwortet der Dienst am Netzwerkport? | Port 80 oder 443 erreichbar. |
| Anwendung | Liefert die Anwendung eine gültige Antwort? | HTTP (Hypertext Transfer Protocol, Web-Protokoll)-Status 200. |
| Funktion | Funktioniert eine echte Benutzeraktion? | Login, Formular, API (Application Programming Interface, Programmierschnittstelle)-Aufruf. |
| Betrieb | Gibt es Runbook, Alarmweg und Eskalation? | Incident-Karte und Verantwortlichkeit. |

## Wichtige Begriffe

| Begriff | Erklärung |
|---|---|
| Monitoring | Überwachung von Systemen, Diensten und Zuständen. |
| Alert | Alarmmeldung bei auffälligem oder kritischem Zustand. |
| Threshold | Schwellwert, ab dem eine Warnung oder ein Alarm ausgelöst wird. |
| Service | Fachlich nutzbarer Dienst, nicht nur ein einzelner Prozess. |
| SLO | Service Level Objective, messbares Ziel für Servicequalität. |
| SLA | Service Level Agreement, vereinbarte Serviceleistung gegenüber Kunden oder Nutzern. |
| Runbook | Standardisierte Betriebsanleitung für wiederholbare Prüfungen und Maßnahmen. |
| Incident | Störung oder Ereignis mit möglicher Auswirkung auf Betrieb oder Sicherheit. |

## Anforderungen

- Erst prüfen, dann ändern.
- Keine blinden Alarme ohne klare Handlung.
- Jeder wichtige Alarm braucht eine passende Bewertung oder Runbook-Idee.
- Technische Werte müssen in Service-Auswirkungen übersetzt werden.
- Lab-Dokumentation muss später als Portfolio- und Betriebsnachweis nutzbar sein.

## Risiken

| Risiko | Gegenmaßnahme |
|---|---|
| Zu viele Alarme | Nur relevante Zustände alarmieren. |
| Falsche Sicherheit | Nicht nur Hostwerte prüfen, sondern Servicefunktion. |
| Keine Handlung bei Alarm | Runbook oder Incident-Karte zuordnen. |
| Unklare Zuständigkeit | Eskalationsweg dokumentieren. |
| Lab-Werte falsch auf Production übertragen | Lab-vs-Production sauber unterscheiden. |

## Bezug zu Lab16
Das Healthcheck-Skript aus Lab16 liefert bereits OK, WARNING, CRITICAL und Exit-Codes. Diese Logik ist eine Grundlage für spätere Monitoring-Integration.

## Erfolgskriterien

- Das Zielbild für serviceorientiertes Monitoring ist dokumentiert.
- Host-, Prozess-, Port-, Anwendungs-, Funktions- und Betriebssicht sind unterschieden.
- Der Übergang von Lab16 zu Monitoring ist nachvollziehbar.
- Die nächsten praktischen Schritte sind klar.

## Nächste praktische Schritte

1. Lokale Dienste und Ports erfassen.
2. systemd-Dienstzustände prüfen.
3. einfache Port-Checks durchführen.
4. einfachen HTTP (Hypertext Transfer Protocol, Web-Protokoll)-Check aufbauen.
5. Healthcheck-Skript aus Lab16 als Monitoring-Baustein einordnen.
6. später Prometheus, Grafana und Alerting strukturiert vorbereiten.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Checks | manuell und lokal | automatisiert, zentral und wiederholbar. |
| Alarme | Lernorientiert | priorisiert, zuständigkeitsklar und dokumentiert. |
| Schwellwerte | einfache Startwerte | serviceabhängig und fachlich begründet. |
| Runbooks | Lernnachweis | Betriebs- und Übergabedokumentation. |
| Architektur | Einzelhost | Teil eines Monitoring-, Logging- und Incident-Konzepts. |

## Merksatz
Ein Host kann gesund aussehen, während der Service für Benutzer kaputt ist. Gutes Monitoring prüft deshalb nicht nur Technik, sondern Nutzbarkeit und Reaktion.
