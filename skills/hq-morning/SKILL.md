---
name: hq-morning
description: Morning one-shot — generate today's standup and open the live dashboard in one go. Use when Kate runs /hq-morning to start her day.
disable-model-invocation: true
---

Read [../hq/GUIDE.md](../hq/GUIDE.md) first.

Runs the two morning skills back to back from a single data pull. Their sources overlap (Beads, Monday, PRs,
calendar, Harvest), so gather each source once and feed both — don't query twice.

## 1. Gather once

Pull the shared sources a single time:

- Today's **Beads** and your open **Monday** items, review-requested **PRs**, this week's **calendar**, and
  **yesterday's Harvest** time (yesterday = the previous **weekday**; skip weekends — on Monday, Friday).

The exact queries and board/column maps live in [../hq-dashboard/SKILL.md](../hq-dashboard/SKILL.md) §1; the
standup's Yesterday/Today/Blockers framing lives in [../hq-standup/SKILL.md](../hq-standup/SKILL.md) §1.

## 2. Standup

Follow [../hq-standup/SKILL.md](../hq-standup/SKILL.md) §2: write `~/.headquarters/standups/YYYY-MM-DD.md`
(Yesterday / Today / Blockers + Harvest) from the gathered data, and keep the text to print.

## 3. Dashboard

Follow [../hq-dashboard/SKILL.md](../hq-dashboard/SKILL.md) §2–3: render `~/.headquarters/dashboard/index.html`
from the same data and open it.

## 4. Hand off

Close with: the standup pasted in chat (ready for Slack), the dashboard's clickable `file://…/dashboard/index.html`
link, and one line on what most needs attention today.
