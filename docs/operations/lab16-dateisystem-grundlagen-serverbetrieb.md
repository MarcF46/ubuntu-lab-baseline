# Lab16c – Dateisystem-Grundlagen für Serverbetrieb

## Zweck
Diese Notiz erklärt grundlegende Dateisysteme im Linux-Serverbetrieb und ordnet ein, warum Speicherplatz, Inodes, Logdateien, Monitoring und Architekturentscheidungen zusammen betrachtet werden müssen.

## Dateiformat vs. Dateisystem

Ein Dateiformat beschreibt den Inhalt oder Aufbau einer einzelnen Datei, zum Beispiel .txt, .log, .pdf oder .json.

Ein Dateisystem beschreibt, wie ein Betriebssystem Dateien auf einer Partition oder einem Datenträger organisiert, speichert, findet, schützt und verwaltet.

## Wichtige Grundbegriffe

| Begriff | Erklärung |
|---|---|
| Partition | Abgeteilter Bereich eines Datenträgers, der separat formatiert und eingebunden werden kann. |
| Mountpoint | Einhängepunkt im Linux-Verzeichnisbaum, zum Beispiel /, /var oder /home. |
| Inodes (Index Nodes, Dateisystem-Verwaltungseinträge) | Interne Karteikarten des Dateisystems. Sie speichern technische Informationen und Verweise zu Dateien. |
| Datenblöcke | Bereiche auf dem Datenträger, in denen der eigentliche Dateiinhalt liegt. |
| Metadaten | Verwaltungsinformationen zu Dateien, zum Beispiel Besitzer, Rechte, Zeitstempel und Größe. |
| Journaling | Technik, bei der Änderungen vorab protokolliert werden, um nach Abstürzen konsistenter wiederherstellen zu können. |
| Copy-on-Write | Schreibverfahren, bei dem bestehende Daten nicht direkt überschrieben, sondern neue Versionen an anderer Stelle geschrieben werden. |
| Snapshot | Zustandsaufnahme eines Dateisystems oder Volumes zu einem bestimmten Zeitpunkt. |

## Übersicht wichtiger Dateisysteme und Protokolle

| Dateisystem oder Protokoll | Kurz erklärt | Typischer Zweck | Wichtige Betriebsnotiz |
|---|---|---|---|
| ext4 (Fourth Extended Filesystem) | Stabiler Linux-Allrounder | Allgemeine Linux-Server, kleine bis mittlere Systeme, Standardfälle | Einfach, bewährt, gut dokumentiert. |
| XFS (X File System) | Skalierbares Server-Dateisystem | Große Dateisysteme, große Dateien, Enterprise-Linux-Umgebungen | Stark bei großen Datenmengen, aber nicht für jedes Schrumpf-/Resize-Szenario gleich bequem. |
| Btrfs (B-tree File System) | Modernes Copy-on-Write-Dateisystem mit Snapshot-Funktionen | Systeme mit Snapshot-, Rollback- oder Subvolume-Konzept | Mächtig, aber bewusst planen und überwachen. |
| ZFS (Zettabyte File System) | Dateisystem plus Volume-Management mit Checksummen und Snapshots | Storage-Server, NAS (Network Attached Storage, Netzwerkspeicher), Proxmox- oder Homelab-Storage | Sehr stark für Datenintegrität, braucht aber Wissen zu RAM, Pools und Betrieb. |
| tmpfs (Temporary File System) | Flüchtiges Dateisystem im RAM (Random Access Memory, Arbeitsspeicher) | Temporäre Laufzeitdaten, Caches, /tmp je nach System | Schnell, aber nach Neustart weg. Kann RAM-Druck erzeugen. |
| NFS (Network File System) | Netzwerk-Dateisystem für Unix/Linux | Linux-Dateifreigaben über Netzwerk | Netzwerk, Rechte und Verfügbarkeit werden Teil des Dateizugriffs. |
| SMB/CIFS (Server Message Block/Common Internet File System) | Netzwerkfreigabe-Protokoll aus der Windows-Welt | Windows-/Linux-Dateifreigaben im Unternehmensnetz | Wichtig für gemischte Windows-/Linux-Umgebungen. |

## Typische Auswahl nach Serverzweck

| Zweck | Häufig sinnvolle Wahl | Warum |
|---|---|---|
| Allgemeiner Ubuntu-Server | ext4 (Fourth Extended Filesystem) | Einfach, stabil, weit verbreitet. |
| Enterprise-Linux-Server mit großen Datenmengen | XFS (X File System) | Sehr gut für große Dateisysteme und große Dateien geeignet. |
| Logpartition /var/log | ext4 oder XFS | Wichtiger als die reine Wahl ist Monitoring auf Speicherplatz, Inodes und Logwachstum. |
| Datenbank-Server | oft XFS oder ext4, abhängig von Herstellerempfehlung | Datenbank-Herstellerdokumentation hat Vorrang. |
| Backup-/Storage-Server | ZFS oder spezialisiertes Storage-Dateisystem | Checksummen, Snapshots und Datenintegrität können hier besonders wertvoll sein. |
| Systeme mit Rollback-Konzept | Btrfs oder ZFS | Snapshots können kontrollierte Rückkehrpunkte ermöglichen. |
| Temporäre Daten | tmpfs | Sehr schnell, aber flüchtig und RAM-abhängig. |
| Linux-Dateifreigabe | NFS | Standardnah für Unix-/Linux-Umgebungen. |
| Windows-/Linux-Dateifreigabe | SMB/CIFS | Praktisch für gemischte Unternehmensumgebungen. |

## Warum das für Logs wichtig ist

Logs erzeugen Dateien. Jede Datei benötigt Speicherplatz und mindestens einen Inode. Zusätzlich belasten sehr viele kleine Dateien Backup, Suche, Monitoring und Security-Scanner.

Ein Logproblem kann verschiedene Ursachen haben: Speicherplatz voll, Inodes voll, einzelne Logdatei zu groß, zu viele rotierte Logs, Log-Sturm oder gelöschte Dateien, die noch von Prozessen offen gehalten werden.

## Lab-vs-Production-Einordnung

| Bereich | Lab | Production |
|---|---|---|
| Dateisystemwahl | Meist ext4 ausreichend | Herstellerempfehlung, Workload, Backup, Monitoring und Support beachten. |
| Logspeicherung | Lokales /var/log reicht | Retention, zentrale Logs, SIEM (Security Information and Event Management, zentrale Sicherheitslog- und Alarmplattform) und Datenschutz beachten. |
| Inodes | Lernprüfung mit df -i | Monitoring und Alarmierung besonders bei vielen kleinen Dateien. |
| Snapshots | Nützlich zum Lernen | Kein Ersatz für Backup. Restore-Tests und klare Rollback-Prozesse nötig. |
| Netzwerk-Dateisysteme | Testfreigaben möglich | Rechte, Ausfallsicherheit, Performance, Verschlüsselung und Zugriffskontrolle planen. |

## Betriebsregel
Es gibt nicht das eine beste Dateisystem. Die Auswahl hängt vom Zweck, Workload, Betriebssystem, Hersteller-Support, Backup-Konzept, Monitoring und Wiederherstellungsanforderungen ab.

## Diagnoseanker
Bei Speicher- und Logproblemen nicht nur auf die Dateigröße schauen. Immer Speicherplatz, Inodes, Anzahl Dateien, offene gelöschte Dateien, Logrotate, Mountpoints und Monitoring gemeinsam prüfen.

## Merksatz
Das Dateisystem ist nicht der Akteninhalt, sondern das Archivsystem. Es entscheidet, wie Akten abgelegt, gefunden, geschützt, verwaltet und wieder entfernt werden.
