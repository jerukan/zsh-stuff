#!/usr/bin/env bash

STATE=/tmp/sketchybar_timer_state

ACTUAL=0
LAST_RATE=1
if [ -f "$STATE" ]; then
  # shellcheck source=/dev/null
  source "$STATE"
  NOW=$(date +%s)
  ACTUAL=$(awk "BEGIN { printf \"%.0f\", $BASE_ELAPSED + ($NOW - $BASE_WALL) * $LAST_RATE }")
fi

NOW=$(date +%s)
if [ "$ACTUAL" -gt 5 ] 2>/dev/null; then
  nowplaying-cli seek 0
else
  nowplaying-cli previous
fi

# Force the timer to reset on next poll regardless of which branch ran
printf "BASE_ELAPSED=0\nBASE_WALL=%s\nLAST_REPORTED=-1\nLAST_RATE=%s\nLAST_TITLE_HASH=\n" \
  "$NOW" "$LAST_RATE" > "$STATE"
