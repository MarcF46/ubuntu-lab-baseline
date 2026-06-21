# Lab 06 – Reboot- und Risiko-Bewertung

## Ziel

Im Lab wurde geprüft, ob die aktuell verfügbaren Paketupdates Hinweise auf einen Neustart oder besonders kritische Systemkomponenten enthalten.

## Typisches Betriebsszenario

Ein Linux-Server hat offene Updates. Vor der Installation muss bewertet werden, ob ein Reboot wahrscheinlich ist, ob kritische Komponenten betroffen sind und ob ein normales Wartungsfenster ausreicht.

## Technischer Nachweis

Der Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab06-apt/lab06-reboot-und-risiko-pruefung-raw.txt

## Beobachtetes Ergebnis

- Kein aktueller Reboot-Marker unter /var/run/reboot-required vorhanden.
- Keine offensichtlichen Kernel-, systemd-, libc-, SSH-, Docker-, Netzwerk- oder Firewall-Pakete in der gefilterten Upgrade-Liste gefunden.
- Der simulierte Upgrade-Lauf zeigte 20 aktualisierbare Pakete.
- Es wurden 0 neue Pakete installiert, 0 Pakete entfernt und 0 Pakete zurückgehalten.

## Betriebliche Bewertung

Die Prüfung deutet auf einen überschaubaren Update-Lauf hin. Es gibt aktuell keinen vorhandenen Reboot-Marker und keine offensichtlichen kritischen Basisdienste in der gefilterten Update-Liste.

Trotzdem bleibt ein echter Update-Lauf eine kontrollierte Betriebsänderung. Vor produktiven Updates sollten Backup oder Snapshot, Wartungsfenster, Rollback-Möglichkeit und anschließende Health-Prüfungen eingeplant werden.

## Nächster professioneller Schritt

Als nächster Schritt sollte ein kontrollierter Update-Ablauf vorbereitet werden: Vorprüfung, Installation, Nachprüfung, Reboot-Bewertung und kurze Statusmeldung.

## Merksätze

- Kein Reboot-Marker heißt: aktuell kein Neustart angefordert.
- Kritische Pakete zuerst erkennen, dann Update-Fenster planen.
- 0 installiert, 0 entfernt, 0 zurückgehalten wirkt strukturell risikoärmer.
- Update ohne Nachprüfung ist nur halbe Betriebsarbeit.
