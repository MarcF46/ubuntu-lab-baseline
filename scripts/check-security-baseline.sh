#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

section "Security Baseline Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "Benutzer und sudo"

current_user="$(whoami)"
user_groups="$(id -nG 2>/dev/null || true)"
printf "Aktueller Benutzer: %s\n" "$current_user"
printf "Gruppen: %s\n" "$user_groups"

if id -nG 2>/dev/null | grep -qw sudo; then
  ok "Benutzer ist Mitglied der sudo-Gruppe. Für das Admin-Lab plausibel."
else
  warning "Benutzer ist nicht Mitglied der sudo-Gruppe."
fi

if sudo -n -l >/tmp/lab13-sudo-check.out 2>&1; then
  ok "sudo-Grundprüfung erfolgreich."
else
  cat /tmp/lab13-sudo-check.out
  warning "sudo-Grundprüfung konnte nicht erfolgreich ausgeführt werden."
fi

section "Home- und SSH-Rechte"

home_perm="$(stat -c '%a' "$HOME" 2>/dev/null || echo nicht_ermittelt)"
ssh_perm="$(stat -c '%a' "$HOME/.ssh" 2>/dev/null || echo nicht_vorhanden)"
auth_perm="$(stat -c '%a' "$HOME/.ssh/authorized_keys" 2>/dev/null || echo nicht_vorhanden)"

printf "Home-Rechte: %s\n" "$home_perm"
printf ".ssh-Rechte: %s\n" "$ssh_perm"
printf "authorized_keys-Rechte: %s\n" "$auth_perm"

case "$home_perm" in
  700|750|755)
    ok "Home-Verzeichnisrechte sind für das Lab plausibel."
    ;;
  *)
    warning "Home-Verzeichnisrechte sollten geprüft werden."
    ;;
esac

if [ "$ssh_perm" = "700" ]; then
  ok ".ssh-Verzeichnis ist restriktiv gesetzt."
else
  warning ".ssh-Verzeichnisrechte sind nicht 700 oder nicht vorhanden."
fi

if [ "$auth_perm" = "600" ]; then
  ok "authorized_keys ist restriktiv gesetzt."
else
  warning "authorized_keys ist nicht 600 oder nicht vorhanden."
fi

section "SSH Dienst und Port"

ssh_active="$(systemctl is-active ssh 2>/dev/null || true)"
ssh_enabled="$(systemctl is-enabled ssh 2>/dev/null || true)"
ssh_port_visible="$(ss -tlnH 2>/dev/null | awk '{print $4}' | grep -Eq '(:22$|\]:22$)' && echo ja || echo nein)"

printf "SSH Dienststatus: %s\n" "${ssh_active:-nicht_ermittelt}"
printf "SSH Autostartstatus: %s\n" "${ssh_enabled:-nicht_ermittelt}"
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

section "SSH Security-Parameter"

sshd_output="$(sudo -n sshd -T 2>/tmp/lab13-sshd-check.err || true)"

if [ -n "$sshd_output" ]; then
  permit_root_login="$(printf '%s\n' "$sshd_output" | awk '$1=="permitrootlogin" {print $2; exit}')"
  password_auth="$(printf '%s\n' "$sshd_output" | awk '$1=="passwordauthentication" {print $2; exit}')"
  pubkey_auth="$(printf '%s\n' "$sshd_output" | awk '$1=="pubkeyauthentication" {print $2; exit}')"
  empty_passwords="$(printf '%s\n' "$sshd_output" | awk '$1=="permitemptypasswords" {print $2; exit}')"
  x11_forwarding="$(printf '%s\n' "$sshd_output" | awk '$1=="x11forwarding" {print $2; exit}')"

  printf "PermitRootLogin: %s\n" "${permit_root_login:-nicht_ermittelt}"
  printf "PasswordAuthentication: %s\n" "${password_auth:-nicht_ermittelt}"
  printf "PubkeyAuthentication: %s\n" "${pubkey_auth:-nicht_ermittelt}"
  printf "PermitEmptyPasswords: %s\n" "${empty_passwords:-nicht_ermittelt}"
  printf "X11Forwarding: %s\n" "${x11_forwarding:-nicht_ermittelt}"

  case "$permit_root_login" in
    no|prohibit-password)
      ok "Root-Login ist nicht unkontrolliert per Passwort erlaubt."
      ;;
    *)
      warning "PermitRootLogin sollte fachlich geprüft werden."
      ;;
  esac

  if [ "$password_auth" = "yes" ]; then
    warning "PasswordAuthentication ist aktiv. Dokumentierter Härtungskandidat, keine Sofortänderung."
  elif [ "$password_auth" = "no" ]; then
    ok "PasswordAuthentication ist deaktiviert."
  else
    warning "PasswordAuthentication konnte nicht eindeutig bewertet werden."
  fi

  if [ "$pubkey_auth" = "yes" ]; then
    ok "PubkeyAuthentication ist aktiv."
  else
    warning "PubkeyAuthentication ist nicht aktiv oder nicht eindeutig."
  fi

  if [ "$empty_passwords" = "no" ]; then
    ok "Leere Passwörter sind nicht erlaubt."
  else
    warning "PermitEmptyPasswords sollte geprüft werden."
  fi

  if [ "$x11_forwarding" = "yes" ]; then
    warning "X11Forwarding ist aktiv. Dokumentierter Härtungskandidat, wenn nicht benötigt."
  elif [ "$x11_forwarding" = "no" ]; then
    ok "X11Forwarding ist deaktiviert."
  else
    warning "X11Forwarding konnte nicht eindeutig bewertet werden."
  fi
else
  cat /tmp/lab13-sshd-check.err 2>/dev/null || true
  critical "Effektive SSH-Konfiguration konnte nicht geprüft werden."
fi

section "Firewall"

if command -v ufw >/dev/null 2>&1; then
  ok "UFW ist installiert."
  ufw_status_line="$(sudo -n ufw status verbose 2>/dev/null | head -n 1 || true)"
  printf "UFW Statuszeile: %s\n" "${ufw_status_line:-nicht_ermittelt}"

  if sudo -n ufw status 2>/dev/null | grep -q '^Status: active'; then
    ok "UFW ist aktiv."
  else
    warning "UFW ist inaktiv. Dokumentierter Härtungskandidat, keine Sofortaktivierung."
  fi
else
  warning "UFW ist nicht installiert."
fi

section "Updates und Reboot"

if [ -f /var/run/reboot-required ]; then
  warning "Reboot-Marker ist vorhanden."
else
  ok "Kein Reboot-Marker vorhanden."
fi

upgradable_count="$(apt list --upgradable 2>/dev/null | tail -n +2 | grep -c . || true)"
printf "Offene Paketupdates: %s\n" "$upgradable_count"

if [ "$upgradable_count" -gt 0 ]; then
  warning "Es sind Paketupdates offen. Updates als kontrollierten Change behandeln."
else
  ok "Keine offenen Paketupdates sichtbar."
fi

section "Kritische Datei-Rechte"

shadow_state="$(stat -c '%a %U:%G' /etc/shadow 2>/dev/null || echo nicht_ermittelt)"
sudoers_state="$(stat -c '%a %U:%G' /etc/sudoers 2>/dev/null || echo nicht_ermittelt)"

printf "/etc/shadow: %s\n" "$shadow_state"
printf "/etc/sudoers: %s\n" "$sudoers_state"

case "$shadow_state" in
  "640 root:shadow"|"600 root:root")
    ok "/etc/shadow-Rechte wirken plausibel."
    ;;
  *)
    warning "/etc/shadow-Rechte sollten geprüft werden."
    ;;
esac

case "$sudoers_state" in
  "440 root:root")
    ok "/etc/sudoers-Rechte wirken plausibel."
    ;;
  *)
    warning "/etc/sudoers-Rechte sollten geprüft werden."
    ;;
esac

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
  echo "[RESULT] Security Baseline Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Security Baseline Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Security Baseline Health Check erfolgreich."
exit 0
