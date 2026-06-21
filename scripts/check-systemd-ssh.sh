#!/usr/bin/env bash
set -u

echo "========================================"
echo " systemd / SSH Service Health Check"
echo "========================================"
echo

failed=0

ok() {
  echo "[OK] $1"
}

fail() {
  echo "[FAIL] $1"
  failed=1
}

echo "[INFO] System:"
hostname
echo

echo "[CHECK] Prüfe, ob ssh.service aktiv ist..."
if systemctl is-active --quiet ssh; then
  ok "ssh.service ist aktiv."
else
  fail "ssh.service ist nicht aktiv."
fi

echo
echo "[CHECK] Prüfe, ob ssh.service enabled ist..."
if systemctl is-enabled --quiet ssh; then
  ok "ssh.service ist für den Systemstart aktiviert."
else
  fail "ssh.service ist nicht enabled."
fi

echo
echo "[CHECK] Prüfe Systemzeit / Zeitsynchronisation..."
if timedatectl | grep -q "System clock synchronized: yes"; then
  ok "Systemuhr ist synchronisiert."
else
  fail "Systemuhr ist nicht synchronisiert."
fi

if timedatectl | grep -q "NTP service: active"; then
  ok "NTP-Dienst ist aktiv."
else
  fail "NTP-Dienst ist nicht aktiv."
fi

echo
echo "[INFO] Kurzstatus ssh.service:"
systemctl status ssh --no-pager -l | sed -n '1,12p'

echo
echo "[INFO] Letzte SSH-Logs:"
journalctl -u ssh --no-pager -n 10 -o short-iso || fail "SSH-Logs konnten nicht gelesen werden."

echo
echo "========================================"
if [ "$failed" -eq 0 ]; then
  echo "[RESULT] systemd / SSH Service Check erfolgreich."
else
  echo "[RESULT] systemd / SSH Service Check mit Fehlern abgeschlossen."
fi
echo "========================================"

exit "$failed"
