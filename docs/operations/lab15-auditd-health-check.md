# Lab 15 – auditd Health-Check

## Ziel

Für auditd wurde ein wiederverwendbarer Health-Check erstellt. Der Check prüft Werkzeuge, Dienststatus, Konfigurationspfade, geladene Audit-Regeln und den finalen Ergebnisstatus.

## Ergebnis

- auditd Health-Check Exit-Code: 0

## Betriebliche Bewertung

Der Health-Check prüft bewusst mit sudo auf sicherheitsrelevante Pfade. Damit wird der Lernfehler aus der Berechtigungskontext-Diagnose direkt in den Prüfprozess übernommen.

## Merksätze

- Bei Security-Pfaden zählt der Berechtigungskontext.
- auditctl zeigt den geladenen Ist-Zustand.
- Health Checks machen Diagnosewissen wiederholbar.
