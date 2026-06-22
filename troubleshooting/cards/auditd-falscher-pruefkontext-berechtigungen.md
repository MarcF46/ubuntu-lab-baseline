# Troubleshooting-Karte – auditd: falscher Prüfkontext bei Security-Pfaden

## Symptom

Nach der Installation von auditd wurde zunächst angezeigt, dass zentrale Konfigurationspfade nicht vorhanden seien:

- /etc/audit/auditd.conf: nicht_vorhanden
- /etc/audit/rules.d: nicht_vorhanden
- /etc/audit/rules.d/audit.rules: nicht_vorhanden

Gleichzeitig waren auditd und die Audit-Werkzeuge aktiv bzw. vorhanden:

- auditd Dienststatus: active
- auditd Autostartstatus: enabled
- auditctl vorhanden
- ausearch vorhanden
- aureport vorhanden
- augenrules vorhanden

## Warum das im Betrieb gefährlich ist

Das Symptom sieht zunächst so aus, als wären Paketdateien oder Konfigurationspfade fehlerhaft. Daraus könnten falsche Maßnahmen entstehen, zum Beispiel unnötiges Neuanlegen von Verzeichnissen, falsche Reparaturversuche oder Änderungen an einer eigentlich vorhandenen Sicherheitskonfiguration.

## Erste naheliegende Hypothesen

- auditd wurde unvollständig installiert.
- Paketdateien fehlen.
- Die Distribution nutzt eine andere Konfigurationsstruktur.
- auditd läuft ohne klassische Regeldateien.
- /etc/audit muss manuell angelegt werden.

## Tatsächliche Ursache

Die erste Prüfung erfolgte im falschen Berechtigungskontext. Die Prüfung mit normalem Benutzer meldete die Pfade als nicht vorhanden. Eine privilegierte Prüfung mit sudo zeigte jedoch, dass die Pfade vorhanden waren.

## Entscheidender Gegencheck

Normale Benutzerprüfung:

    test -f /etc/audit/auditd.conf
    test -d /etc/audit/rules.d
    test -f /etc/audit/rules.d/audit.rules

Privilegierte Prüfung:

    sudo test -f /etc/audit/auditd.conf
    sudo test -d /etc/audit/rules.d
    sudo test -f /etc/audit/rules.d/audit.rules
    sudo find /etc/audit -maxdepth 3 -printf '%y %p\n'

## Diagnosemuster

Wenn sicherheitsrelevante Pfade scheinbar fehlen, darf nicht sofort von fehlender Konfiguration ausgegangen werden. Zuerst muss geprüft werden, ob die Abfrage mit passenden Rechten durchgeführt wurde.

## Richtiger Vorgehensweg

1. Symptom festhalten.
2. Hypothesen bilden.
3. Paketstatus prüfen.
4. Paketintegrität prüfen.
5. Pfade mit normalem Benutzer prüfen.
6. Pfade mit sudo prüfen.
7. Ist-Zustand des laufenden Dienstes prüfen.
8. Erst danach Änderungen planen.

## Betriebliche Einordnung

Dieser Fall ist ein realistisches Junior-Admin-Diagnoseszenario. Die Ursache lag nicht dort, wo sie auf den ersten Blick vermutet wurde. Entscheidend war nicht ein neuer Befehl, sondern der Wechsel der Denkebene: Nicht nur prüfen, ob ein Pfad existiert, sondern auch prüfen, mit welchen Rechten diese Aussage zustande kam.

## Merksätze

- Bei Security-Pfaden zählt der Berechtigungskontext.
- Nicht jede Datei, die ein Benutzer nicht sieht, fehlt wirklich.
- Paketliste ist Soll-Hinweis.
- sudo find zeigt den privilegierten Dateisystem-Ist-Zustand.
- auditctl zeigt den aktuell geladenen Kernel-Regelzustand.
- Erst Prüfkontext klären, dann Ursache bewerten.
