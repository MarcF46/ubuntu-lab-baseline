#!/usr/bin/env bash
set -u

# Lab17d – Service-Monitoring-Healthcheck
# Read-only Skript: prüft Dienste, Ports und einfache Serviceabhängigkeiten.

STATUS=0

print_header() {
  printf "\n== %s ==\n" "$1"
}

set_warn() {
  if [ "$STATUS" -lt 1 ]; then
    STATUS=1
  fi
}

set_crit() {
  STATUS=2
}

check_service() {
  service="$1"
  severity="$2"
  description="$3"

  if systemctl is-active --quiet "$service"; then
    echo "OK: $service aktiv – $description"
  else
    if [ "$severity" = "critical" ]; then
      echo "CRITICAL: $service nicht aktiv – $description"
      set_crit
    else
      echo "WARNING: $service nicht aktiv – $description"
      set_warn
    fi
  fi
}

check_timer() {
  timer="$1"
  description="$2"

  if systemctl is-active --quiet "$timer"; then
    echo "OK: $timer aktiv – $description"
  else
    echo "WARNING: $timer nicht aktiv – $description"
    set_warn
  fi
}

check_tcp_port() {
  port="$1"
  description="$2"

  if ss -tln | awk "{print \$4}" | grep -Eq "(:|\\])$port$"; then
    echo "OK: TCP-Port $port lauscht – $description"
  else
    echo "WARNING: TCP-Port $port lauscht nicht – $description"
    set_warn
  fi
}

check_dns_resolution() {
  target="$1"

  if getent hosts "$target" >/dev/null 2>&1; then
    echo "OK: DNS-Auflösung funktioniert für $target"
  else
    echo "WARNING: DNS-Auflösung fehlgeschlagen für $target"
    set_warn
  fi
}

print_header "Kritische und wichtige Services"
check_service "ssh.service" "critical" "Remote-Administration"
check_service "auditd.service" "critical" "Auditierbarkeit sicherheitsrelevanter Ereignisse"
check_service "fail2ban.service" "warning" "Schutz gegen wiederholte fehlgeschlagene Logins"
check_service "rsyslog.service" "warning" "Systemlogging"
check_service "systemd-resolved.service" "warning" "lokale Namensauflösung"

print_header "Wichtige Timer"
check_timer "logrotate.timer" "Logrotation gegen unkontrolliertes Logwachstum"

print_header "Port-Checks"
check_tcp_port "22" "SSH-Zugriff"

print_header "DNS-Funktionscheck"
check_dns_resolution "ubuntu.com"

print_header "Lab16 Dateisystem-Healthcheck"
if [ -x "scripts/lab16-log-filesystem-healthcheck.sh" ]; then
  scripts/lab16-log-filesystem-healthcheck.sh >/tmp/lab17-lab16-healthcheck.out 2>&1
  lab16_exit=$?
  if [ "$lab16_exit" -eq 0 ]; then
    echo "OK: Lab16 Dateisystem-Healthcheck meldet OK"
  elif [ "$lab16_exit" -eq 1 ]; then
    echo "WARNING: Lab16 Dateisystem-Healthcheck meldet WARNING"
    set_warn
  else
    echo "CRITICAL: Lab16 Dateisystem-Healthcheck meldet CRITICAL oder Fehler"
    set_crit
  fi
else
  echo "WARNING: Lab16 Healthcheck-Skript nicht ausführbar oder nicht vorhanden"
  set_warn
fi

print_header "Gesamtbewertung"
case "$STATUS" in
  0)
    echo "Status: OK"
    echo "Bedeutung: Keine akute Auffälligkeit erkannt."
    echo "Exit-Code: 0 (OK für Monitoring-Systeme)"
    ;;
  1)
    echo "Status: WARNING"
    echo "Bedeutung: Mindestens eine Warnung erkannt. Bewertung oder Ticket sinnvoll."
    echo "Exit-Code: 1 (WARNING für Monitoring-Systeme)"
    ;;
  2)
    echo "Status: CRITICAL"
    echo "Bedeutung: Kritischer Zustand erkannt. Sofortige Prüfung oder Eskalation notwendig."
    echo "Exit-Code: 2 (CRITICAL für Monitoring-Systeme)"
    ;;
esac

exit "$STATUS"
