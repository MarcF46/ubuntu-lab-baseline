# Lab 06a – Vorher-Zustand vor kontrolliertem Update-Change

## Ziel

Vor einem echten Update-Lauf wurde der Ausgangszustand des Ubuntu-Lab-Systems dokumentiert. Dieser Zustand dient als Referenz für die spätere Nachprüfung.

## Typisches Betriebsszenario

Vor einer kontrollierten Paketaktualisierung wird der Systemzustand dokumentiert, damit nach der Änderung geprüft werden kann, ob Dienste, Paketstand, Reboot-Bedarf und Systemzustand weiterhin erwartungsgemäß sind.

## Technischer Nachweis

Der vollständige Rohoutput wurde bewusst privat abgelegt:

- docs/private/evidence/lab06a-update-change/lab06a-vorher-zustand-raw.txt

## Beobachteter Vorher-Zustand

- Git-Status: Arbeitsverzeichnis sauber
- Verfügbare Updates: 20
- Simulierter Upgrade-Lauf: 20 aktualisiert, 0 neu installiert, 0 zu entfernen und 0 nicht aktualisiert.
- Reboot-Zustand: kein aktueller Reboot-Marker vorhanden
- SSH-Service-Zustand: active
- systemd failed units: 0
- Root-Dateisystem: 10% belegt, 130G frei

## Betriebliche Bewertung

Der Vorher-Zustand wurde vor einer echten Änderung dokumentiert. Dadurch entsteht ein sauberer Vergleichspunkt für die Nachprüfung nach einem Update.

Wichtig ist nicht nur, ob das Update technisch durchläuft, sondern ob danach Dienste erreichbar bleiben, keine unerwarteten systemd-Fehler auftreten und ein möglicher Reboot-Bedarf erkannt wird.

## Nächster professioneller Schritt

Als nächster Schritt kann der kontrollierte Update-Lauf vorbereitet werden. Vor der Installation bleibt zu entscheiden, ob die Lab-Absicherung ausreichend ist oder ob zusätzlich ein echter Snapshot beziehungsweise ein Backup erforderlich wäre.

## Merksätze

- Vorher-Zustand ist der Referenzpunkt.
- Ohne Vorher kein sauberer Nachher-Vergleich.
- Update ist Änderung, nicht nur Installation.
- Erst absichern, dann ändern, dann beweisen.
