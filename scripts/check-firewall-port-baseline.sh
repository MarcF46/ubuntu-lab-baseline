#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

section "Firewall / Port Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "UFW"

if command -v ufw >/dev/null 2>&1; then
  ok "UFW ist installiert."
  ufw_status_line="$(sudo -n ufw status verbose 2>/dev/null | head -n 1 || true)"
  printf "UFW Statuszeile: %s\n" "${ufw_status_line:-nicht ermittelt}"

  if sudo -n ufw status 2>/dev/null | grep -q '^Status: active'; then
    ok "UFW ist aktiv."
  else
    warning "UFW ist nicht aktiv. Im Lab ist das dokumentiert; in Produktion wäre das ein Bewertungs- und Freigabepunkt."
  fi
else
  warning "UFW ist nicht installiert."
fi

section "nftables"

if command -v nft >/dev/null 2>&1; then
  ok "nftables-Werkzeug ist vorhanden."
  nft_rules_count="$(sudo -n nft list ruleset 2>/dev/null | wc -l)"
  printf "nftables Ruleset-Zeilen: %s\n" "$nft_rules_count"

  if [ "$nft_rules_count" -eq 0 ]; then
    ok "Keine eigenen nftables-Regeln sichtbar."
  else
    ok "nftables-Regelwerk ist sichtbar."
  fi
else
  warning "nftables-Werkzeug ist nicht vorhanden."
fi

section "SSH"

ssh_active="$(systemctl is-active ssh 2>/dev/null || true)"
ssh_enabled="$(systemctl is-enabled ssh 2>/dev/null || true)"
ssh_port_visible="$(ss -tlnH 2>/dev/null | awk '{print $4}' | grep -Eq '(:22$|\]:22$)' && echo ja || echo nein)"

printf "SSH Dienststatus: %s\n" "${ssh_active:-nicht ermittelt}"
printf "SSH Autostartstatus: %s\n" "${ssh_enabled:-nicht ermittelt}"
printf "SSH Port 22 lokal sichtbar: %s\n" "$ssh_port_visible"

if [ "$ssh_active" = "active" ]; then
  ok "SSH-Dienst ist aktiv."
else
  critical "SSH-Dienst ist nicht aktiv."
fi

if [ "$ssh_enabled" = "enabled" ]; then
  ok "SSH-Dienst ist für Autostart aktiviert."
else
  warning "SSH-Dienst ist nicht für Autostart aktiviert."
fi

if [ "$ssh_port_visible" = "ja" ]; then
  ok "SSH-Port 22 lauscht lokal."
else
  critical "SSH-Port 22 lauscht nicht sichtbar."
fi

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

section "Bind-Adressen Kurzbewertung"

localhost_tcp_count="$(ss -tlnH 2>/dev/null | awk '{print $4}' | grep -Ec '(^127\.|^\[::1\]|localhost)' || true)"
all_ipv4_tcp_count="$(ss -tlnH 2>/dev/null | awk '{print $4}' | grep -Ec '(^0\.0\.0\.0:)' || true)"
all_ipv6_tcp_count="$(ss -tlnH 2>/dev/null | awk '{print $4}' | grep -Ec '^\[::\]:' || true)"

printf "TCP nur lokal/Loopback sichtbar: %s\n" "$localhost_tcp_count"
printf "TCP auf allen IPv4-Adressen sichtbar: %s\n" "$all_ipv4_tcp_count"
printf "TCP auf IPv6-any sichtbar: %s\n" "$all_ipv6_tcp_count"

if [ "$all_ipv4_tcp_count" -gt 0 ] || [ "$all_ipv6_tcp_count" -gt 0 ]; then
  warning "Mindestens ein TCP-Dienst lauscht auf einer allgemeineren Adresse. Das ist nicht automatisch falsch, muss aber fachlich erklärbar sein."
else
  ok "Keine allgemein gebundenen TCP-Listener sichtbar."
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
  echo "[RESULT] Firewall / Port Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Firewall / Port Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Firewall / Port Health Check erfolgreich."
exit 0
