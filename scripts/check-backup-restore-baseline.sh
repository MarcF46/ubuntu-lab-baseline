#!/usr/bin/env bash
set -u

fail=0
warn=0

section(){ printf "\n## %s\n" "$1"; }
ok(){ printf "[OK] %s\n" "$1"; }
warning(){ printf "[WARN] %s\n" "$1"; warn=1; }
critical(){ printf "[CRIT] %s\n" "$1"; fail=1; }

source_dir="docs/private/evidence/lab12-backup/test-source"
artifact_dir="docs/private/evidence/lab12-backup/artifacts"
restore_dir="docs/private/evidence/lab12-backup/restore-target"
archive_file="$artifact_dir/lab12-test-backup.tar.gz"
checksum_file="$artifact_dir/lab12-test-backup.sha256"
restored_dir="$restore_dir/$(basename "$source_dir")"

section "Backup / Restore Health Check"
printf "Zeitpunkt: %s\n" "$(date -Is)"

section "Werkzeuge"

for tool in tar gzip sha256sum diff find du df; do
  if command -v "$tool" >/dev/null 2>&1; then
    ok "$tool ist vorhanden."
  else
    critical "$tool fehlt."
  fi
done

section "Artefakte"

if [ -d "$source_dir" ]; then
  ok "Quell-Testverzeichnis vorhanden."
else
  critical "Quell-Testverzeichnis fehlt."
fi

if [ -d "$artifact_dir" ]; then
  ok "Artefakt-Verzeichnis vorhanden."
else
  critical "Artefakt-Verzeichnis fehlt."
fi

if [ -f "$archive_file" ]; then
  ok "Backup-Archiv vorhanden."
  printf "Archivgröße: %s\n" "$(du -h "$archive_file" | awk '{print $1}')"
else
  critical "Backup-Archiv fehlt."
fi

if [ -f "$checksum_file" ]; then
  ok "Prüfsummendatei vorhanden."
else
  critical "Prüfsummendatei fehlt."
fi

if [ -d "$restored_dir" ]; then
  ok "Restore-Verzeichnis vorhanden."
else
  critical "Restore-Verzeichnis fehlt."
fi

section "Dateizählung"

if [ -d "$source_dir" ]; then
  source_count="$(find "$source_dir" -type f | wc -l)"
else
  source_count="0"
fi

if [ -d "$restored_dir" ]; then
  restore_count="$(find "$restored_dir" -type f | wc -l)"
else
  restore_count="0"
fi

printf "Quelldateien: %s\n" "$source_count"
printf "Wiederhergestellte Dateien: %s\n" "$restore_count"

if [ "$source_count" = "$restore_count" ] && [ "$source_count" -gt 0 ]; then
  ok "Dateianzahl zwischen Quelle und Restore ist plausibel."
else
  critical "Dateianzahl zwischen Quelle und Restore ist nicht plausibel."
fi

section "Prüfsumme"

if [ -f "$checksum_file" ] && [ -f "$archive_file" ]; then
  if sha256sum --check "$checksum_file" >/tmp/lab12-sha-check.out 2>&1; then
    ok "Prüfsummenprüfung erfolgreich."
  else
    cat /tmp/lab12-sha-check.out
    critical "Prüfsummenprüfung fehlgeschlagen."
  fi
else
  critical "Prüfsummenprüfung nicht möglich, weil Archiv oder Prüfsummendatei fehlt."
fi

section "Restore-Vergleich"

if [ -d "$source_dir" ] && [ -d "$restored_dir" ]; then
  if diff -qr "$source_dir" "$restored_dir" >/tmp/lab12-restore-diff.out 2>&1; then
    ok "Quelle und Restore sind identisch."
  else
    cat /tmp/lab12-restore-diff.out
    critical "Quelle und Restore unterscheiden sich."
  fi
else
  critical "Restore-Vergleich nicht möglich, weil Quelle oder Restore-Verzeichnis fehlt."
fi

section "Speicherplatz"

root_usage="$(df -hT / | awk 'NR==2 {print $6}')"
root_free="$(df -hT / | awk 'NR==2 {print $5}')"

printf "Root-Dateisystem Belegung: %s\n" "$root_usage"
printf "Root-Dateisystem frei: %s\n" "$root_free"

case "$root_usage" in
  9[0-9]%|100%)
    warning "Root-Dateisystem ist stark belegt."
    ;;
  *)
    ok "Root-Dateisystem hat ausreichend Reserve für diesen Lab-Nachweis."
    ;;
esac

section "Ergebnis"

if [ "$fail" -ne 0 ]; then
  echo "[RESULT] Backup / Restore Health Check kritisch."
  exit 2
fi

if [ "$warn" -ne 0 ]; then
  echo "[RESULT] Backup / Restore Health Check erfolgreich mit Warnungen."
  exit 0
fi

echo "[RESULT] Backup / Restore Health Check erfolgreich."
exit 0
