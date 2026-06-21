#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

section "Logging Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "systemd-journald"
journald_state="$(systemctl is-active systemd-journald 2>/dev/null || true)"
printf "systemd-journald Zustand: %s\n" "$journald_state"
if [ "$journald_state" = "active" ]; then
  ok "systemd-journald ist aktiv."
else
  critical "systemd-journald ist nicht aktiv."
fi

section "Journal Speicherverbrauch"
journal_usage="$(journalctl --disk-usage 2>/dev/null || true)"
printf "%s\n" "${journal_usage:-nicht ermittelt}"
if [ -n "$journal_usage" ]; then
  ok "Journal-Speicherverbrauch konnte ermittelt werden."
else
  warning "Journal-Speicherverbrauch konnte nicht ermittelt werden."
fi

section "Warnungen der letzten Stunde"
warning_count="$(journalctl -p warning..alert --since "1 hour ago" --no-pager 2>/dev/null | grep -vc "^-- No entries --$" || true)"
printf "Warn-/kritische Einträge letzte Stunde: %s\n" "$warning_count"
if [ "$warning_count" -gt 0 ]; then
  warning "Warnungen vorhanden. Einordnung über journalctl erforderlich."
else
  ok "Keine Warnungen im geprüften Zeitraum sichtbar."
fi

section "/var/log"
varlog_size="$(du -sh /var/log 2>/dev/null | awk "{print \$1}")"
varlog_kb="$(du -sk /var/log 2>/dev/null | awk "{print \$1}")"
printf "/var/log Größe: %s\n" "${varlog_size:-nicht ermittelt}"
if [ "${varlog_kb:-0}" -ge 1048576 ]; then
  warning "/var/log ist größer als 1 GiB und sollte bewertet werden."
else
  ok "/var/log ist aktuell unauffällig."
fi

section "rsyslog"
if command -v rsyslogd >/dev/null 2>&1; then
  rsyslog_state="$(systemctl is-active rsyslog 2>/dev/null || true)"
  printf "rsyslog Zustand: %s\n" "$rsyslog_state"
  if [ "$rsyslog_state" = "active" ]; then
    ok "rsyslog ist vorhanden und aktiv."
  else
    warning "rsyslog ist vorhanden, aber nicht aktiv."
  fi
else
  warning "rsyslogd wurde nicht gefunden."
fi

section "Logrotate"
if [ -f /etc/logrotate.conf ]; then
  ok "/etc/logrotate.conf ist vorhanden."
else
  critical "/etc/logrotate.conf fehlt."
fi

logrotate_count="$(find /etc/logrotate.d -maxdepth 1 -type f 2>/dev/null | wc -l)"
printf "Logrotate.d Dateien: %s\n" "$logrotate_count"
if [ "$logrotate_count" -gt 0 ]; then
  ok "Logrotate-Regeln sind vorhanden."
else
  warning "Keine Logrotate-Regeln unter /etc/logrotate.d gefunden."
fi

section "Ergebnis"
if [ "$fail" -ne 0 ]; then
  echo "[RESULT] Logging Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Logging Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Logging Health Check erfolgreich."
exit 0
