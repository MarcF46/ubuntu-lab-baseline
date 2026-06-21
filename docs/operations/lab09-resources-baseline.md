# Lab 09 – Ressourcen Baseline

## Ziel

Im Lab wurde eine erste Ressourcen-Baseline des Ubuntu-Systems erstellt. Geprüft wurden CPU, Load Average, RAM, Swap und auffällige Prozesse nach CPU- und Speicherverbrauch.

## Typisches Betriebsszenario

Ein Linux-System wirkt langsam, reagiert verzögert oder Dienste laufen instabil. Vor tieferer Fehlersuche wird geprüft, ob CPU, RAM, Swap oder einzelne Prozesse auffällig sind.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab09-resources/lab09-resources-baseline-raw.txt

## Beobachteter Zustand

- Logische CPU-Kerne: 12
- Load Average 1/5/15 Minuten: 0.49 / 0.62 / 0.45
- Load bezogen auf CPU-Kerne ungefähr: 4% der verfügbaren CPU-Kapazität
- RAM gesamt: 14893 MiB
- RAM genutzt: 5203 MiB (35%)
- RAM verfügbar: 9689 MiB
- Swap gesamt: 4095 MiB
- Swap genutzt: 0 MiB
- Auffälligster Prozess nach RAM: Isolated Web Co (PID 7098, 6.5% RAM)
- Auffälligster Prozess nach CPU: firefox (PID 6249, 9.6% CPU)

## Betriebliche Bewertung

Die Ressourcen-Baseline dient als Ausgangspunkt für spätere Performance- und Incident-Diagnosen. Besonders wichtig sind Load Average im Verhältnis zur CPU-Anzahl, verfügbarer RAM, Swap-Nutzung und auffällige Prozesse.

Hohe CPU- oder RAM-Nutzung ist nicht automatisch ein Fehler. Entscheidend ist, ob die Last dauerhaft hoch ist, ob Dienste betroffen sind und ob Logs oder Health Checks parallel Auffälligkeiten zeigen.

## Nächster professioneller Schritt

Als nächster Schritt werden ein Runbook und eine Checkliste für Ressourcen- und Prozessdiagnose erstellt.

## Merksätze

- CPU ist die Arbeitskraft.
- RAM ist die Werkbank.
- Swap ist die Notablage.
- Load zeigt, wie viele Aufgaben auf Bedienung warten.
- Ein kurzer Peak ist normal, dauerhafte Überlast ist ein Incident-Kandidat.
- Maschinenlesbare Ausgaben sollten sprachunabhängig erzeugt werden.
