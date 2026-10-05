#!/bin/bash
# Harvest timesheet — 3:45pm ET daily reminder.
#
# Nudges toward the `harvest-timesheet` skill from nothingalike/harvest-skills
# (https://github.com/nothingalike/harvest-skills). This script and its LaunchAgent are the
# reminder layer that sits on top of those skills; see ../README.md.
#
# Why: Kate wants a nudge at 3:45pm Eastern to make sure the day is fully logged. This LaunchAgent
# fires hourly and no-ops outside its window, so a closed laptop at exactly 3:45pm is still caught
# later the same afternoon.
#
# It only REMINDS — it posts a macOS notification. Kate runs /harvest-timesheet in a real session
# to gather, compare against Harvest, and log. (Logging needs her input for hours, and an
# unattended agent that could write to Harvest is deliberately avoided.)
#
# Guards (so it fires once per ET day, on/after 3:45pm):
#   - do nothing before 15:45 America/New_York
#   - do nothing if the local stamp already says today (ET date)
set -u

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin"

STATE_DIR="$HOME/.config/harvest-timesheet"
STAMP="$STATE_DIR/last-run"
LOG="$STATE_DIR/check.log"
mkdir -p "$STATE_DIR"

log() { echo "[$(date '+%F %T %Z')] $*" >> "$LOG"; }

TODAY="$(TZ='America/New_York' date +%F)"
HOUR="$((10#$(TZ='America/New_York' date +%H)))"   # base-10 so "09" isn't octal
MIN="$((10#$(TZ='America/New_York' date +%M)))"

DRY=0
[ "${1:-}" = "--dry" ] && DRY=1

# Fire at or after 15:45 ET.
if [ "$HOUR" -lt 15 ] || { [ "$HOUR" -eq 15 ] && [ "$MIN" -lt 45 ]; }; then
  log "skip: before 3:45pm ET (hour=$HOUR min=$MIN)"
  exit 0
fi

LAST="$(tr -d '[:space:]' < "$STAMP" 2>/dev/null)"
if [ "$LAST" = "$TODAY" ]; then
  log "skip: already reminded today (stamp=$LAST)"
  exit 0
fi

if [ "$DRY" = "1" ]; then
  log "DRY: would remind (stamp='$LAST', today=$TODAY, hour=$HOUR)"
  echo "would-remind (stamp='$LAST' today=$TODAY hour=$HOUR)"
  exit 0
fi

log "remind: stamp='$LAST' != today=$TODAY, hour=$HOUR -> posting notification"
if osascript -e 'display notification "Run /harvest-timesheet to log anything left for today (target ~8h)." with title "Timesheet check — 3:45pm" sound name "Glass"' >> "$LOG" 2>&1; then
  echo "$TODAY" > "$STAMP"
  log "remind: OK — stamped $TODAY"
else
  rc=$?
  log "remind: FAILED (exit $rc) — no stamp written, will retry next cycle"
fi
