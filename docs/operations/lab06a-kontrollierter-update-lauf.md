# Lab 06a – Kontrollierter Update-Lauf

## Ziel

Der vorbereitete Update-Change wurde kontrolliert durchgeführt und anschließend technisch nachgeprüft.

## Typisches Betriebsszenario

Nach Vorprüfung, Rollback-Referenz und Change-Plan wird ein Paketupdate durchgeführt. Direkt danach werden Reboot-Bedarf, systemd-Fehlerzustände, SSH-Service und verbleibende Updates geprüft.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab06a-update-change/lab06a-update-lauf-raw.txt

## Beobachtetes Ergebnis

- apt-get upgrade Exit-Code: 0
- Verbleibende Updates nach Update: 0
- Reboot-Zustand nach Update: kein aktueller Reboot-Marker vorhanden
- SSH-Service-Zustand nach Update: active
- systemd failed units nach Update: 0

## Betriebliche Bewertung

Der Update-Lauf wurde nicht blind durchgeführt, sondern nach dokumentierter Vorprüfung und Rollback-Referenz. Entscheidend ist jetzt nicht nur, dass apt beendet wurde, sondern ob das System nach der Änderung weiterhin in einem gesunden Zustand ist.

## Nächster professioneller Schritt

Als nächster Schritt wird der Nachher-Zustand mit dem Vorher-Zustand verglichen und eine kurze Statusmeldung zum Change erstellt.

## Merksätze

- Update ist Änderung, nicht nur Installation.
- Nach dem Update zählt der Systemzustand.
- Exit-Code 0 ist gut, aber Health Checks liefern den Betriebsnachweis.
- Erst absichern, dann ändern, dann beweisen.
