# Lab20a – Bewertung: Rechte-Baseline und sudo-Vorprüfung

## Zweck

Diese Bewertung fasst die Lab20a-Rechte-Baseline in einer öffentlichen, sanitizten Form zusammen.

Die vollständigen Rohdaten liegen ausschließlich unter docs/private und werden nicht versioniert.

## Ausgangspunkt

Die Rechte-Baseline wurde für den primären Lab-Benutzer auf dem Ubuntu-Lab-System erhoben.

Geprüft wurden Benutzerkontext, Gruppenmitgliedschaften, sudo-Verhalten, sudoers-Dateirechte und private Rohdatenhygiene.

## Wesentliche Befunde

| Bereich | Befund | Bewertung |
|---|---|---|
| Benutzerkontext | normaler Benutzer mit UID 1000 | erwartbarer lokaler Hauptbenutzer |
| sudo-Gruppe | Benutzer ist Mitglied der sudo-Gruppe | volle administrative Rechte nach Authentifizierung möglich |
| sudo non-interaktiv | sudo ohne Passwortabfrage schlägt fehl | gut für Automatisierungshygiene, keine stille Rechteausweitung |
| sudo-Rechteauskunft | Benutzer darf über sudo alle Befehle ausführen | im Lab akzeptabel, in Produktion eng zu prüfen |
| adm-Gruppe | Benutzer ist Mitglied der adm-Gruppe | Zugriff auf bestimmte Log- und Systeminformationen möglich |
| lpadmin-Gruppe | Benutzer ist Mitglied der lpadmin-Gruppe | lokale Druckeradministration möglich |
| lxd-Gruppe | Benutzer ist Mitglied der lxd-Gruppe | betrieblich kritisch zu bewerten, da LXD weitreichende Systemwirkung haben kann |
| sudoers-Rechte | sudoers-Dateien sind root-eigentümergeführt und nur eingeschränkt lesbar | erwartbarer Schutzstatus |
| private Rohdaten | docs/private erscheint nicht im Git-Status | Rohdatenhygiene erfüllt |

## Einordnung: sudo

Der Lab-Benutzer besitzt durch die sudo-Gruppe grundsätzlich vollständige administrative Rechte nach erfolgreicher Authentifizierung.

Der non-interaktive sudo-Test schlägt fehl. Das bedeutet: Skripte oder Agenten können nicht still und ohne Passwortabfrage sudo nutzen.

Für Lab18 und Lab19 bestätigt das die Entscheidung, den Monitoring-Agenten ohne sudo zu betreiben.

## Einordnung: Gruppenmitgliedschaften

Die Gruppenmitgliedschaften zeigen typische lokale Desktop-/Admin-Rechte eines Lab-Systems.

Besonders relevant sind sudo, adm und lxd.

- sudo ermöglicht administrative Tätigkeiten nach Authentifizierung.
- adm kann Log- und Diagnosezugriffe erleichtern.
- lxd muss bewusst geprüft werden, weil Containerfunktionen je nach Konfiguration starke Auswirkungen auf das Hostsystem haben können.

## Betriebsbewertung

Für das persönliche Lab ist der Zustand nachvollziehbar und arbeitsfähig.

Für produktionsnahe Systeme wäre eine genauere Trennung sinnvoll:

- täglicher Benutzer ohne permanente Admin-Rechte,
- separater Admin- oder Break-Glass-Zugang,
- gezielte sudo-Regeln statt pauschalem ALL,
- regelmäßige Prüfung privilegierter Gruppen,
- Dokumentation, warum eine Gruppe benötigt wird,
- keine Agenten mit unnötigen sudo-Rechten.

## Rohdatenhygiene

Die vollständige Rechte-Baseline wurde unter docs/private/evidence/lab20-rights abgelegt.

Der Git-Status zeigte ausschließlich den öffentlichen Arbeitsauftrag als untracked Datei. Private Rohdaten wurden nicht zur Versionierung angeboten.

Damit gilt weiterhin das Prinzip: Rohdaten privat, Bewertung öffentlich.

## Risikoanalyse

| Risiko | Bewertung | Maßnahme |
|---|---|---|
| breite sudo-Rechte | im Lab akzeptabel, in Produktion kritisch | Rechtebedarf dokumentieren und begrenzen |
| lxd-Mitgliedschaft | potenziell stark privilegiert | nur bei Bedarf vergeben und regelmäßig prüfen |
| Logzugriffe über adm | betrieblich nützlich, aber informationssensibel | Zugriff bewusst dokumentieren |
| Agenten mit sudo | vermieden | Agenten ohne unnötige Rechte betreiben |
| private Rohdaten im Repository | aktuell nicht sichtbar | docs/private weiterhin nicht committen |

## Ergebnis

Lab20a hat bestätigt, dass der aktuelle Lab-Benutzer administrativ arbeitsfähig ist, sudo aber nicht non-interaktiv ohne Authentifizierung genutzt werden kann.

Die Rechte-Baseline unterstützt die weitere Arbeit an minimalen Rechten, sudo-Hygiene und sicheren Betriebsmodellen.

## Merksätze

- Rechte sind ein prüfbarer Zustand, keine Vermutung.
- sudo ist ein Werkzeug, kein Freifahrtschein.
- Agenten bekommen nur die Rechte, die sie wirklich brauchen.
- Rohdaten privat, Bewertung öffentlich.
