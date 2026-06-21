#!/usr/bin/env bash
set -u

echo "========================================"
echo " User / Groups / sudo Health Check"
echo "========================================"
echo

failed=0

check_ok() {
  echo "[OK] $1"
}

check_fail() {
  echo "[FAIL] $1"
  failed=1
}

echo "[INFO] System:"
hostname
echo

echo "[CHECK] Prüfe, ob Benutzer marc existiert..."
if id marc >/dev/null 2>&1; then
  check_ok "Benutzer marc existiert."
else
  check_fail "Benutzer marc fehlt."
fi

echo
echo "[CHECK] Prüfe, ob marc Mitglied der Gruppe sudo ist..."
if id -nG marc | grep -qw sudo; then
  check_ok "marc ist Mitglied der Gruppe sudo."
else
  check_fail "marc ist nicht Mitglied der Gruppe sudo."
fi

echo
echo "[CHECK] Prüfe, ob Benutzer labuser01 existiert..."
if id labuser01 >/dev/null 2>&1; then
  check_ok "Benutzer labuser01 existiert."
else
  check_fail "Benutzer labuser01 fehlt."
fi

echo
echo "[CHECK] Prüfe, ob labuser01 keine sudo-Mitgliedschaft besitzt..."
if id -nG labuser01 | grep -qw sudo; then
  check_fail "labuser01 ist unerwartet Mitglied der Gruppe sudo."
else
  check_ok "labuser01 ist nicht Mitglied der Gruppe sudo."
fi

echo
echo "[CHECK] Prüfe Home-Verzeichnisse..."
if [ -d /home/marc ]; then
  check_ok "/home/marc existiert."
else
  check_fail "/home/marc fehlt."
fi

if [ -d /home/labuser01 ]; then
  check_ok "/home/labuser01 existiert."
else
  check_fail "/home/labuser01 fehlt."
fi

echo
echo "[CHECK] Prüfe, ob labuser01 /etc/shadow nicht lesen darf..."
if sudo -u labuser01 test -r /etc/shadow; then
  check_fail "labuser01 kann /etc/shadow lesen. Das ist unerwartet kritisch."
else
  check_ok "labuser01 kann /etc/shadow nicht lesen."
fi

echo
echo "[INFO] Gruppenübersicht:"
id marc || true
id labuser01 || true

echo
echo "========================================"
if [ "$failed" -eq 0 ]; then
  echo "[RESULT] User / Groups / sudo Check erfolgreich."
else
  echo "[RESULT] User / Groups / sudo Check mit Fehlern abgeschlossen."
fi
echo "========================================"

exit "$failed"
