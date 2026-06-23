#!/usr/bin/env bash
set -u

# Lab16f – Log- und Dateisystem-Healthcheck
# Read-only Skript: prüft nur, verändert nichts.

WARN_PERCENT=80
CRIT_PERCENT=90
STATUS=0

print_header() {
  printf "\n== %s ==\n" "$1"
}

percent_number() {
  printf "%s" "$1" | tr -d "%"
}

set_warn() {
  if [ "$STATUS" -lt 1 ]; then
    STATUS=1
  fi
}

set_crit() {
  STATUS=2
}

check_percent() {
  label="$1"
  value="$2"
  number="$(percent_number "$value")"

  if [ -z "$number" ]; then
    echo "UNKNOWN: $label konnte nicht bewertet werden"
    set_warn
    return
  fi

  if [ "$number" -ge "$CRIT_PERCENT" ]; then
    echo "CRITICAL: $label bei $value"
    set_crit
  elif [ "$number" -ge "$WARN_PERCENT" ]; then
    echo "WARNING: $label bei $value"
    set_warn
  else
    echo "OK: $label bei $value"
  fi
}

print_header "Speicherplatz Root-Dateisystem"
root_disk="$(df -h / | awk "NR==2 {print \$5}")"
check_percent "Speicherplatz /" "$root_disk"
df -h /

print_header "Inodes Root-Dateisystem"
root_inodes="$(df -i / | awk "NR==2 {print \$5}")"
check_percent "Inodes /" "$root_inodes"
df -i /

print_header "/var/log Größe"
if [ -d /var/log ]; then
  varlog_size="$(sudo du -sh /var/log 2>/dev/null | awk "{print \$1}")"
  echo "INFO: /var/log Größe: ${varlog_size:-unbekannt}"
else
  echo "WARNING: /var/log existiert nicht"
  set_warn
fi

print_header "Anzahl Logdateien"
if [ -d /var/log ]; then
  varlog_files="$(sudo find /var/log -type f 2>/dev/null | wc -l)"
  echo "INFO: Dateien unter /var/log: $varlog_files"
fi

print_header "Logrotate Timer"
if systemctl is-active --quiet logrotate.timer; then
  echo "OK: logrotate.timer ist aktiv"
else
  echo "WARNING: logrotate.timer ist nicht aktiv"
  set_warn
fi
systemctl status logrotate.timer --no-pager 2>/dev/null | sed -n "1,8p" || true

print_header "Gelöschte offene Dateien unter /var/log"
if command -v lsof >/dev/null 2>&1; then
  deleted_varlog_count="$(sudo lsof +L1 2>/dev/null | grep -E "/var/log/.*\\(deleted\\)" | wc -l)"
  if [ "$deleted_varlog_count" -gt 0 ]; then
    echo "WARNING: Gelöschte offene Dateien unter /var/log gefunden: $deleted_varlog_count"
    set_warn
    sudo lsof +L1 2>/dev/null | grep -E "/var/log/.*\\(deleted\\)" || true
  else
    echo "OK: Keine gelöschten offenen Dateien unter /var/log gefunden"
  fi
else
  echo "INFO: lsof ist nicht installiert"
fi

print_header "Gesamtbewertung"
case "$STATUS" in
  0) echo "OK: Log- und Dateisystem-Healthcheck unkritisch" ;;
  1) echo "WARNING: Log- und Dateisystem-Healthcheck mit Warnungen" ;;
  2) echo "CRITICAL: Log- oder Dateisystemzustand kritisch" ;;
esac

exit "$STATUS"
