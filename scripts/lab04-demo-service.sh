#!/usr/bin/env bash
set -u

MODE_FILE="/tmp/lab04-demo-service-mode"

echo "Lab04 demo service started at $(date -Is)"

if [ -f "$MODE_FILE" ]; then
  mode="$(cat "$MODE_FILE")"
else
  mode="ok"
fi

echo "Current mode: $mode"

if [ "$mode" = "fail" ]; then
  echo "Simulated failure: mode is fail"
  exit 42
fi

echo "Simulated success: service completed normally"
exit 0
