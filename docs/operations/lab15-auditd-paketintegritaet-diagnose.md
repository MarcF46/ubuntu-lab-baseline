# Lab 15 – auditd Paketintegrität Diagnose

## Ziel

Nach der auditd-Installation wurde ein Widerspruch festgestellt: auditd läuft und die Werkzeuge sind vorhanden, aber zentrale Konfigurationspfade unter /etc/audit wurden nicht wie erwartet gefunden. Deshalb wurde die Paketintegrität geprüft.

## Beobachteter Zustand

- dpkg -V auditd Exit-Code: 0
- ls /etc/audit Exit-Code: 0
- find /etc/audit Exit-Code: 0
- systemctl cat auditd Exit-Code: 0
- systemctl cat audit-rules Exit-Code: 0
- Paketintegritätsbewertung: unauffaellig

## Betriebliche Bewertung

Wenn Paketverwaltung und Dateisystem widersprüchliche Hinweise liefern, wird nicht direkt eine eigene Sicherheitskonfiguration geschrieben. Zuerst muss geprüft werden, ob Paketdateien fehlen, ob ein Paket unvollständig eingerichtet wurde oder ob die Distribution eine abweichende Struktur nutzt.

## Nächster Schritt

Auf Basis der Paketintegritätsprüfung wird entschieden, ob auditd repariert, neu installiert oder die erwartete Regelstruktur kontrolliert angelegt wird.

## Merksätze

- Paket installiert heißt nicht automatisch Konfiguration plausibel.
- Wenn Pfade fehlen, zuerst Paketintegrität prüfen.
- Keine Audit-Regeln auf unklarem Fundament.
