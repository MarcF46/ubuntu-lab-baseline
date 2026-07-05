# Lab22 – Git Remote, Branch Tracking und Push-Kette

## Ziel

Diese Notiz dokumentiert die Git-Schichten bei Push-Problemen.

## Schichtenmodell

1. Arbeitsbaum
2. Commit
3. Branch
4. Remote
5. Authentifizierung
6. GitHub-Repository

## Kernaussage

Der lokale Branch main kann einem entfernten Branch origin/main folgen.

Wenn main und origin/main auf demselben Commit stehen, ist lokal und GitHub synchron.

Wenn main ahead ist, gibt es lokale Commits, die noch nicht gepusht wurden.

Wenn main behind ist, gibt es Remote-Commits, die lokal noch nicht vorhanden sind.

## Merksatz

Nicht raten. Erst die Git-Schicht finden, dann den Fehler beheben.
