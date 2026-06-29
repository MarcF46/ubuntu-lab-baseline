# Lab20b – Bewertung: Dateirechte-Diagnose

## Zweck

Diese Bewertung dokumentiert die Ergebnisse einer praktischen Dateirechte-Diagnose unter Linux.

Die vollständigen Rohdaten liegen ausschließlich unter docs/private und werden nicht versioniert.

## Testaufbau

Für den Test wurde ein temporäres Rechte-Labor unter /tmp erstellt und nach Abschluss wieder entfernt.

Geprüft wurden drei typische Rechtefälle:

- private Benutzerdatei mit Modus 600,
- Verzeichnis ohne Execute-/Traverse-Recht,
- root-owned Datei mit Modus 644.

## Ergebnisübersicht

| Testfall | Beobachtung | Bewertung |
|---|---|---|
| eigene Datei mit 600 | Lesen erfolgreich | Besitzer darf lesen und schreiben, Gruppe und Andere haben keinen Zugriff |
| Verzeichnis mit 600 | Listing teilweise möglich, Datei darin nicht lesbar | fehlendes x-Recht verhindert Pfadzugriff auf Inhalte |
| root-owned Datei mit 644 | Lesen erfolgreich, Schreiben verweigert | Leserecht für Andere erlaubt Lesen, Schreibrecht bleibt root vorbehalten |

## Einordnung: Datei-Modus 600

Der Modus 600 bedeutet: Besitzer darf lesen und schreiben, Gruppe und Andere haben keine Rechte.

Dieser Modus ist typisch für sensible Benutzerdateien, Schlüsselmaterial, private Konfigurationen oder lokale Rohdaten.

## Einordnung: Verzeichnis ohne x-Recht

Bei Verzeichnissen bedeutet das x-Recht nicht Programmausführung, sondern Betreten beziehungsweise Traversieren des Pfades.

Ein Verzeichnis kann lesbar wirken, aber ohne x-Recht sind enthaltene Dateien nicht zuverlässig erreichbar.

Das erklärt typische Permission-denied-Situationen, bei denen die Datei selbst scheinbar passende Rechte besitzt, der Zugriff aber durch ein übergeordnetes Verzeichnis blockiert wird.

## Einordnung: root-owned Datei mit 644

Der Modus 644 bedeutet: Besitzer darf lesen und schreiben, Gruppe und Andere dürfen lesen.

Wenn Besitzer und Gruppe root sind, kann ein normaler Benutzer die Datei lesen, aber nicht schreiben.

Dieses Muster ist bei vielen Systemkonfigurationsdateien üblich: sichtbar zur Diagnose, aber gegen unautorisierte Änderung geschützt.

## Diagnosemodell

Bei Permission denied wird schichtweise geprüft:

1. Welcher Benutzer führt den Befehl aus?
2. Welche Gruppen wirken?
3. Wem gehört die Datei?
4. Wem gehört die Gruppe?
5. Welche Datei-Rechte gelten?
6. Welche Verzeichnis-Rechte gelten auf dem gesamten Pfad?
7. Wird sudo wirklich benötigt oder ist die Zielberechtigung falsch gesetzt?

## Nützliche Diagnosebefehle

- Benutzerkontext prüfen: `id`
- Datei- und Verzeichnisrechte prüfen: `ls -l` und `ls -ld`
- Rechte numerisch anzeigen: `stat -c "%A %a %U %G %n" PFAD`
- kompletten Pfad prüfen: `namei -l PFAD`
- sudo-Rechte prüfen: `sudo -l`

## Betriebsbewertung

Lab20b zeigt, dass Rechteprobleme nicht nur an der Zieldatei diagnostiziert werden dürfen.

Besonders in Serverbetrieb, Backup, Logging, Deployments und Agent-Ausführung müssen Dateirechte, Besitzer, Gruppen und Pfadrechte gemeinsam betrachtet werden.

## Typische Betriebsfehler

| Fehlerbild | Wahrscheinliche Ursache | Prüfung |
|---|---|---|
| Datei existiert, Zugriff verweigert | fehlendes Recht auf Datei oder Pfad | ls -l, ls -ld, namei -l |
| Service kann Datei nicht lesen | Service läuft unter anderem Benutzer | systemctl cat, ps, id, stat |
| Skript läuft manuell, aber nicht als Service | anderer Rechtekontext unter systemd | systemctl cat, journalctl, WorkingDirectory prüfen |
| Schreiben schlägt fehl | Besitzer/Gruppe/Modus erlauben kein w-Recht | stat und ls -l prüfen |
| Verzeichnisinhalt sichtbar, Datei aber nicht nutzbar | fehlendes x-Recht auf Verzeichnis | ls -ld und namei -l prüfen |

## BSI-orientierte Einordnung

Die Diagnose unterstützt minimale Rechte, Nachvollziehbarkeit und gezielte Fehlerbehebung.

Statt pauschal sudo zu verwenden, wird zuerst geprüft, welcher konkrete Rechtebestand den Fehler verursacht.

## Ergebnis

Lab20b hat die Wirkung von Datei-, Besitzer-, Gruppen- und Verzeichnisrechten praktisch nachgewiesen.

Der wichtigste Befund ist, dass Verzeichnisrechte auf dem gesamten Pfad genauso entscheidend sein können wie die Rechte der Zieldatei selbst.

## Merksätze

- Permission denied ist kein Befehl für sudo, sondern ein Auftrag zur Diagnose.
- Bei Dateien zählt r, w und x; bei Verzeichnissen zählt x als Pfadzugang.
- Die Zieldatei ist nur eine Schicht. Der gesamte Pfad zählt.
- Erst prüfen, dann Rechte ändern.
