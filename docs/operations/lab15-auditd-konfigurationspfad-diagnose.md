# Lab 15 – auditd Konfigurationspfad Diagnose

## Ziel

Nach der auditd-Installation wurde festgestellt, dass der Dienst aktiv ist und auditctl funktioniert, aber /etc/audit/auditd.conf und /etc/audit/rules.d im ersten Check nicht vorhanden waren. Deshalb wurde vor dem Setzen eigener Audit-Regeln zuerst die Paket- und Konfigurationsstruktur geprüft.

## Beobachteter Zustand

- auditd Dienststatus: active
- auditd Autostartstatus: enabled
- auditctl Pfad: /usr/sbin/auditctl
- ausearch Pfad: /usr/sbin/ausearch
- aureport Pfad: /usr/sbin/aureport
- augenrules Pfad: /usr/sbin/augenrules
- /etc/audit: vorhanden
- /etc/audit/auditd.conf: nicht_vorhanden
- /etc/audit/rules.d: nicht_vorhanden
- /etc/audit/audit.rules: nicht_vorhanden
- auditctl -s Exit-Code: 0
- auditctl -l Exit-Code: 0

## Paket-Hinweis

Relevante auditd-Paketpfade mit Bezug zu auditd.conf, rules.d, audit.rules oder augenrules:

Die ausführliche Paketpfadliste wurde in den privaten Rohdaten abgelegt. Relevante Kurzbefunde:

- /etc/audit/auditd.conf wird vom Paket auditd erwartet.
- /etc/audit/rules.d wird vom Paket auditd erwartet.
- /etc/audit/rules.d/audit.rules wird vom Paket auditd erwartet.
- /usr/sbin/augenrules ist vorhanden.

## Betriebliche Bewertung

Eigene Audit-Regeln werden erst erstellt, wenn klar ist, welche Konfigurationsstruktur auf diesem System vorhanden ist oder bewusst angelegt werden muss. Das verhindert blinde Änderungen an sicherheitsrelevanter Konfiguration.

## Nächster Schritt

Auf Basis dieser Diagnose wird entschieden, ob /etc/audit und /etc/audit/rules.d kontrolliert angelegt werden oder ob eine bereits vorhandene Paketstruktur genutzt werden muss.

## Merksätze

- Nicht blind Regeln schreiben, erst den Konfigurationspfad prüfen.
- auditctl zeigt den laufenden Kernel-Regelzustand.
- Regeldateien sind der geplante Soll-Zustand.
