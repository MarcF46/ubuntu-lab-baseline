# Lab24b – OSI-Modell vs. betriebliches Admin-Schichtenmodell

## Ziel

Diese Notiz grenzt das klassische OSI-Modell vom praktischen Admin-Schichtenmodell für die Fehlersuche ab.

## OSI-Modell

Das OSI-Modell beschreibt, wie Netzwerkkommunikation technisch über verschiedene Ebenen abläuft.

Typische Ebenen im Diagnosekontext:

- Layer 3: IP-Erreichbarkeit
- Layer 4: TCP/UDP-Port
- Layer 7: Anwendung / Protokoll / Dienst

Beispiel CUPS:

- IP-Adresse erreichbar oder nicht
- TCP-Port 631 erreichbar oder nicht
- CUPS-Webinterface / IPP antwortet oder nicht

## Betriebliches Admin-Schichtenmodell

Das betriebliche Admin-Schichtenmodell beschreibt die praktische Reihenfolge der Fehlersuche.

Es beantwortet nicht zuerst die Frage:

Welche OSI-Schicht ist betroffen?

Sondern:

Welche betriebliche Prüfschicht muss als Nächstes bewiesen werden?

## Sichere Reihenfolge im Admin-Alltag

1. Systemstatus
2. Dienststatus
3. Port und Bindung
4. Firewall
5. Client- und Netzwerkpfad
6. Logs
7. Konfiguration

## Beispiel CUPS

CUPS ist aktiv.

CUPS lauscht auf:

- 127.0.0.1:631
- [::1]:631

Bewertung:

Der Dienst läuft, ist aber nur lokal gebunden.

Vor einer Konfigurationsänderung wird zuerst geprüft:

1. Läuft der Dienst?
2. Lauscht der Port?
3. Auf welcher Adresse lauscht der Dienst?
4. Blockiert die Firewall?
5. Funktioniert der Zugriff lokal?
6. Funktioniert der Zugriff über LAN?
7. Welche Konfiguration verursacht das Verhalten?

## Beispiel SSH

SSH lauscht auf:

- 0.0.0.0:22
- [::]:22

Bewertung:

SSH ist grundsätzlich netzwerkfähig gebunden.

Wenn Remote-Zugriff trotzdem nicht funktioniert, wird zuerst geprüft:

1. Firewall-Regeln
2. Client-IP / Ziel-IP
3. Netzwerkpfad
4. Routing / VPN
5. SSH-Client-Fehler
6. Dienstlogs
7. SSH-Konfiguration

## Wichtige Abgrenzung

Das OSI-Modell bleibt wichtig, ersetzt aber nicht die betriebliche Diagnose-Reihenfolge.

OSI hilft beim Verständnis der Netzwerkebenen.

Das Admin-Schichtenmodell hilft beim sicheren Prüfen im Betrieb.

## Merksätze

Logs und Konfiguration sind nicht der erste Schritt.

Erst beweisen, auf welcher Schicht das Problem liegt.

Dienst aktiv bedeutet nicht automatisch erreichbar.

Port vorhanden bedeutet nicht automatisch LAN-erreichbar.

Systemstatus vor Detailanalyse.

Dienststatus vor Logs.

Port und Bindung vor Firewall-Vermutung.

Firewall vor tiefer Konfigurationsanalyse.
