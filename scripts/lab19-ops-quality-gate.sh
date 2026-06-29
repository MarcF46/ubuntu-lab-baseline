#!/usr/bin/env bash
# Lab19 Ops-Quality-Gate für den Lab18-Monitoring-Agenten.
# Dieses Skript prüft typische Fehler vor Commit, Deployment oder produktionsnahem Betrieb.
# Es ist absichtlich lesbar geschrieben, damit die Prüflogik auch offline nachvollziehbar bleibt.

set -u
# Beendet das Skript bei Nutzung nicht gesetzter Variablen.

set -o pipefail
# Sorgt dafür, dass Fehler innerhalb von Pipelines nicht still verschluckt werden.

overall_status=0
# Speichert den Gesamtstatus: 0=OK, 1=WARNING, 2=CRITICAL.

project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
# Ermittelt das Git-Repository-Wurzelverzeichnis oder nutzt das aktuelle Verzeichnis als Fallback.

agent_script="scripts/lab18-monitoring-agent-safe.sh"
# Definiert den erwarteten relativen Pfad zum Monitoring-Agent-Skript.

service_unit="systemd/user/lab18-monitoring-agent.service"
# Definiert den erwarteten relativen Pfad zur systemd-User-Service-Unit.

timer_unit="systemd/user/lab18-monitoring-agent.timer"
# Definiert den erwarteten relativen Pfad zur systemd-User-Timer-Unit.

installed_service_unit="$HOME/.config/systemd/user/lab18-monitoring-agent.service"
# Definiert den erwarteten Pfad der installierten User-Service-Unit.

installed_timer_unit="$HOME/.config/systemd/user/lab18-monitoring-agent.timer"
# Definiert den erwarteten Pfad der installierten User-Timer-Unit.

expected_execstart="ExecStart=%h/projects/ubuntu-lab-baseline/scripts/lab18-monitoring-agent-safe.sh"
# Definiert die erwartete ExecStart-Zeile der Service-Unit.

expected_timer_unit="Unit=lab18-monitoring-agent.service"
# Definiert die erwartete Unit-Zeile der Timer-Unit.

verify_log="/tmp/lab19-ops-quality-gate-systemd-verify.log"
# Definiert eine temporäre Logdatei für systemd-analyze verify.

smoke_log="/tmp/lab19-ops-quality-gate-agent-smoke.log"
# Definiert eine temporäre Logdatei für den Agent-Smoke-Test.

cd "$project_root" || exit 2
# Wechselt ins Repository-Wurzelverzeichnis; bricht kritisch ab, wenn das nicht funktioniert.

print_section() {
  # Gibt eine klar erkennbare Abschnittsüberschrift aus.
  printf '\n== %s ==\n' "$1"
  # Schreibt die übergebene Überschrift mit Leerzeile davor.
}

mark_ok() {
  # Gibt eine OK-Meldung aus.
  printf 'OK: %s\n' "$1"
  # Schreibt die konkrete OK-Beschreibung.
}

mark_warning() {
  # Gibt eine WARNING-Meldung aus.
  printf 'WARNING: %s\n' "$1"
  # Schreibt die konkrete WARNING-Beschreibung.
  if [ "$overall_status" -lt 1 ]; then overall_status=1; fi
  # Hebt den Gesamtstatus mindestens auf WARNING.
}

mark_critical() {
  # Gibt eine CRITICAL-Meldung aus.
  printf 'CRITICAL: %s\n' "$1"
  # Schreibt die konkrete CRITICAL-Beschreibung.
  overall_status=2
  # Hebt den Gesamtstatus auf CRITICAL.
}

print_section "Repository-Kontext"
# Beginnt die Prüfung des Repository-Kontexts.

printf 'Projektwurzel: %s\n' "$project_root"
# Gibt die erkannte Projektwurzel aus.

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then mark_ok "Git-Repository erkannt"; else mark_critical "Kein Git-Repository erkannt"; fi
# Prüft, ob das Skript innerhalb eines Git-Repositorys läuft.

print_section "Dateien und Rechte"
# Beginnt die Prüfung wichtiger Dateien und Rechte.

if [ -f "$agent_script" ]; then mark_ok "Agent-Skript vorhanden: $agent_script"; else mark_critical "Agent-Skript fehlt: $agent_script"; fi
# Prüft, ob das Agent-Skript vorhanden ist.

if [ -x "$agent_script" ]; then mark_ok "Agent-Skript ist ausführbar"; else mark_critical "Agent-Skript ist nicht ausführbar"; fi
# Prüft, ob das Agent-Skript ausführbar ist.

if [ -f "$service_unit" ]; then mark_ok "Service-Unit vorhanden: $service_unit"; else mark_critical "Service-Unit fehlt: $service_unit"; fi
# Prüft, ob die Service-Unit im Repository vorhanden ist.

if [ -f "$timer_unit" ]; then mark_ok "Timer-Unit vorhanden: $timer_unit"; else mark_critical "Timer-Unit fehlt: $timer_unit"; fi
# Prüft, ob die Timer-Unit im Repository vorhanden ist.

print_section "Bash-Syntax"
# Beginnt die Bash-Syntaxprüfung.

if [ -f "$agent_script" ] && bash -n "$agent_script"; then mark_ok "Agent-Skript besteht bash -n"; else mark_critical "Agent-Skript fällt bei bash -n durch"; fi
# Prüft die Bash-Syntax des Agent-Skripts.

if bash -n "$0"; then mark_ok "Quality-Gate-Skript besteht bash -n"; else mark_critical "Quality-Gate-Skript fällt bei bash -n durch"; fi
# Prüft die Bash-Syntax des Quality-Gate-Skripts selbst.

print_section "Rechtehygiene"
# Beginnt die Prüfung auf unerwünschte Rechteausweitung.

if [ -f "$agent_script" ] && grep -nE '(^|[^[:alnum:]_])sudo([^[:alnum:]_]|$)' "$agent_script" >/dev/null 2>&1; then mark_warning "Agent-Skript enthält sudo und benötigt Rechtemodell-Prüfung"; else mark_ok "Agent-Skript enthält kein sudo"; fi
# Prüft, ob das Agent-Skript sudo verwendet.

print_section "systemd-Unit-Inhalte"
# Beginnt die inhaltliche Prüfung der Unit-Dateien.

if [ -f "$service_unit" ] && grep -Fx "$expected_execstart" "$service_unit" >/dev/null 2>&1; then mark_ok "ExecStart zeigt im Repository auf das erwartete Agent-Skript"; else mark_critical "ExecStart im Repository weicht vom erwarteten Agent-Skript ab"; fi
# Prüft die erwartete ExecStart-Zeile in der Service-Unit.

if [ -f "$timer_unit" ] && grep -Fx "$expected_timer_unit" "$timer_unit" >/dev/null 2>&1; then mark_ok "Timer triggert im Repository den erwarteten Service"; else mark_critical "Timer triggert im Repository nicht den erwarteten Service"; fi
# Prüft die erwartete Unit-Zeile in der Timer-Unit.

print_section "Installierte User-Units"
# Beginnt die Prüfung der installierten User-Units.

if [ -f "$installed_service_unit" ]; then mark_ok "Installierte Service-Unit vorhanden"; else mark_warning "Installierte Service-Unit fehlt im User-Kontext"; fi
# Prüft, ob die User-Service-Unit installiert ist.

if [ -f "$installed_timer_unit" ]; then mark_ok "Installierte Timer-Unit vorhanden"; else mark_warning "Installierte Timer-Unit fehlt im User-Kontext"; fi
# Prüft, ob die User-Timer-Unit installiert ist.

if [ -f "$installed_service_unit" ] && cmp -s "$service_unit" "$installed_service_unit"; then mark_ok "Installierte Service-Unit entspricht dem Repository-Sollzustand"; elif [ -f "$installed_service_unit" ]; then mark_warning "Installierte Service-Unit weicht vom Repository-Sollzustand ab"; fi
# Vergleicht installierte Service-Unit mit Repository-Sollzustand.

if [ -f "$installed_timer_unit" ] && cmp -s "$timer_unit" "$installed_timer_unit"; then mark_ok "Installierte Timer-Unit entspricht dem Repository-Sollzustand"; elif [ -f "$installed_timer_unit" ]; then mark_warning "Installierte Timer-Unit weicht vom Repository-Sollzustand ab"; fi
# Vergleicht installierte Timer-Unit mit Repository-Sollzustand.

print_section "systemd-Analyse"
# Beginnt die systemd-Unit-Verifikation.

: > "$verify_log"
# Leert die temporäre systemd-Verify-Logdatei.

if systemd-analyze verify --user "$service_unit" "$timer_unit" >"$verify_log" 2>&1; then mark_ok "systemd-analyze verify beendet ohne kritischen Rückgabefehler"; else mark_warning "systemd-analyze verify meldet einen Rückgabefehler"; fi
# Führt systemd-analyze verify für Service- und Timer-Unit aus.

if [ -s "$verify_log" ]; then sed -n '1,80p' "$verify_log"; else mark_ok "systemd-analyze verify erzeugte keine Detailmeldungen"; fi
# Zeigt Details aus systemd-analyze verify, falls welche vorhanden sind.

print_section "Private Rohdaten und Git-Hygiene"
# Beginnt die Prüfung privater Rohdaten und Git-Hygiene.

if git ls-files docs/private | grep . >/dev/null 2>&1; then mark_critical "Private Rohdaten unter docs/private sind von Git getrackt"; else mark_ok "Keine getrackten Dateien unter docs/private erkannt"; fi
# Prüft, ob private Rohdaten versehentlich getrackt werden.

if git diff --cached --name-only | grep '^docs/private/' >/dev/null 2>&1; then mark_critical "Private Rohdaten sind aktuell staged"; else mark_ok "Keine privaten Rohdaten staged"; fi
# Prüft, ob private Rohdaten versehentlich im Git-Staging liegen.

if git status --short --untracked-files=all | grep . >/dev/null 2>&1; then mark_warning "Git-Arbeitsstand enthält offene Änderungen oder untracked Dateien"; else mark_ok "Git-Arbeitsstand ist sauber"; fi
# Prüft, ob das Arbeitsverzeichnis sauber ist.

print_section "Agent-Smoke-Test"
# Beginnt den einfachen Funktionslauf des Agenten.

: > "$smoke_log"
# Leert die temporäre Agent-Smoke-Test-Logdatei.

if [ -x "$agent_script" ] && "$agent_script" >"$smoke_log" 2>&1; then mark_ok "Agent-Smoke-Test erfolgreich"; else mark_warning "Agent-Smoke-Test meldet Auffälligkeiten"; fi
# Führt den Agenten direkt aus und bewertet den Exit-Code.

sed -n '1,120p' "$smoke_log"
# Zeigt die ersten 120 Zeilen des Smoke-Test-Ergebnisses.

print_section "Gesamtbewertung"
# Beginnt die Gesamtbewertung des Quality Gates.

if [ "$overall_status" -eq 0 ]; then printf 'Status: OK\n'; fi
# Gibt Status OK aus, wenn keine Warnung oder kritische Meldung aufgetreten ist.

if [ "$overall_status" -eq 1 ]; then printf 'Status: WARNING\n'; fi
# Gibt Status WARNING aus, wenn mindestens eine Warnung aufgetreten ist.

if [ "$overall_status" -eq 2 ]; then printf 'Status: CRITICAL\n'; fi
# Gibt Status CRITICAL aus, wenn mindestens eine kritische Meldung aufgetreten ist.

printf 'Exit-Code: %s\n' "$overall_status"
# Gibt den numerischen Exit-Code für Automatisierung aus.

exit "$overall_status"
# Beendet das Quality Gate mit dem Gesamtstatus.
