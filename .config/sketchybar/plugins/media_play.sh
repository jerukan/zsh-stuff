#!/usr/bin/env bash

# Read current rate before toggling so we can flip the icon immediately
RAW=$(nowplaying-cli get-raw 2>/dev/null)
RATE=$(echo "$RAW" | jq -r '.kMRMediaRemoteNowPlayingInfoPlaybackRate // 0')

nowplaying-cli togglePlayPause

# Optimistically flip the icon without waiting for media.sh's next 3s poll
if [ "$RATE" = "0" ] || [ "$RATE" = "0.0" ]; then
  sketchybar --set media_play icon="󰏤"
else
  sketchybar --set media_play icon="󰐊"
fi
