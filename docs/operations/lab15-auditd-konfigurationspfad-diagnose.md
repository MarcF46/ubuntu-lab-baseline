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

/etc/audit/auditd.conf /etc/audit/rules.d /etc/audit/rules.d/audit.rules /usr/lib/systemd/system/audit-rules.service /usr/sbin/augenrules /usr/share/doc/auditd/examples/audit-rules /usr/share/doc/auditd/examples/audit-rules/10-base-config.rules /usr/share/doc/auditd/examples/audit-rules/10-no-audit.rules /usr/share/doc/auditd/examples/audit-rules/11-loginuid.rules /usr/share/doc/auditd/examples/audit-rules/12-cont-fail.rules /usr/share/doc/auditd/examples/audit-rules/12-ignore-error.rules /usr/share/doc/auditd/examples/audit-rules/20-dont-audit.rules /usr/share/doc/auditd/examples/audit-rules/21-no32bit.rules /usr/share/doc/auditd/examples/audit-rules/22-ignore-chrony.rules /usr/share/doc/auditd/examples/audit-rules/23-ignore-filesystems.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-1-create-failed.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-1-create-success.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-2-modify-failed.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-2-modify-success.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-3-access-failed.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-3-access-success.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-4-delete-failed.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-4-delete-success.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-5-perm-change-failed.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-5-perm-change-success.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-6-owner-change-failed.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42-6-owner-change-success.rules /usr/share/doc/auditd/examples/audit-rules/30-ospp-v42.rules /usr/share/doc/auditd/examples/audit-rules/30-pci-dss-v31.rules /usr/share/doc/auditd/examples/audit-rules/30-stig.rules /usr/share/doc/auditd/examples/audit-rules/31-privileged.rules /usr/share/doc/auditd/examples/audit-rules/32-power-abuse.rules /usr/share/doc/auditd/examples/audit-rules/40-local.rules /usr/share/doc/auditd/examples/audit-rules/41-containers.rules /usr/share/doc/auditd/examples/audit-rules/42-injection.rules /usr/share/doc/auditd/examples/audit-rules/43-module-load.rules /usr/share/doc/auditd/examples/audit-rules/44-installers.rules /usr/share/doc/auditd/examples/audit-rules/70-einval.rules /usr/share/doc/auditd/examples/audit-rules/71-networking.rules /usr/share/doc/auditd/examples/audit-rules/99-finalize.rules /usr/share/doc/auditd/examples/audit-rules/README-rules /usr/share/man/man5/auditd.conf.5.gz /usr/share/man/man7/audit.rules.7.gz /usr/share/man/man8/augenrules.8.gz 

## Betriebliche Bewertung

Eigene Audit-Regeln werden erst erstellt, wenn klar ist, welche Konfigurationsstruktur auf diesem System vorhanden ist oder bewusst angelegt werden muss. Das verhindert blinde Änderungen an sicherheitsrelevanter Konfiguration.

## Nächster Schritt

Auf Basis dieser Diagnose wird entschieden, ob /etc/audit und /etc/audit/rules.d kontrolliert angelegt werden oder ob eine bereits vorhandene Paketstruktur genutzt werden muss.

## Merksätze

- Nicht blind Regeln schreiben, erst den Konfigurationspfad prüfen.
- auditctl zeigt den laufenden Kernel-Regelzustand.
- Regeldateien sind der geplante Soll-Zustand.
