#!/usr/bin/env bash

PAGES=$(vm_stat)
PAGE_SIZE=$(echo "$PAGES" | awk '/page size of/ {print $8}')
FREE=$(echo "$PAGES" | awk '/Pages free/ {gsub(/\./, "", $3); print $3+0}')
FILE_BACKED=$(echo "$PAGES" | awk '/File-backed pages/ {gsub(/\./, "", $3); print $3+0}')

TOTAL_MEM=$(sysctl -n hw.memsize)
AVAIL_BYTES=$(( (FREE + FILE_BACKED) * PAGE_SIZE ))
USED_GB=$(echo "scale=1; ($TOTAL_MEM - $AVAIL_BYTES) / 1073741824" | bc)
TOTAL_GB=$(( TOTAL_MEM / 1073741824 ))

# Swap: sysctl always reports in MB on macOS
SWAP_FIELD=$(sysctl vm.swapusage | awk -F'used = ' '{print $2}' | awk '{print $1}')
SWAP_NUM=$(echo "$SWAP_FIELD" | tr -d 'MG')
SWAP_UNIT=$(echo "$SWAP_FIELD" | grep -oE '[MG]' | tail -1)
if [ "$SWAP_UNIT" = "G" ]; then
    SWAP_GB=$(echo "scale=1; $SWAP_NUM / 1" | bc)
else
    SWAP_GB=$(echo "scale=1; $SWAP_NUM / 1024" | bc)
fi

sketchybar --set "$NAME" label="${USED_GB}/${TOTAL_GB}GB ↕${SWAP_GB}GB"
