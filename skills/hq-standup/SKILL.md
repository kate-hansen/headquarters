---
name: hq-standup
description: Generate today's standup (Yesterday / Today / Blockers + Harvest) from Beads, Monday, PRs, and the calendar, as a dated headquarters note ready to paste into Slack. Use when Kate asks for her standup or "what's my standup".
argument-hint: "[optional date YYYY-MM-DD]"
---

Read [../hq/GUIDE.md](../hq/GUIDE.md) first.

A standup-only refresh for headquarters — lighter than `/hq-dashboard`, and it writes nothing to the Obsidian
vault (this replaces the old vault-based `standup` skill). It produces a dated note and prints it ready to paste.

## 1. Gather (default date = today, local)

- **Yesterday** = the previous **weekday** (Monday–Friday only; never a weekend). On a Monday, yesterday is
  Friday; after PTO, the last worked weekday — note intervening PTO. Covers: Monday items you moved to a done
  status, Beads issues you closed, and PRs you merged.
- **Today**: in-progress Beads and Monday items, plus today's calendar (Craft `kate.hansen@crafteducation.com` +
  Base 2 `khansen@base2.io`, Eastern) for context.
- **Blockers**: Blocked Monday items, Beads marked blocked or deferred, and open questions from the newest handoff.
- **Harvest**: yesterday's tracked time via the Harvest MCP (`list_time_entries`, `user_ids: [3006350]`,
  `rounded_hours`), summed by project → task with a day total. If Harvest isn't authenticated, leave the section
  out and say so.

PR scope: only PRs where you are a direct, individually-named reviewer (`user-review-requested:@me`) or the author
who merged — never team-routed review requests.

## 2. Write and print

Write `~/.headquarters/standups/YYYY-MM-DD.md` (create the folder):

```md
# Standup YYYY-MM-DD

**Yesterday**
- <one line each>

**Today**
- <one line each>

**Blockers**
- <one line each, or "None">

**Time (Harvest, yesterday)**
- <Project · Task> — <N>h
- Total: <N>h
```

Keep every bullet one line, plain language, teammate-facing. Then print the note to the terminal so it can be
pasted into Slack, and give its path. Blockers reads "None" when there are none; drop the Harvest section if
Harvest is unavailable.
