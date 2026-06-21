# Benutzer, Gruppen und sudo - betriebliche Einordnung

## Ausgangslage

Im Lab wurde geprüft, mit welchen Benutzer- und Gruppenrechten auf dem System `ubuntu-lab` gearbeitet wird. Zusätzlich wurde ein separater Testbenutzer ohne sudo-Rechte angelegt, um den Unterschied zwischen administrativ berechtigtem Benutzer und normalem Benutzer praktisch sichtbar zu machen.

Die technischen Nachweise liegen unter:

- docs/operations/user-groups-sudo-baseline.txt
- docs/operations/testbenutzer-ohne-sudo-baseline.txt

## Technischer Nachweis

Der Benutzer `marc` ist der primäre Lab-Benutzer. Die Prüfung zeigte, dass `marc` Mitglied mehrerer Gruppen ist, unter anderem:

- sudo
- adm
- plugdev
- lpadmin
- lxd

Die sudo-Prüfung zeigte:

- marc darf mit sudo grundsätzlich administrative Befehle ausführen.
- Die Ausgabe `(ALL : ALL) ALL` bedeutet sehr weitreichende administrative Rechte.

Zusätzlich wurde der Benutzer `labuser01` angelegt. Dieser Benutzer besitzt nur seine eigene Benutzergruppe und keine sudo-Rechte.

Die Tests mit `labuser01` zeigten:

- sudo-Befehle werden abgelehnt.
- Der Zugriff auf `/etc/shadow` wird verweigert.
- Der Benutzer kann als normaler Benutzer ausgeführt werden, erhält aber keine administrativen Rechte.

## Betriebliche Bewertung

Die Gruppe `sudo` ist im Lab sinnvoll, weil administrative Aufgaben ausgeführt, geprüft und dokumentiert werden sollen. In einer produktiven Umgebung wären vollständige sudo-Rechte jedoch sehr weitreichend und müssten fachlich begründet, dokumentiert und regelmäßig überprüft werden.

Die Gruppe `adm` ist relevant für Log-Zugriffe. Das kann im Betrieb hilfreich sein, weil Systemprotokolle für Diagnose und Fehleranalyse benötigt werden. Gleichzeitig können Logs sensible Informationen enthalten. Daher sollte auch Log-Zugriff nicht unkontrolliert vergeben werden.

Die Gruppe `lxd` ist besonders sicherheitsrelevant. LXD steht für Linux Containers Daemon und dient zur Verwaltung von Linux-Containern und virtuellen Maschinen. Je nach Systemkonfiguration kann diese Gruppe sehr mächtige Rechte ermöglichen. In produktiven Umgebungen sollte geprüft werden, ob diese Mitgliedschaft wirklich notwendig ist.

Der Testbenutzer `labuser01` bestätigt das gewünschte Schutzverhalten: Ein normaler Benutzer kann keine administrativen Aktionen ausführen und keine sensiblen Systemdateien wie `/etc/shadow` lesen.

## Risiko

Zu weitreichende Gruppenmitgliedschaften können dazu führen, dass ein Benutzer mehr Rechte erhält als fachlich notwendig. Besonders kritisch sind Gruppen, die direkt oder indirekt administrative Kontrolle ermöglichen können.

Beispiele für besonders relevante Gruppen:

- sudo
- lxd
- docker
- adm

Das Risiko besteht nicht nur in absichtlichem Missbrauch, sondern auch in Fehlbedienung, kompromittierten Benutzerkonten oder falsch verstandenen Berechtigungen.

## Lab-vs-Production-Einordnung

Im Lab ist es bewusst sinnvoll, dass der Hauptbenutzer starke Rechte besitzt. Dadurch können Installation, Diagnose, Service-Verwaltung, Dokumentation und Wiederherstellung trainiert werden.

In Production sollte stattdessen gelten:

- Nur notwendige Rechte vergeben.
- Administrative Rechte dokumentieren.
- Gruppenmitgliedschaften regelmäßig prüfen.
- Kritische Gruppen besonders kontrollieren.
- sudo-Nutzung protokollieren und nachvollziehbar halten.
- Normale Benutzerkonten strikt von administrativen Aufgaben trennen.

## Nächster professioneller Schritt

Als nächster Schritt sollte ein kleines Runbook entstehen, das beschreibt, wie Benutzer- und Gruppenrechte geprüft werden. Zusätzlich sollte eine kurze Troubleshooting-Karte dokumentieren, welche Symptome auf fehlende oder zu weitreichende Rechte hinweisen.
