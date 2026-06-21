#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

section "Resources Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "CPU und Load"
cpu_count="$(nproc)"
load1="$(awk '{print $1}' /proc/loadavg)"
load5="$(awk '{print $2}' /proc/loadavg)"
load15="$(awk '{print $3}' /proc/loadavg)"
load1_percent="$(awk -v load="$load1" -v cpu="$cpu_count" 'BEGIN { printf "%.0f", (load / cpu) * 100 }')"

printf "Logische CPU-Kerne: %s\n" "$cpu_count"
printf "Load Average 1/5/15 Minuten: %s / %s / %s\n" "$load1" "$load5" "$load15"
printf "Load bezogen auf CPU-Kerne: %s%%\n" "$load1_percent"

if [ "$load1_percent" -ge 150 ]; then
  critical "Load ist sehr hoch im Verhältnis zur CPU-Anzahl."
elif [ "$load1_percent" -ge 90 ]; then
  warning "Load ist hoch und sollte beobachtet werden."
else
  ok "Load ist aktuell unauffällig."
fi

section "RAM"
mem_total_mb="$(LC_ALL=C free -m | awk '/^Mem:/ {print $2}')"
mem_used_mb="$(LC_ALL=C free -m | awk '/^Mem:/ {print $3}')"
mem_available_mb="$(LC_ALL=C free -m | awk '/^Mem:/ {print $7}')"
mem_used_percent="$(awk -v used="$mem_used_mb" -v total="$mem_total_mb" 'BEGIN { printf "%.0f", (used / total) * 100 }')"
mem_available_percent="$(awk -v available="$mem_available_mb" -v total="$mem_total_mb" 'BEGIN { printf "%.0f", (available / total) * 100 }')"

printf "RAM gesamt: %s MiB\n" "$mem_total_mb"
printf "RAM genutzt: %s MiB (%s%%)\n" "$mem_used_mb" "$mem_used_percent"
printf "RAM verfügbar: %s MiB (%s%%)\n" "$mem_available_mb" "$mem_available_percent"

if [ "$mem_available_mb" -lt 512 ]; then
  critical "Weniger als 512 MiB RAM verfügbar."
elif [ "$mem_available_mb" -lt 1024 ]; then
  warning "Weniger als 1 GiB RAM verfügbar."
else
  ok "RAM-Verfügbarkeit ist aktuell unauffällig."
fi

section "Swap"
swap_total_mb="$(LC_ALL=C free -m | awk '/^Swap:/ {print $2}')"
swap_used_mb="$(LC_ALL=C free -m | awk '/^Swap:/ {print $3}')"

printf "Swap gesamt: %s MiB\n" "$swap_total_mb"
printf "Swap genutzt: %s MiB\n" "$swap_used_mb"

if [ "$swap_used_mb" -gt 0 ]; then
  warning "Swap wird genutzt. Ursache und Verlauf sollten geprüft werden."
else
  ok "Swap wird aktuell nicht genutzt."
fi

section "Top Prozesse"
top_cpu_process="$(ps -eo pid=,%cpu=,comm= --sort=-%cpu | awk 'NR==1 {pid=$1; cpu=$2; $1=""; $2=""; sub(/^ +/, ""); print $0 " (PID " pid ", " cpu "% CPU)"}')"
top_mem_process="$(ps -eo pid=,%mem=,comm= --sort=-%mem | awk 'NR==1 {pid=$1; mem=$2; $1=""; $2=""; sub(/^ +/, ""); print $0 " (PID " pid ", " mem "% RAM)"}')"

printf "Auffälligster Prozess nach CPU: %s\n" "${top_cpu_process:-nicht ermittelt}"
printf "Auffälligster Prozess nach RAM: %s\n" "${top_mem_process:-nicht ermittelt}"

ok "Top-Prozesse wurden ermittelt. Fachliche Einordnung bleibt erforderlich."

section "Failed systemd Units"
failed_units="$(systemctl --failed --no-legend --no-pager 2>/dev/null | wc -l)"
printf "Fehlgeschlagene systemd Units: %s\n" "$failed_units"

if [ "$failed_units" -gt 0 ]; then
  warning "Es gibt fehlgeschlagene systemd Units."
else
  ok "Keine fehlgeschlagenen systemd Units sichtbar."
fi

section "Ergebnis"
if [ "$fail" -ne 0 ]; then
  echo "[RESULT] Resources Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Resources Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Resources Health Check erfolgreich."
exit 0
