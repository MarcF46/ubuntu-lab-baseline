# Lab 06a – Backup- und Rollback-Referenz vor Update

## Ziel

Vor einem echten Update-Lauf wurde eine technische Referenz des Paket- und apt-Zustands erstellt. Diese Referenz dient zur Nachvollziehbarkeit und unterstützt eine spätere Fehleranalyse oder Rollback-Bewertung.

## Typisches Betriebsszenario

Vor einer kontrollierten Paketaktualisierung wird dokumentiert, welche Paketversionen installiert sind, welche Pakete manuell installiert wurden und wie die apt-Quellen sowie apt-Historie vor der Änderung aussahen.

## Technischer Nachweis

Die vollständigen Rohdaten wurden bewusst privat abgelegt unter:

- docs/private/evidence/lab06a-update-change/pre-update-reference-20260621-174419

Gesichert wurden:

- installierte Paketversionen vor dem Update
- manuell markierte Pakete vor dem Update
- apt-Historie vor dem Update
- apt-Terminalprotokoll vor dem Update, sofern vorhanden
- apt-Konfiguration und Paketquellen als Archiv
- kurze private Zusammenfassung des Referenzstands

## Betriebliche Bewertung

Diese Referenz ersetzt kein vollständiges Backup und keinen VM-Snapshot. Sie verbessert aber die Nachvollziehbarkeit des Changes erheblich, weil Paketstand und apt-Konfiguration vor der Änderung dokumentiert sind.

In Produktion wäre zusätzlich ein echter Snapshot oder ein geprüftes Backup mit Restore-Möglichkeit erforderlich.

## Nächster professioneller Schritt

Nach dieser Referenzsicherung kann der echte Update-Lauf kontrolliert durchgeführt werden. Danach muss der Nachher-Zustand mit dem Vorher-Zustand verglichen werden.

## Merksätze

- Paketliste ist kein Backup, aber ein wichtiger Fingerabdruck.
- Snapshot ist der schnelle Zwischenstand, Backup ist der Rettungsanker.
- Rollback beginnt vor der Änderung.
- Erst absichern, dann ändern, dann beweisen.
