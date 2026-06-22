# Lab 11 – Firewall- und Port-Baseline

## Ziel

Im Lab wurde eine erste Firewall- und Port-Baseline des Ubuntu-Systems erstellt. Geprüft wurden UFW, nftables, lokal lauschende Ports, SSH-Zustand und fehlgeschlagene systemd Units.

## Typisches Betriebsszenario

Ein Dienst läuft auf einem Server, ist aber nicht oder unerwartet erreichbar. Vor Regeländerungen wird geprüft, welche Dienste lokal lauschen und ob eine Firewall-Konfiguration aktiv ist.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab11-firewall/lab11-firewall-baseline-raw.txt

## Beobachteter Zustand

- UFW vorhanden: ja
- UFW aktiv: nein
- UFW Statuszeile: Status: Inaktiv
- SSH Dienststatus: active
- SSH Autostartstatus: enabled
- SSH Port 22 lokal sichtbar: ja
- Lokal lauschende TCP-Ports: 6
- Lokal gebundene UDP-Ports: 8
- Fehlgeschlagene systemd Units: 0

## Betriebliche Bewertung

Die Firewall- und Port-Baseline verbindet Netzwerkdiagnose mit Zugriffskontrolle. Ein lauschender Port bedeutet, dass ein Dienst lokal Verbindungen annehmen kann. Ob der Dienst aus anderen Netzen erreichbar ist, hängt zusätzlich von Firewall, Routing, Bind-Adresse und Netzwerkpfad ab.

SSH auf Port 22 ist für Remote-Administration wichtig und muss besonders vorsichtig behandelt werden. Firewall-Änderungen dürfen SSH-Zugriff nicht unbeabsichtigt unterbrechen.

## Nächster professioneller Schritt

Als nächster Schritt werden ein Runbook und eine Checkliste für Firewall- und Portdiagnose erstellt. Regeländerungen erfolgen erst nach klarer Bewertung und Rückfallplan.

## Merksätze

- Ports zeigen, welche Türen lokal offen sind.
- Firewall-Regeln entscheiden, wer durch die Tür darf.
- SSH ist die Admin-Haustür und darf nicht versehentlich ausgesperrt werden.
- Erst Bestand prüfen, dann Regel ändern.
