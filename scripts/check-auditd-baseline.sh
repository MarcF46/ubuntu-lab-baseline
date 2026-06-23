#!/usr/bin/env bash
set -u

fail=0
warn=0

ok(){ echo "[OK] $1"; }
warning(){ echo "[WARN] $1"; warn=1; }
critical(){ echo "[CRIT] $1"; fail=1; }

echo "## auditd Baseline Health Check"
echo "Zeitpunkt: $(date -Is)"

echo "## Werkzeuge"
for tool in auditctl ausearch aureport augenrules; do
  if command -v "$tool" >/dev/null 2>&1; then
    ok "$tool ist vorhanden."
  else
    critical "$tool fehlt."
  fi
done

echo
echo "## Dienststatus"
active="$(systemctl is-active auditd 2>/dev/null || true)"
enabled="$(systemctl is-enabled auditd 2>/dev/null || true)"
echo "auditd active: ${active:-nicht_ermittelt}"
echo "auditd enabled: ${enabled:-nicht_ermittelt}"
[ "$active" = "active" ] && ok "auditd ist aktiv." || critical "auditd ist nicht aktiv."
[ "$enabled" = "enabled" ] && ok "auditd ist für Autostart aktiviert." || warning "auditd ist nicht für Autostart aktiviert."

echo
echo "## Konfigurationspfade mit sudo prüfen"
sudo -n test -f /etc/audit/auditd.conf && ok "/etc/audit/auditd.conf vorhanden." || critical "/etc/audit/auditd.conf fehlt oder ist nicht lesbar."
sudo -n test -d /etc/audit/rules.d && ok "/etc/audit/rules.d vorhanden." || critical "/etc/audit/rules.d fehlt oder ist nicht lesbar."
sudo -n test -f /etc/audit/rules.d/audit.rules && ok "/etc/audit/rules.d/audit.rules vorhanden." || warning "/etc/audit/rules.d/audit.rules fehlt oder ist nicht lesbar."
sudo -n test -f /etc/audit/rules.d/30-lab15-admin-files.rules && ok "Lab15-Regeldatei im System vorhanden." || critical "Lab15-Regeldatei im System fehlt."

echo
echo "## auditctl Status"
if sudo -n auditctl -s >/tmp/lab15-health-auditctl-status.out 2>&1; then
  ok "auditctl -s erfolgreich."
else
  cat /tmp/lab15-health-auditctl-status.out
  critical "auditctl -s fehlgeschlagen."
fi

if sudo -n auditctl -l >/tmp/lab15-health-auditctl-rules.out 2>&1; then
  ok "auditctl -l erfolgreich."
else
  cat /tmp/lab15-health-auditctl-rules.out
  critical "auditctl -l fehlgeschlagen."
fi

identity_count="$(sudo -n auditctl -l 2>/dev/null | grep -c "lab15_identity_changes" || true)"
sudoers_count="$(sudo -n auditctl -l 2>/dev/null | grep -c "lab15_sudoers_changes" || true)"
echo "lab15_identity_changes Regelanzahl: $identity_count"
echo "lab15_sudoers_changes Regelanzahl: $sudoers_count"
[ "$identity_count" -ge 4 ] && ok "Identity-Audit-Regeln geladen." || critical "Identity-Audit-Regeln fehlen oder sind unvollständig."
[ "$sudoers_count" -ge 2 ] && ok "sudoers-Audit-Regeln geladen." || critical "sudoers-Audit-Regeln fehlen oder sind unvollständig."

echo
echo "## Ergebnis"
if [ "$fail" -ne 0 ]; then
  echo "[RESULT] auditd Baseline Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] auditd Baseline Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] auditd Baseline Health Check erfolgreich."
exit 0
