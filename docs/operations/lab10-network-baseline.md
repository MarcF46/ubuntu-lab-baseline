# Lab 10 – Netzwerk-Baseline

## Ziel

Im Lab wurde eine erste Netzwerk-Baseline des Ubuntu-Systems erstellt. Geprüft wurden Netzwerkschnittstellen, IP-Adressen, Default Route, DNS-Auflösung, Erreichbarkeit per IP, Erreichbarkeit per Domain und lokal offene Ports.

## Typisches Betriebsszenario

Ein Dienst läuft lokal, ist aber nicht erreichbar. Vor tieferer Fehlersuche wird geprüft, ob das System eine gültige IP-Konfiguration, eine Default Route, funktionierende DNS-Auflösung und erwartbare lokale Portzustände hat.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab10-network/lab10-network-baseline-raw.txt

## Beobachteter Zustand

- Default-Route vorhanden: ja
- Primäres Interface laut Default Route: eno1
- Globale IPv4-Konfigurationen: 1
- Globale IPv6-Konfigurationen: 1
- DNS-Auflösung ubuntu.com erfolgreich: ja
- DNS-Auflösung github.com erfolgreich: ja
- Ping auf 1.1.1.1 erfolgreich: ja
- Ping auf ubuntu.com erfolgreich: ja
- Lokal lauschende TCP-Ports: 6
- Lokal lauschende UDP-Ports: 8

## Betriebliche Bewertung

Die Netzwerk-Baseline dient als Ausgangspunkt für spätere Netzwerk- und Service-Diagnosen. Besonders wichtig ist die Trennung zwischen lokaler Netzwerkkonfiguration, Routing, DNS-Auflösung, externer Erreichbarkeit und lokal offenen Ports.

Wenn eine IP erreichbar ist, aber eine Domain nicht, liegt der Verdacht auf DNS. Wenn weder IP noch Domain erreichbar sind, sind Routing, Gateway, lokale Verbindung oder Firewall wahrscheinlicher. Wenn das Netzwerk funktioniert, aber ein Dienst nicht erreichbar ist, müssen Portbindung, Firewall und Dienstkonfiguration geprüft werden.

## Nächster professioneller Schritt

Als nächster Schritt werden ein Runbook und eine Checkliste für Netzwerkdiagnose erstellt.

## Merksätze

- IP zeigt, wer das System im Netzwerk ist.
- Route zeigt, wohin Pakete gehen.
- DNS übersetzt Namen in Adressen.
- Ports zeigen, welche Türen lokal offen sind.
- Erst IP, dann Route, dann DNS, dann Port.
