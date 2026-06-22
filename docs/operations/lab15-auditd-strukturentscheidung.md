# Lab 15 – auditd Strukturentscheidung

## Ziel

Nach Installation und Paketintegritätsprüfung wurde die aktuelle auditd-Struktur bewertet. Ziel ist eine sichere Entscheidung, wo die Lab-Audit-Regeln abgelegt werden.

## Beobachteter Zustand

- /etc/audit/auditd.conf: vorhanden
- /etc/audit/rules.d: vorhanden
- /etc/audit/rules.d/audit.rules: vorhanden
- augenrules Pfad: /usr/sbin/augenrules
- auditctl Status Kurzform: enabled 1 failure 1 pid 22687 rate_limit 0 backlog_limit 8192
- Anzahl aktuell geladener Audit-Regelzeilen: 0

## Aktuelle /etc/audit-Struktur

- d /etc/audit
- d /etc/audit/plugins.d
- d /etc/audit/rules.d
- f /etc/audit/audisp-filter.conf
- f /etc/audit/auditd.conf
- f /etc/audit/audit.rules
- f /etc/audit/audit-stop.rules
- f /etc/audit/plugins.d/af_unix.conf
- f /etc/audit/plugins.d/filter.conf
- f /etc/audit/plugins.d/syslog.conf
- f /etc/audit/rules.d/audit.rules

## Entscheidung

- Strukturentscheidung: rules_d_verwenden

## Betriebliche Bewertung

Eigene Audit-Regeln werden als eigene Lab-Datei abgelegt und nicht in eine unklare bestehende Regeldatei hineingeschrieben. Dadurch bleibt nachvollziehbar, welche Regeln aus dem Lab stammen und wie sie bei Bedarf zurückgenommen werden können.

## Nächster Schritt

Eine eigene Lab-Regeldatei für ausgewählte sicherheitsrelevante Dateien wird vorbereitet und anschließend kontrolliert geladen.

## Merksätze

- Eigene Regeln gehören in eine eigene Datei.
- Regeldateien sind Soll-Zustand.
- auditctl zeigt den aktuell geladenen Ist-Zustand.
