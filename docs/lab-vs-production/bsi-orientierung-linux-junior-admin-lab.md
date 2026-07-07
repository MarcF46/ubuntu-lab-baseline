# BSI-orientierte Einordnung des Linux-Junior-Admin-Labs

## Ziel

Dieses Dokument ordnet das Ubuntu Lab Baseline Projekt fachlich ein.

Das Lab ist kein vollständiges BSI-IT-Grundschutz-Projekt und bildet keine zertifizierungsfähige Umgebung ab. Ziel ist eine praxisnahe Lern- und Trainingsumgebung, die sich an typischen Prinzipien des BSI-IT-Grundschutzes orientiert.

## Abgrenzung

BSI-orientiert bedeutet in diesem Projekt nicht:

- vollständige BSI-Konformität
- formale IT-Grundschutz-Modellierung
- Zertifizierungsfähigkeit
- produktive Betriebsfreigabe
- vollständiges Informationssicherheitsmanagementsystem

Gemeint ist:

- strukturierte Administration
- dokumentierte Prüfungen
- sichere Konfigurationsentscheidungen
- Logging und Logbewertung
- Härtung administrativer Zugänge
- Backup- und Restore-Prüfungen
- Detektion auffälliger Zustände
- nachvollziehbare Betriebsentscheidungen
- wiederholbare Runbooks und Incident Cards

## Bezug zur BSI-IT-Grundschutz-Denkweise

Das BSI-IT-Grundschutz-Kompendium arbeitet mit Bausteinen für unterschiedliche Bereiche der Informationssicherheit und des IT-Betriebs.

Für dieses Lab sind insbesondere Gedanken aus folgenden Bereichen relevant:

- OPS: Betrieb
- DER: Detektion und Reaktion
- SYS: IT-Systeme
- NET: Netze und Kommunikation
- ORP: Organisation und Personal

Das Lab greift diese Denkweise auf, ohne eine vollständige Grundschutz-Umsetzung zu ersetzen.

## Einordnung der Lab-Bereiche

| Bereich im Lab | BSI-orientierter Gedanke |
|---|---|
| systemd, Dienste, Autostart, Healthchecks | Geordneter Betrieb und nachvollziehbare Administration. Dienste werden nicht nur gestartet, sondern in Status, Autostart und Betriebswirkung bewertet. |
| Linux-Server-Baseline | Orientierung an grundlegender Administration von Linux-/Unix-Systemen. Ziel ist eine belastbare technische Ausgangsbasis für Betrieb und Fehlersuche. |
| Update- und Change-Planung | Updates werden nicht als Einzelbefehl betrachtet, sondern als kontrollierter Change mit Vorprüfung, Risikobetrachtung, Nachprüfung und Rollback-Gedanke. |
| Logging, journalctl, Logrotate und Logbewertung | Protokolle werden nicht nur gesammelt, sondern im Kontext bewertet. Entscheidend ist, ob eine Logmeldung eine technische Auswirkung oder einen Handlungsbedarf erzeugt. |
| Fail2ban, auditd, Monitoring und Quality Gates | Auffällige Zustände und sicherheitsrelevante Ereignisse sollen erkannt, bewertet und in klare Betriebsentscheidungen überführt werden. |
| UFW, SSH-Härtung und administrative Zugänge | Administrative Zugänge werden bewusst betrachtet. Dazu gehören Firewall-Regeln, SSH-Konfiguration, Login-Verfahren und Härtungskandidaten. |
| Backup- und Restore-Grundlagen | Wiederherstellbarkeit wird praktisch geprüft. Ein Backup hat erst dann betrieblichen Wert, wenn ein Restore nachvollziehbar getestet wurde. |
| Runbooks, Incident Cards und Statusberichte | Wissen wird wiederholbar dokumentiert. Störungen, Prüfwege und Bewertungen werden so festgehalten, dass sie später nachvollzogen oder wiederverwendet werden können. |
| OSI-Modell vs. Admin-Schichtenmodell | Das OSI-Modell erklärt Netzwerkkommunikation. Das betriebliche Admin-Schichtenmodell ergänzt diese Sicht durch eine praktische Reihenfolge für Fehlersuche im Betrieb. |

## Praktischer Schwerpunkt

Der wichtigste Schwerpunkt des Labs liegt nicht auf einzelnen Befehlen, sondern auf der Frage:

Wie wird aus einer technischen Beobachtung ein belastbarer Befund?

Dafür wurde im Projekt eine wiederholbare Diagnose-Reihenfolge verwendet:

1. Systemstatus
2. Dienststatus
3. Port und Bindung
4. Firewall
5. Client- und Netzwerkpfad
6. Logs
7. Konfiguration

Diese Reihenfolge hilft, nicht zu früh in Logs oder Konfigurationsdateien zu springen, sondern zunächst die betroffene Schicht sauber einzugrenzen.

## Bedeutung für weitere Lernprojekte

Das Lab bildet eine Grundlage für weiterführende Themen:

- Windows Server
- Active Directory
- Microsoft 365
- Entra ID
- PowerShell
- Kubernetes
- Ansible
- Terraform
- Deployment und Automatisierung
- serviceorientiertes Monitoring
- Cloud- und Hybrid-Infrastruktur
- Architekturplanung

Die BSI-orientierte Denkweise soll dabei erhalten bleiben:

- nachvollziehbar arbeiten
- Entscheidungen dokumentieren
- Risiken bewerten
- Wiederherstellbarkeit prüfen
- Betriebszustände messen
- Störungen strukturiert eingrenzen
- Lab und Produktion bewusst unterscheiden

## Kurzfazit

Dieses Lab ist ein Lernprojekt.

Es ist nicht BSI-konform im formalen Sinn.

Es ist aber bewusst an der Denkweise des BSI-IT-Grundschutzes orientiert: strukturiert, nachvollziehbar, dokumentiert, sicherheitsbewusst und auf wiederholbare Betriebsabläufe ausgerichtet.