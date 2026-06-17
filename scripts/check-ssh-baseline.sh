#!/usr/bin/env bash

# SSH Baseline Health Check
# Zweck:
# Dieses Skript prüft grundlegende SSH-Betriebsbedingungen auf einem Ubuntu-Linux-System.
# Es ersetzt kein vollständiges Security-Audit, hilft aber bei einer schnellen Junior-Admin-Baseline.

echo "========================================"
echo " SSH Baseline Health Check"
echo "========================================"
echo

# 1. Hostname anzeigen
echo "[INFO] System:"
hostnamectl --static
echo

# 2. Aktuellen Benutzer anzeigen
echo "[INFO] Aktueller Benutzer:"
whoami
echo

# 3. Prüfen, ob openssh-server installiert ist
echo "[CHECK] Prüfe, ob openssh-server installiert ist..."
if dpkg -l | grep -q "^ii  openssh-server"; then
    echo "[OK] openssh-server ist installiert."
else
    echo "[FAIL] openssh-server ist nicht installiert."
    echo "       Möglicher Fix: sudo apt update && sudo apt install -y openssh-server"
    exit 1
fi
echo

# 4. Prüfen, ob der SSH-Dienst aktiv läuft
echo "[CHECK] Prüfe, ob ssh.service aktiv ist..."
if systemctl is-active --quiet ssh; then
    echo "[OK] ssh.service ist aktiv."
else
    echo "[FAIL] ssh.service ist nicht aktiv."
    echo "       Möglicher Fix: sudo systemctl start ssh"
    exit 2
fi
echo

# 5. Prüfen, ob SSH für den Systemstart aktiviert ist
echo "[CHECK] Prüfe, ob ssh.service enabled ist..."
if systemctl is-enabled --quiet ssh; then
    echo "[OK] ssh.service ist für den Systemstart aktiviert."
else
    echo "[WARN] ssh.service ist nicht für den Systemstart aktiviert."
    echo "       Möglicher Fix: sudo systemctl enable ssh"
fi
echo

# 6. Prüfen, ob Port 22 lauscht
echo "[CHECK] Prüfe, ob Port 22 lauscht..."
if ss -tln | grep -q ':22'; then
    echo "[OK] Port 22 lauscht."
else
    echo "[FAIL] Port 22 lauscht nicht."
    echo "       Prüfen mit: systemctl status ssh --no-pager"
    exit 3
fi
echo

# 7. Aktuelle SSH-Logs anzeigen
echo "[INFO] Letzte SSH-Logeinträge:"
journalctl -u ssh --no-pager -n 10
echo

echo "========================================"
echo "[RESULT] SSH Baseline Check abgeschlossen."
echo "========================================"
