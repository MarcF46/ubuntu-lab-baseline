#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

section "Network Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "Interfaces und IP-Konfiguration"

active_ifaces_count="$(ip -brief link show up 2>/dev/null | awk '$1 != "lo" {count++} END {print count+0}')"
global_ipv4_count="$(ip -4 -brief addr show scope global 2>/dev/null | wc -l)"
global_ipv6_count="$(ip -6 -brief addr show scope global 2>/dev/null | wc -l)"

printf "Aktive Nicht-Loopback-Interfaces: %s\n" "$active_ifaces_count"
printf "Globale IPv4-Konfigurationen: %s\n" "$global_ipv4_count"
printf "Globale IPv6-Konfigurationen: %s\n" "$global_ipv6_count"

if [ "$active_ifaces_count" -lt 1 ]; then
  critical "Kein aktives Nicht-Loopback-Interface sichtbar."
else
  ok "Mindestens ein aktives Nicht-Loopback-Interface vorhanden."
fi

if [ "$global_ipv4_count" -lt 1 ]; then
  warning "Keine globale IPv4-Adresse sichtbar."
else
  ok "Mindestens eine globale IPv4-Adresse vorhanden."
fi

section "Default Route"

default_route="$(ip route show default 2>/dev/null | head -n 1 || true)"
default_iface="$(ip route show default 2>/dev/null | awk 'NR==1 {for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')"

if [ -n "$default_route" ]; then
  ok "Default Route ist vorhanden."
  printf "Primäres Interface laut Default Route: %s\n" "${default_iface:-nicht ermittelt}"
else
  critical "Default Route fehlt."
fi

section "DNS"

dns_ubuntu="nein"
dns_github="nein"

if getent hosts ubuntu.com >/dev/null 2>&1; then
  dns_ubuntu="ja"
  ok "DNS-Auflösung für ubuntu.com erfolgreich."
else
  warning "DNS-Auflösung für ubuntu.com fehlgeschlagen."
fi

if getent hosts github.com >/dev/null 2>&1; then
  dns_github="ja"
  ok "DNS-Auflösung für github.com erfolgreich."
else
  warning "DNS-Auflösung für github.com fehlgeschlagen."
fi

printf "DNS ubuntu.com: %s\n" "$dns_ubuntu"
printf "DNS github.com: %s\n" "$dns_github"

section "Erreichbarkeit"

ping_ip="nein"
ping_domain="nein"

if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
  ping_ip="ja"
  ok "Ping auf 1.1.1.1 erfolgreich."
else
  warning "Ping auf 1.1.1.1 fehlgeschlagen."
fi

if ping -c 1 -W 2 ubuntu.com >/dev/null 2>&1; then
  ping_domain="ja"
  ok "Ping auf ubuntu.com erfolgreich."
else
  warning "Ping auf ubuntu.com fehlgeschlagen. ICMP kann blockiert sein."
fi

printf "Ping IP-Ziel: %s\n" "$ping_ip"
printf "Ping Domain-Ziel: %s\n" "$ping_domain"

section "Lokale Ports"

tcp_listen_count="$(ss -tlnH 2>/dev/null | wc -l)"
udp_listen_count="$(ss -ulnH 2>/dev/null | wc -l)"

printf "Lokal lauschende TCP-Ports: %s\n" "$tcp_listen_count"
printf "Lokal gebundene UDP-Ports: %s\n" "$udp_listen_count"

if [ "$tcp_listen_count" -gt 0 ]; then
  ok "Mindestens ein TCP-Listener ist vorhanden."
else
  warning "Keine TCP-Listener sichtbar."
fi

if ss -tlnH 2>/dev/null | awk '{print $4}' | grep -Eq '(:22$|\]:22$)'; then
  ok "SSH-Port 22 lauscht lokal."
else
  warning "SSH-Port 22 lauscht nicht sichtbar."
fi

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
  echo "[RESULT] Network Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Network Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Network Health Check erfolgreich."
exit 0
