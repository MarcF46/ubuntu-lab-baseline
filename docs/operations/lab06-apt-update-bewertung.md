# Lab 06 – apt Update-Prüfung und Update-Bewertung

## Ziel

Im Lab wurde der Paketupdate-Status eines Ubuntu-Lab-Systems geprüft, ohne Updates direkt zu installieren.

Der Schwerpunkt lag auf einer sicheren Vorab-Bewertung:

- Paketquellen aktualisieren
- verfügbare Updates anzeigen
- Upgrade trocken simulieren
- Risiko und nächsten Schritt bewerten

## Typisches Betriebsszenario

Ein Linux-Server soll aktualisiert werden. Vor einer Installation muss geprüft werden, welche Pakete betroffen sind, ob Security-Updates enthalten sind, ob Pakete installiert oder entfernt würden und ob ein Wartungsfenster nötig ist.

## Technischer Nachweis

Es wurde ein apt update durchgeführt, anschließend wurden verfügbare Updates angezeigt und ein simulierter Upgrade-Lauf ausgeführt.

Der Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab06-apt/lab06-apt-update-pruefung-raw.txt

## Beobachtetes Ergebnis

- 20 Pakete waren aktualisierbar.
- 10 standard LTS security updates wurden gemeldet.
- Der simulierte Upgrade-Lauf zeigte: Installiere 0, Entferne 0, Aktualisiere nicht 0.
- Es wurden keine Paketentfernungen und keine zusätzlich zu installierenden Pakete angezeigt.

Betroffene Paketgruppen:

- HEIF/Image-Bibliotheken
- Vim/xxd
- Ubuntu Release Upgrader
- Update Notifier
- Local Search / Ressourcen

## Betriebliche Bewertung

Die Ausgabe zeigt mehrere verfügbare Updates, darunter Security-relevante Updates. Da der Dry-Run keine Paketentfernungen, keine zusätzlichen Installationen und keine zurückgehaltenen Pakete zeigte, wirkt der geplante Update-Lauf strukturell überschaubar.

Trotzdem sollte ein echter Update-Lauf nicht blind erfolgen. Vor produktiven Updates wären ein Wartungsfenster, ein aktuelles Backup beziehungsweise Snapshot, eine Rollback-Option und eine Nachprüfung erforderlich.

## Wichtiger Hinweis zu apt in Skripten

apt meldet selbst, dass die CLI-Schnittstelle für Skripte nicht als stabil garantiert ist. Für interaktive Admin-Arbeit ist apt üblich. Für robuste Automatisierung sind apt-get und apt-cache oft besser geeignet.

## Nächster professioneller Schritt

Vor einer echten Installation sollte geprüft werden, ob ein Reboot erforderlich werden könnte und welche Dienste nach dem Update zu verifizieren sind. Danach kann ein kontrollierter Update-Lauf mit anschließender Health-Prüfung geplant werden.

## Merksätze

- apt update liest den Katalog.
- apt list --upgradable zeigt offene Updates.
- apt upgrade --simulate zeigt den möglichen Umbauplan.
- Security-Updates sind wichtig, aber trotzdem kontrolliert einzuspielen.
- Update ohne Nachprüfung ist nur halbe Betriebsarbeit.
