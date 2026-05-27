#!/usr/bin/env bash

nowplaying-cli next

# Force the timer to reset on next poll — LAST_REPORTED=-1 guarantees diff > 0.5
NOW=$(date +%s)
printf "BASE_ELAPSED=0\nBASE_WALL=%s\nLAST_REPORTED=-1\nLAST_RATE=1\nLAST_TITLE_HASH=\n" \
  "$NOW" > /tmp/sketchybar_timer_state
