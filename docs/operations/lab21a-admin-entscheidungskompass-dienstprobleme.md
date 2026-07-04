# Lab21a – Admin-Entscheidungskompass bei Dienstproblemen

## Situation A: Lage unklar

Wenn unklar ist, welcher Dienst betroffen ist:

- Server macht Probleme
- nach Reboot ist Zustand unklar
- mehrere Dienste könnten betroffen sein

Erster Befehl:

systemctl --failed

Bewertung:

0 loaded units listed = keine systemd-Unit ist aktuell fehlgeschlagen.

## Situation B: Dienst bekannt

Wenn der Dienst bekannt ist:

systemctl is-active DIENST
systemctl is-enabled DIENST

Bewertung:

- active = Dienst läuft
- inactive = Dienst läuft aktuell nicht
- failed = Dienst ist fehlgeschlagen
- enabled = Dienst startet beim Boot
- disabled = Dienst startet nicht automatisch

## Situation C: Dienst läuft, Zugriff scheitert

Dann schichtweise prüfen:

ss -tulpn
sudo ufw status numbered
curl -I --max-time 3 http://127.0.0.1:PORT
curl -I --max-time 3 http://SERVER-IP:PORT

## Situation D: Ursache gesucht

Logs gezielt filtern:

journalctl -u DIENST -b -n 30 --no-pager
journalctl -u DIENST -b -p warning -n 30 --no-pager
journalctl -b -p err -n 30 --no-pager

## Wichtigste Arbeitslogik

1. Unklarer Zustand? systemctl --failed
2. Konkreter Dienst bekannt? systemctl is-active DIENST
3. Dienst läuft, Zugriff klappt nicht? ss, curl, ufw
4. Zustand auffällig? journalctl -u DIENST -b -n 30
5. Logausgabe zu groß? mit -u, -b, -p, -n filtern

## Merksatz

Dienststatus vor Detailanalyse. Port prüfen vor Firewall-Vermutung. Logs filtern, bevor sie bewertet werden.
