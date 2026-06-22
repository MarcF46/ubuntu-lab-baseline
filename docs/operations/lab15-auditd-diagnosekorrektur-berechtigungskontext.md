# Lab 15 – Diagnosekorrektur: auditd Berechtigungskontext

## Ausgangslage

In der auditd-Diagnose wurde zunächst gemeldet, dass /etc/audit/auditd.conf, /etc/audit/rules.d und /etc/audit/rules.d/audit.rules nicht vorhanden seien. Eine spätere Prüfung mit sudo find zeigte jedoch, dass diese Pfade vorhanden sind.

## Ursache / Einordnung

Die Abweichung entstand durch den Berechtigungskontext der Prüfung. Sicherheitsrelevante Pfade unter /etc/audit müssen mit passenden Rechten geprüft werden. Eine Prüfung mit normalem Benutzer kann bei geschützten Verzeichnissen zu falschen Rückschlüssen führen.

## Vergleich

- Benutzerprüfung /etc/audit/auditd.conf: nicht_vorhanden
- Benutzerprüfung /etc/audit/rules.d: nicht_vorhanden
- Benutzerprüfung /etc/audit/rules.d/audit.rules: nicht_vorhanden
- Root-Prüfung /etc/audit/auditd.conf: vorhanden
- Root-Prüfung /etc/audit/rules.d: vorhanden
- Root-Prüfung /etc/audit/rules.d/audit.rules: vorhanden

## Korrigierte Bewertung

- auditd Dienststatus: active
- auditd Autostartstatus: enabled
- augenrules Pfad: /usr/sbin/augenrules
- Anzahl aktuell geladener Audit-Regelzeilen: 0
- Korrigierte Strukturentscheidung: rules_d_verwenden

## Betriebliche Bewertung

Im realen Betrieb ist dieser Fall relevant, weil falsche Prüfkontexte zu falschen Entscheidungen führen können. Vor Änderungen an Security-Konfigurationen muss klar sein, ob ein Pfad wirklich fehlt oder nur aus Sicht eines nicht privilegierten Benutzers nicht sichtbar ist.

## Nächster Schritt

Die vorhandene auditd-Struktur kann genutzt werden. Eigene Lab-Regeln sollen als separate Datei unter /etc/audit/rules.d abgelegt werden, damit Herkunft, Wirkung und Rollback nachvollziehbar bleiben.

## Merksätze

- Paketliste ist Soll-Hinweis.
- sudo find zeigt den privilegierten Dateisystem-Ist-Zustand.
- auditctl zeigt den aktuell geladenen Kernel-Regelzustand.
- Bei Security-Pfaden zählt der Berechtigungskontext.
