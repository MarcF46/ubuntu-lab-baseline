#!/usr/bin/env bash
set -u

UNIT="lab04-demo.service"
MODE_FILE="/tmp/lab04-demo-service-mode"
failures=0

echo "========================================"
echo " Lab04 systemd Demo Service Health Check"
echo "========================================"
echo

if [ "$(id -u)" -ne 0 ]; then
  echo "[FEHLER] Dieses Skript muss mit sudo/root ausgeführt werden."
  echo "Beispiel: sudo ./scripts/check-lab04-systemd-demo.sh"
  exit 2
fi

echo "[INFO] Prüfe systemd-Unit: $UNIT"
if systemctl cat "$UNIT" >/dev/null 2>&1; then
  echo "[OK] Unit ist systemd bekannt."
else
  echo "[FEHLER] Unit ist systemd nicht bekannt."
  exit 1
fi

echo
echo "[TEST 1] Normalzustand prüfen..."
echo "ok" > "$MODE_FILE"
systemctl reset-failed "$UNIT" >/dev/null 2>&1 || true

if systemctl start "$UNIT"; then
  echo "[OK] Dienstlauf im Normalzustand erfolgreich."
else
  echo "[FEHLER] Dienstlauf im Normalzustand fehlgeschlagen."
  failures=$((failures + 1))
fi

normal_result="$(systemctl show "$UNIT" -p Result --value)"
normal_status="$(systemctl show "$UNIT" -p ExecMainStatus --value)"
echo "[INFO] Result=$normal_result"
echo "[INFO] ExecMainStatus=$normal_status"

if [ "$normal_result" = "success" ] && [ "$normal_status" = "0" ]; then
  echo "[OK] Normalzustand korrekt bewertet."
else
  echo "[FEHLER] Normalzustand wurde nicht korrekt bewertet."
  failures=$((failures + 1))
fi

echo
echo "[TEST 2] Fehlerzustand absichtlich erzeugen..."
echo "fail" > "$MODE_FILE"
systemctl reset-failed "$UNIT" >/dev/null 2>&1 || true

if systemctl start "$UNIT"; then
  echo "[FEHLER] Dienst hätte fehlschlagen sollen, war aber erfolgreich."
  failures=$((failures + 1))
else
  echo "[OK] Erwarteter Fehlerzustand wurde erzeugt."
fi

failed_state="$(systemctl is-failed "$UNIT")"
failed_result="$(systemctl show "$UNIT" -p Result --value)"
failed_status="$(systemctl show "$UNIT" -p ExecMainStatus --value)"
echo "[INFO] is-failed=$failed_state"
echo "[INFO] Result=$failed_result"
echo "[INFO] ExecMainStatus=$failed_status"

if [ "$failed_state" = "failed" ] && [ "$failed_result" = "exit-code" ] && [ "$failed_status" = "42" ]; then
  echo "[OK] Fehlerzustand korrekt erkannt."
else
  echo "[FEHLER] Fehlerzustand wurde nicht korrekt erkannt."
  failures=$((failures + 1))
fi

echo
echo "[TEST 3] Wiederherstellung prüfen..."
echo "ok" > "$MODE_FILE"
systemctl reset-failed "$UNIT" >/dev/null 2>&1 || true

if systemctl start "$UNIT"; then
  echo "[OK] Dienst wurde nach Fix erfolgreich gestartet."
else
  echo "[FEHLER] Dienst konnte nach Fix nicht erfolgreich gestartet werden."
  failures=$((failures + 1))
fi

recovery_result="$(systemctl show "$UNIT" -p Result --value)"
recovery_status="$(systemctl show "$UNIT" -p ExecMainStatus --value)"
echo "[INFO] Result=$recovery_result"
echo "[INFO] ExecMainStatus=$recovery_status"

if [ "$recovery_result" = "success" ] && [ "$recovery_status" = "0" ]; then
  echo "[OK] Wiederherstellung korrekt verifiziert."
else
  echo "[FEHLER] Wiederherstellung wurde nicht korrekt verifiziert."
  failures=$((failures + 1))
fi

echo
echo "[INFO] Letzte Logs des Demo-Dienstes:"
journalctl -u "$UNIT" --no-pager -n 25 -o short-iso

echo
echo "========================================"
if [ "$failures" -eq 0 ]; then
  echo "[RESULT] Lab04 systemd Demo Service Check erfolgreich."
  echo "========================================"
  exit 0
else
  echo "[RESULT] Lab04 systemd Demo Service Check fehlgeschlagen. Fehleranzahl: $failures"
  echo "========================================"
  exit 1
fi
