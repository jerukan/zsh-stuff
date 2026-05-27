#!/usr/bin/env bash

PAGES=$(vm_stat)
FREE=$(echo "$PAGES" | awk '/Pages free/ {gsub(/\./, "", $3); print $3+0}')
INACTIVE=$(echo "$PAGES" | awk '/Pages inactive/ {gsub(/\./, "", $3); print $3+0}')
SPEC=$(echo "$PAGES" | awk '/Pages speculative/ {gsub(/\./, "", $3); print $3+0}')
TOTAL_MEM=$(sysctl -n hw.memsize)

AVAIL_BYTES=$(( (FREE + INACTIVE + SPEC) * 4096 ))
USED_GB=$(echo "scale=1; ($TOTAL_MEM - $AVAIL_BYTES) / 1073741824" | bc)
TOTAL_GB=$(( TOTAL_MEM / 1073741824 ))

sketchybar --set "$NAME" label="${USED_GB}/${TOTAL_GB}GB"
