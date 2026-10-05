# Harvest timesheet — daily reminder

The daily close-out layer of this workflow. A LaunchAgent nudges once per weekday afternoon to log
the day's time, then you run the timesheet skill in a real session.

**Credit:** the timesheet skills themselves (`harvest-timesheet`, `refresh-harvest-projects`,
`weekly-harvest-report`, `monthly-harvest-report`) are **[nothingalike/harvest-skills](https://github.com/nothingalike/harvest-skills)** — same author as headquarters. This folder is only the reminder layer on top of them.

## What's here

- `check.sh` — fires the reminder. Runs hourly, no-ops before 3:45pm ET and after it has already
  reminded today, so it nudges at most once per Eastern day (a closed laptop at 3:45 is still caught
  later). It only posts a macOS notification pointing at `/harvest-timesheet`; it never writes to
  Harvest unattended — logging needs your input for hours.
- `com.kate.harvest-345pm-check.plist` — the LaunchAgent that runs `check.sh` on login and hourly.

## Install

```bash
# 1. Put the script where the LaunchAgent expects it
mkdir -p ~/.config/harvest-timesheet
cp reminders/harvest-timesheet/check.sh ~/.config/harvest-timesheet/check.sh
chmod +x ~/.config/harvest-timesheet/check.sh

# 2. Load the LaunchAgent
cp reminders/harvest-timesheet/com.kate.harvest-345pm-check.plist ~/Library/LaunchAgents/
launchctl unload ~/Library/LaunchAgents/com.kate.harvest-345pm-check.plist 2>/dev/null
launchctl load ~/Library/LaunchAgents/com.kate.harvest-345pm-check.plist

# Dry-run the reminder logic any time:
~/.config/harvest-timesheet/check.sh --dry
```

The script keeps its state (`last-run` stamp, `check.log`) in `~/.config/harvest-timesheet/`, outside
this repo. The plist uses absolute `/Users/katehansen` paths; adjust them if the home directory changes.
