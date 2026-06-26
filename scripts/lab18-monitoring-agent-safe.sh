#!/usr/bin/env bash
# Startet das Skript mit Bash.

set -u
# Beendet das Skript bei Nutzung nicht gesetzter Variablen.

set -o pipefail
# Sorgt dafür, dass fehlerhafte Pipeline-Teile erkennbar bleiben.

overall_status=0
# Speichert die Gesamtbewertung: 0=OK, 1=WARNING, 2=CRITICAL.

print_section() {
  # Definiert eine Funktion für Abschnittsüberschriften.
  printf '\n== %s ==\n' "$1"
  # Gibt eine formatierte Abschnittsüberschrift aus.
}

mark_ok() {
  # Definiert eine Funktion für OK-Meldungen.
  printf 'OK: %s\n' "$1"
  # Gibt eine OK-Meldung aus.
}

mark_warning() {
  # Definiert eine Funktion für WARNING-Meldungen.
  printf 'WARNING: %s\n' "$1"
  # Gibt eine WARNING-Meldung aus.
  if [ "$overall_status" -lt 1 ]; then
    # Prüft, ob bisher noch kein WARNING oder CRITICAL gesetzt wurde.
    overall_status=1
    # Setzt die Gesamtbewertung auf WARNING.
  fi
  # Beendet die Bedingung.
}

mark_critical() {
  # Definiert eine Funktion für CRITICAL-Meldungen.
  printf 'CRITICAL: %s\n' "$1"
  # Gibt eine CRITICAL-Meldung aus.
  overall_status=2
  # Setzt die Gesamtbewertung auf CRITICAL.
}

check_service() {
  # Definiert eine Funktion für Dienststatusprüfungen.
  unit="$1"
  # Speichert den systemd-Unit-Namen.
  description="$2"
  # Speichert die fachliche Beschreibung.
  severity="$3"
  # Speichert die Kritikalität.
  if systemctl is-active --quiet "$unit"; then
    # Prüft, ob der Dienst aktiv ist.
    mark_ok "$unit aktiv – $description"
    # Meldet den Dienst als OK.
  else
    # Behandelt den Fall, dass der Dienst nicht aktiv ist.
    if [ "$severity" = "critical" ]; then
      # Prüft, ob der Dienst kritisch ist.
      mark_critical "$unit nicht aktiv – $description"
      # Meldet einen kritischen Dienstfehler.
    else
      # Behandelt nicht-kritische Dienste.
      mark_warning "$unit nicht aktiv – $description"
      # Meldet eine Warnung.
    fi
    # Beendet die Kritikalitätsprüfung.
  fi
  # Beendet die Dienststatusprüfung.
}

check_percent_threshold() {
  # Definiert eine Funktion für Prozent-Schwellenwerte.
  name="$1"
  # Speichert den Namen des Messwerts.
  value="$2"
  # Speichert den gemessenen Prozentwert.
  warn="$3"
  # Speichert die WARNING-Schwelle.
  crit="$4"
  # Speichert die CRITICAL-Schwelle.
  if [ "$value" -ge "$crit" ]; then
    # Prüft, ob der Wert kritisch hoch ist.
    mark_critical "$name bei ${value}%"
    # Meldet einen kritischen Schwellenwert.
  elif [ "$value" -ge "$warn" ]; then
    # Prüft, ob der Wert im Warnbereich liegt.
    mark_warning "$name bei ${value}%"
    # Meldet einen Warnschwellenwert.
  else
    # Behandelt unkritische Werte.
    mark_ok "$name bei ${value}%"
    # Meldet den Wert als OK.
  fi
  # Beendet die Schwellenwertprüfung.
}

print_section "Lab18 Monitoring-Agent ohne erhöhte Rechte"
# Gibt die Hauptüberschrift des Agent-Checks aus.

printf 'Ausgeführt am: %s\n' "$(date -Iseconds)"
# Gibt den Ausführungszeitpunkt im ISO-Format aus.

printf 'Benutzer: %s\n' "$(id -un)"
# Gibt den ausführenden Benutzernamen aus.

print_section "Kritische und wichtige Services"
# Startet den Abschnitt für Dienstprüfungen.

check_service "ssh.service" "Remote-Administration" "critical"
# Prüft den SSH-Dienst als kritischen Dienst.

check_service "auditd.service" "Auditierbarkeit sicherheitsrelevanter Ereignisse" "critical"
# Prüft auditd als kritischen Dienst.

check_service "fail2ban.service" "Schutz gegen wiederholte fehlgeschlagene Logins" "warning"
# Prüft Fail2Ban als wichtigen, aber nicht kritischen Dienst.

check_service "rsyslog.service" "Systemlogging" "warning"
# Prüft rsyslog als wichtigen Logging-Dienst.

check_service "systemd-resolved.service" "lokale Namensauflösung" "warning"
# Prüft systemd-resolved als wichtigen DNS-Baustein.

print_section "Wichtige Timer"
# Startet den Abschnitt für Timer-Prüfungen.

check_service "logrotate.timer" "Logrotation gegen unkontrolliertes Logwachstum" "warning"
# Prüft den logrotate-Timer.

print_section "Port-Checks"
# Startet den Abschnitt für Portprüfungen.

if ss -tln | awk 'NR > 1 {print $4}' | grep -Eq '(:|\]):22$'; then
  # Prüft, ob TCP-Port 22 lokal lauscht.
  mark_ok "TCP-Port 22 lauscht – SSH-Zugriff"
  # Meldet den SSH-Port als OK.
else
  # Behandelt den Fall, dass TCP-Port 22 nicht lauscht.
  mark_critical "TCP-Port 22 lauscht nicht – SSH-Zugriff gefährdet"
  # Meldet den SSH-Port als kritisch.
fi
# Beendet die Portprüfung.

print_section "DNS-Funktionscheck"
# Startet den Abschnitt für DNS-Prüfung.

if getent hosts ubuntu.com >/dev/null 2>&1; then
  # Prüft, ob der Name ubuntu.com aufgelöst werden kann.
  mark_ok "DNS-Auflösung funktioniert für ubuntu.com"
  # Meldet DNS als OK.
else
  # Behandelt fehlgeschlagene DNS-Auflösung.
  mark_warning "DNS-Auflösung für ubuntu.com fehlgeschlagen"
  # Meldet DNS als Warnung.
fi
# Beendet die DNS-Prüfung.

print_section "Dateisystem-Basischecks"
# Startet den Abschnitt für Dateisystem-Basisprüfungen.

root_usage="$(df -P / | awk 'NR == 2 {gsub(/%/, "", $5); print $5}')"
# Liest die prozentuale Speicherplatznutzung der Root-Partition aus.

inode_usage="$(df -Pi / | awk 'NR == 2 {gsub(/%/, "", $5); print $5}')"
# Liest die prozentuale Inode-Nutzung der Root-Partition aus.

check_percent_threshold "Root-Dateisystem-Belegung" "$root_usage" 80 90
# Bewertet die Speicherplatznutzung mit WARNING ab 80% und CRITICAL ab 90%.

check_percent_threshold "Root-Inode-Belegung" "$inode_usage" 80 90
# Bewertet die Inode-Nutzung mit WARNING ab 80% und CRITICAL ab 90%.

print_section "Gesamtbewertung"
# Startet den Abschnitt für die Gesamtbewertung.

if [ "$overall_status" -eq 0 ]; then
  # Prüft, ob keine Auffälligkeit erkannt wurde.
  printf 'Status: OK\n'
  # Gibt OK als Gesamtstatus aus.
  printf 'Bedeutung: Keine akute Auffälligkeit erkannt.\n'
  # Beschreibt die OK-Bedeutung.
elif [ "$overall_status" -eq 1 ]; then
  # Prüft, ob mindestens eine Warnung erkannt wurde.
  printf 'Status: WARNING\n'
  # Gibt WARNING als Gesamtstatus aus.
  printf 'Bedeutung: Prüfung erforderlich, aber kein unmittelbarer Ausfall erkannt.\n'
  # Beschreibt die WARNING-Bedeutung.
else
  # Behandelt kritische Zustände.
  printf 'Status: CRITICAL\n'
  # Gibt CRITICAL als Gesamtstatus aus.
  printf 'Bedeutung: Kritischer Zustand erkannt, zeitnahe Reaktion erforderlich.\n'
  # Beschreibt die CRITICAL-Bedeutung.
fi
# Beendet die Gesamtbewertung.

printf 'Exit-Code: %s\n' "$overall_status"
# Gibt den numerischen Exit-Code aus.

exit "$overall_status"
# Beendet das Skript mit dem Monitoring-Exit-Code.
