#!/usr/bin/env bash

RAW=$(nowplaying-cli get-raw 2>/dev/null)
TITLE=$(echo "$RAW" | jq -r '.kMRMediaRemoteNowPlayingInfoTitle // empty')

if [ -z "$TITLE" ]; then
  sketchybar --set media       drawing=off \
             --set media_timer drawing=off \
             --set media_prev  drawing=off \
             --set media_play  drawing=off \
             --set media_next  drawing=off
  exit 0
fi

ARTIST=$(echo "$RAW" | jq -r '.kMRMediaRemoteNowPlayingInfoArtist // empty')
RATE=$(echo "$RAW"   | jq -r '.kMRMediaRemoteNowPlayingInfoPlaybackRate // 0')

if [ -n "$ARTIST" ]; then
  LABEL="$ARTIST - $TITLE"
else
  LABEL="$TITLE"
fi
MAX=35
if [ ${#LABEL} -gt $MAX ]; then
  LABEL="${LABEL:0:$((MAX - 1))}…"
fi

if [ "$RATE" = "0" ] || [ "$RATE" = "0.0" ]; then
  PLAY_ICON="󰐊"
else
  PLAY_ICON="󰏤"
fi

sketchybar --set media       drawing=on label="$LABEL" \
           --set media_timer drawing=on \
           --set media_prev  drawing=on \
           --set media_play  drawing=on icon="$PLAY_ICON" \
           --set media_next  drawing=on
