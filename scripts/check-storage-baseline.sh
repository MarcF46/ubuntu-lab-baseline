#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

section "Storage Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "Root-Dateisystem"
root_use="$(df -P / | awk "NR==2 {gsub(\"%\", \"\", \$5); print \$5}")"
root_free="$(df -h / | awk "NR==2 {print \$4}")"
root_type="$(df -T / | awk "NR==2 {print \$2}")"
printf "Root-Dateisystem: Typ=%s Nutzung=%s%% Frei=%s\n" "$root_type" "$root_use" "$root_free"

if [ "$root_use" -ge 90 ]; then
  critical "Root-Dateisystem ist kritisch ausgelastet."
elif [ "$root_use" -ge 80 ]; then
  warning "Root-Dateisystem sollte beobachtet werden."
else
  ok "Root-Dateisystem ist unkritisch ausgelastet."
fi

section "/var/log"
varlog_kb="$(du -sk /var/log 2>/dev/null | awk "{print \$1}")"
varlog_size="$(du -sh /var/log 2>/dev/null | awk "{print \$1}")"
printf "/var/log Größe: %s\n" "${varlog_size:-unbekannt}"

if [ "${varlog_kb:-0}" -ge 1048576 ]; then
  warning "/var/log ist größer als 1 GiB und sollte bewertet werden."
else
  ok "/var/log ist aktuell unauffällig."
fi

section "Swap"
swap_count="$(swapon --show --noheadings 2>/dev/null | wc -l)"
if [ "$swap_count" -gt 0 ]; then
  ok "Swap ist vorhanden oder aktiv konfiguriert."
else
  warning "Kein aktiver Swap in swapon-Ausgabe sichtbar."
fi

section "Mount-Grundzustand"
if findmnt / >/dev/null 2>&1; then
  ok "Root-Mount ist sichtbar."
else
  critical "Root-Mount konnte nicht geprüft werden."
fi

if lsblk -f >/dev/null 2>&1; then
  ok "Blockgeräte können abgefragt werden."
else
  critical "Blockgeräte konnten nicht abgefragt werden."
fi

section "Hohe Auslastung weiterer Dateisysteme"
high_usage_count="$(df -P -x tmpfs -x squashfs -x devtmpfs -x efivarfs | awk "NR>1 {gsub(\"%\", \"\", \$5); if (\$5 >= 85 && \$6 != \"/\") count++} END {print count+0}")"
printf "Nicht-System-Dateisysteme ab 85%% Nutzung: %s\n" "$high_usage_count"

if [ "$high_usage_count" -gt 0 ]; then
  warning "Mindestens ein weiteres Dateisystem ist stark ausgelastet. Details mit df -hT prüfen."
else
  ok "Keine weitere hohe Dateisystemauslastung sichtbar."
fi

section "Ergebnis"
if [ "$fail" -ne 0 ]; then
  echo "[RESULT] Storage Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Storage Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Storage Health Check erfolgreich."
exit 0
