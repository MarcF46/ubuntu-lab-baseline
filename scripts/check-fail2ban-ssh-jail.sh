#!/usr/bin/env bash
set -u

fail=0
warn=0

ok(){ echo "[OK] $1"; }
warning(){ echo "[WARN] $1"; warn=1; }
critical(){ echo "[CRIT] $1"; fail=1; }

echo "## Fail2ban SSH Jail Health Check"
echo "Zeitpunkt: $(date -Is)"

echo
echo "## Paket / Client"
if command -v fail2ban-client >/dev/null 2>&1; then
  ok "fail2ban-client ist vorhanden."
else
  critical "fail2ban-client ist nicht vorhanden."
fi

echo
echo "## Dienststatus"
active="$(systemctl is-active fail2ban 2>/dev/null || true)"
enabled="$(systemctl is-enabled fail2ban 2>/dev/null || true)"

echo "fail2ban active: ${active:-nicht_ermittelt}"
echo "fail2ban enabled: ${enabled:-nicht_ermittelt}"

if [ "$active" = "active" ]; then
  ok "Fail2ban-Dienst ist aktiv."
else
  critical "Fail2ban-Dienst ist nicht aktiv."
fi

if [ "$enabled" = "enabled" ]; then
  ok "Fail2ban ist für Autostart aktiviert."
else
  warning "Fail2ban ist nicht für Autostart aktiviert."
fi

echo
echo "## Client Readiness"
if sudo -n fail2ban-client ping 2>/tmp/fail2ban-ping.err | grep -q 'pong'; then
  ok "fail2ban-client antwortet mit pong."
else
  cat /tmp/fail2ban-ping.err 2>/dev/null || true
  critical "fail2ban-client ist nicht ansprechbar."
fi

echo
echo "## SSH Jail"
if sudo -n fail2ban-client status 2>/tmp/fail2ban-status.err | grep -q 'sshd'; then
  ok "sshd-Jail ist in der Jail-Liste vorhanden."
else
  cat /tmp/fail2ban-status.err 2>/dev/null || true
  critical "sshd-Jail wurde nicht gefunden."
fi

if sudo -n fail2ban-client status sshd >/tmp/fail2ban-sshd-status.out 2>&1; then
  ok "sshd-Jail Status ist abrufbar."
  grep -E 'Currently failed|Total failed|Currently banned|Total banned' /tmp/fail2ban-sshd-status.out || true
else
  cat /tmp/fail2ban-sshd-status.out
  critical "sshd-Jail Status konnte nicht abgerufen werden."
fi

echo
echo "## Konfigurationstest"
if sudo -n fail2ban-client -t >/tmp/fail2ban-configtest.out 2>&1; then
  ok "Fail2ban-Konfigurationstest erfolgreich."
else
  cat /tmp/fail2ban-configtest.out
  critical "Fail2ban-Konfigurationstest fehlgeschlagen."
fi

echo
echo "## UFW Integration"
ufw_line="$(sudo -n ufw status verbose 2>/dev/null | head -n 1 || true)"
echo "UFW Statuszeile: ${ufw_line:-nicht_ermittelt}"

if sudo -n ufw status 2>/dev/null | grep -Eq '^Status: (active|Aktiv)'; then
  ok "UFW ist aktiv."
else
  warning "UFW ist nicht aktiv."
fi

echo
echo "## Ergebnis"
if [ "$fail" -ne 0 ]; then
  echo "[RESULT] Fail2ban SSH Jail Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Fail2ban SSH Jail Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Fail2ban SSH Jail Health Check erfolgreich."
exit 0
