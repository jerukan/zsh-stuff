#!/usr/bin/env bash

STATE=/tmp/sketchybar_timer_state

RAW=$(nowplaying-cli get-raw 2>/dev/null)
TITLE=$(echo "$RAW" | jq -r '.kMRMediaRemoteNowPlayingInfoTitle // empty')

if [ -z "$TITLE" ]; then
  rm -f "$STATE"
  sketchybar --set "$NAME" label="0:00/0:00"
  exit 0
fi

CUR_REPORTED=$(echo "$RAW" | jq -r '.kMRMediaRemoteNowPlayingInfoElapsedTime // 0')
CUR_RATE=$(echo "$RAW"     | jq -r '.kMRMediaRemoteNowPlayingInfoPlaybackRate // 0')
CUR_DUR=$(echo "$RAW"      | jq -r '.kMRMediaRemoteNowPlayingInfoDuration // 0')
CUR_TITLE_HASH=$(printf '%s' "$TITLE" | md5)
NOW=$(date +%s)

# Defaults before loading saved state
BASE_ELAPSED=0
BASE_WALL=$NOW
LAST_REPORTED="-1"
LAST_RATE="$CUR_RATE"
LAST_TITLE_HASH=""

# shellcheck source=/dev/null
[ -f "$STATE" ] && source "$STATE"

REPORTED_CHANGED=$(awk "BEGIN {
  d = $CUR_REPORTED - ($LAST_REPORTED)
  if (d < 0) d = -d
  print (d > 0.5) ? 1 : 0
}")

TITLE_CHANGED=0
[ "$CUR_TITLE_HASH" != "$LAST_TITLE_HASH" ] && TITLE_CHANGED=1

RATE_CHANGED=0
[ "$CUR_RATE" != "$LAST_RATE" ] && RATE_CHANGED=1

if [ "$TITLE_CHANGED" = "1" ] || [ "$REPORTED_CHANGED" = "1" ]; then
  # New song or MediaRemote pushed a real elapsed update (seek, app-reported pause)
  BASE_ELAPSED=$CUR_REPORTED
  BASE_WALL=$NOW
elif [ "$RATE_CHANGED" = "1" ]; then
  # Play/pause without a MediaRemote elapsed update (e.g. YouTube in Firefox)
  BASE_ELAPSED=$(awk "BEGIN { printf \"%.2f\", $BASE_ELAPSED + ($NOW - $BASE_WALL) * $LAST_RATE }")
  BASE_WALL=$NOW
fi

printf "BASE_ELAPSED=%s\nBASE_WALL=%s\nLAST_REPORTED=%s\nLAST_RATE=%s\nLAST_TITLE_HASH=%s\n" \
  "$BASE_ELAPSED" "$BASE_WALL" "$CUR_REPORTED" "$CUR_RATE" "$CUR_TITLE_HASH" > "$STATE"

ACTUAL=$(awk "BEGIN {
  e = $BASE_ELAPSED + ($NOW - $BASE_WALL) * $CUR_RATE
  if (e < 0)        e = 0
  if (e > $CUR_DUR) e = $CUR_DUR
  printf \"%.0f\", e
}")
DUR=$(awk "BEGIN { printf \"%.0f\", $CUR_DUR }")

fmt() { printf "%d:%02d" $(($1 / 60)) $(($1 % 60)); }

sketchybar --set "$NAME" label="$(fmt "$ACTUAL")/$(fmt "$DUR")"
