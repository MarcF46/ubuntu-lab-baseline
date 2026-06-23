#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="setup-terminal-operator-profile.sh"
BACKUP_DIR="${HOME}/.terminal-operator-profile-backups"
BASHRC="${HOME}/.bashrc"
INPUTRC="${HOME}/.inputrc"

BASHRC_START="# >>> terminal-operator-profile >>>"
BASHRC_END="# <<< terminal-operator-profile <<<"
INPUTRC_START="# >>> terminal-operator-profile >>>"
INPUTRC_END="# <<< terminal-operator-profile <<<"

usage() {
  cat <<USAGE
Usage:
  $SCRIPT_NAME --status
  $SCRIPT_NAME --install
  $SCRIPT_NAME --remove

Purpose:
  Installs a per-user terminal operator profile:
  - Bash history timestamps
  - safer multi-line paste support via bracketed paste
  - history append/sync behavior
  - two-line timestamped Bash prompt

Enterprise note:
  This script modifies only the current user's ~/.bashrc and ~/.inputrc.
  It does not modify /etc/bash.bashrc or global system configuration.
USAGE
}

backup_file() {
  local file="$1"

  mkdir -p "$BACKUP_DIR"

  if [ -f "$file" ]; then
    cp "$file" "$BACKUP_DIR/$(basename "$file").$(date +%Y%m%d-%H%M%S).bak"
    echo "[OK] Backup erstellt: $file"
  else
    touch "$file"
    echo "[OK] Datei neu angelegt: $file"
  fi
}

remove_block() {
  local file="$1"
  local start_marker="$2"
  local end_marker="$3"
  local tmp_file

  tmp_file="$(mktemp)"

  awk -v start="$start_marker" -v end="$end_marker" '
    $0 == start {skip=1; next}
    $0 == end {skip=0; next}
    skip != 1 {print}
  ' "$file" > "$tmp_file"

  cat "$tmp_file" > "$file"
  rm -f "$tmp_file"
}

append_bashrc_block() {
  cat >> "$BASHRC" <<'BASHRC_BLOCK'

# >>> terminal-operator-profile >>>
# Per-user terminal operator profile.
# Purpose: command timestamps, safer paste behavior, clearer prompt.
# Scope: current user only.

# Store timestamps for Bash history output.
export HISTTIMEFORMAT='%F %T  '

# Keep a larger but still bounded history.
export HISTSIZE=20000
export HISTFILESIZE=40000

# Avoid duplicate history lines and allow leading-space commands to be ignored.
export HISTCONTROL=ignoreboth:erasedups

# Append to history instead of overwriting it.
shopt -s histappend

# Write history after each command and reload history from other sessions.
__terminal_operator_history_sync() {
  history -a
  history -n
}

case ";${PROMPT_COMMAND:-};" in
  *";__terminal_operator_history_sync;"*) ;;
  *) PROMPT_COMMAND="__terminal_operator_history_sync${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac
export PROMPT_COMMAND

# Two-line prompt with timestamp.
# Example:
# [2026-06-23 10:23:11] user@host:/path
# $
if [[ $- == *i* ]]; then
  PS1='\n[\D{%F %T}] \u@\h:\w\n\$ '
fi
# <<< terminal-operator-profile <<<
BASHRC_BLOCK
}

append_inputrc_block() {
  cat >> "$INPUTRC" <<'INPUTRC_BLOCK'

# >>> terminal-operator-profile >>>
# Safer multi-line paste handling for readline-based shells.
set enable-bracketed-paste on
# <<< terminal-operator-profile <<<
INPUTRC_BLOCK
}

status() {
  echo "## Terminal Operator Profile Status"

  echo
  echo "Bash-Konfiguration:"
  if grep -qxF "$BASHRC_START" "$BASHRC" 2>/dev/null; then
    echo "[OK] ~/.bashrc enthält Terminal Operator Profile."
  else
    echo "[INFO] ~/.bashrc enthält Terminal Operator Profile noch nicht."
  fi

  echo
  echo "Readline-Konfiguration:"
  if grep -qxF "$INPUTRC_START" "$INPUTRC" 2>/dev/null; then
    echo "[OK] ~/.inputrc enthält bracketed paste Konfiguration."
  else
    echo "[INFO] ~/.inputrc enthält bracketed paste Konfiguration noch nicht."
  fi

  echo
  echo "Aktuelle Shell-Werte:"
  echo "HISTTIMEFORMAT: ${HISTTIMEFORMAT:-nicht_gesetzt}"
  echo "HISTSIZE: ${HISTSIZE:-nicht_gesetzt}"
  echo "HISTFILESIZE: ${HISTFILESIZE:-nicht_gesetzt}"
  echo "HISTCONTROL: ${HISTCONTROL:-nicht_gesetzt}"

  echo
  echo "Hinweis:"
  echo "Nach --install ein neues Terminal öffnen oder 'source ~/.bashrc' ausführen."
}

install_profile() {
  echo "## Terminal Operator Profile installieren"

  backup_file "$BASHRC"
  backup_file "$INPUTRC"

  remove_block "$BASHRC" "$BASHRC_START" "$BASHRC_END"
  remove_block "$INPUTRC" "$INPUTRC_START" "$INPUTRC_END"

  append_bashrc_block
  append_inputrc_block

  echo
  echo "[DONE] Installation abgeschlossen."
  echo "Neues Terminal öffnen oder ausführen: source ~/.bashrc"
}

remove_profile() {
  echo "## Terminal Operator Profile entfernen"

  backup_file "$BASHRC"
  backup_file "$INPUTRC"

  remove_block "$BASHRC" "$BASHRC_START" "$BASHRC_END"
  remove_block "$INPUTRC" "$INPUTRC_START" "$INPUTRC_END"

  echo
  echo "[DONE] Profil entfernt."
  echo "Neues Terminal öffnen oder ausführen: source ~/.bashrc"
}

case "${1:-}" in
  --status)
    status
    ;;
  --install)
    install_profile
    ;;
  --remove)
    remove_profile
    ;;
  -h|--help|"")
    usage
    ;;
  *)
    echo "[ERROR] Unbekannte Option: $1" >&2
    usage
    exit 1
    ;;
esac
