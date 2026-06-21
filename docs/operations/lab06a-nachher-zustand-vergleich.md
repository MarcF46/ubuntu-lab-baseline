# Lab 06a – Nachher-Zustand und Vergleich nach kontrolliertem Update

## Ziel

Nach dem kontrollierten Update-Lauf wurde der Systemzustand erneut geprüft und mit der Vorher-Referenz verglichen.

## Typisches Betriebsszenario

Nach einer Paketaktualisierung muss geprüft werden, ob der Server weiterhin betriebsbereit ist, ob ein Reboot erforderlich wurde, ob systemd-Fehler aufgetreten sind und ob noch Updates offen sind.

## Technischer Nachweis

Die vollständigen Vergleichsdaten wurden bewusst privat abgelegt:

- docs/private/evidence/lab06a-update-change/post-update-reference-20260621-174656

## Beobachtetes Ergebnis

- Verbleibende Updates nach Update: 0
- Reboot-Zustand nach Update: kein aktueller Reboot-Marker vorhanden
- SSH-Service-Zustand nach Update: active
- systemd failed units nach Update: 0
- Paketversions-Diff-Zeilen: 40
- Diff-Zeilen bei manuell markierten Paketen: 0

## Betriebliche Bewertung

Der Nachher-Zustand zeigt einen erfolgreichen kontrollierten Update-Change. Es sind keine verbleibenden Updates sichtbar, kein aktueller Reboot-Marker ist vorhanden, der SSH-Service ist aktiv und systemd meldet keine fehlgeschlagenen Units.

Die Paketversionsänderungen sind erwartbar, weil zuvor 20 Pakete aktualisiert wurden. Entscheidend ist, dass die System-Health-Prüfungen nach der Änderung erfolgreich sind.

## Nächster professioneller Schritt

Als nächster Schritt wird eine kurze finale Statusmeldung zum Change erstellt und Lab 06a abgeschlossen.

## Merksätze

- Nachher-Zustand beweist, ob der Change gesund abgeschlossen wurde.
- Kein Reboot-Marker ist gut, ersetzt aber nicht die Health Checks.
- SSH active ist bei Remote-Servern ein Kernnachweis.
- Erst vergleichen, dann freigeben.
