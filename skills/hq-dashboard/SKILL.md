---
name: hq-dashboard
description: Open one HTML dashboard across all your projects — headquarters projects, pull requests awaiting your review, and today's Beads issues. Use when the user asks for their dashboard, "what's on my plate", a cross-project status, or what needs their attention today.
argument-hint: "[optional: a single project slug to focus on]"
---

Read [../hq/GUIDE.md](../hq/GUIDE.md) and [../hq-artifact-design/SKILL.md](../hq-artifact-design/SKILL.md) first.

One page that answers "what needs me right now" across every project, in headquarters' house style. It reads
live each time; it stores nothing. Start minimal (the four panels below) and add panels only when asked.

## 1. Gather the data

Collect four things. A source that errors or is empty yields an empty panel, never a failure.

1. **Projects** — every `~/.headquarters/<slug>/project.md`. For each, take the project name (its `# ` heading)
   and count open stories under `~/.headquarters/<slug>/stories/` that have a newest handoff. With an argument,
   limit to that one slug.
2. **PRs awaiting your review** — `gh search prs "is:open is:pr user-review-requested:@me" --json number,title,url,repository,createdAt`.
   These are *direct* review requests only (matches the user's "my face on it" rule). Compute a short age from
   `createdAt` (e.g. `2d`).
3. **Today's Beads** — in each project repo that has a `.beads/`, run `bd list --json`. Keep open and in-progress
   issues assigned to the user or unassigned; drop gates and templates. Take `id`, `title`, `status`, `priority`,
   `issue_type`. Sort by priority, then status (in-progress first).
4. **Monday — your open items** — via the Monday MCP (`mcp__monday-mcp__get_board_items_page`), fetch items where
   you are the **assignee** on each board below. Filter the people column with `compareValue: ["assigned_to_me"]`
   (the literal string, not a bare user id). Drop only the done/abandoned statuses — `done`, `dev done`,
   `deployed`, `resolved`, `won't do`, `won't fix`, `closed`, `complete`, `duplicate` (case-insensitive) — and keep
   every other status (backlog, to do, in progress, blocked, triage, …). Take `name`, `url`, the status text, and
   `updated_at`; compute a short age. Sort newest-updated first.

   | Board | id | assignee column | status column |
   |---|---|---|---|
   | Stories | 9975998815 | `multiple_person_mkvnfxy3` | `task_status` |
   | a11y Tracker | 18409413937 | `multiple_person_mm2k5d02` | `color_mm2kx6` |
   | Tracker Bugs Queue | 18420291482 | `multiple_person_mm2txhjz` | `bug_status` |
   | Tracker Pod subitems | 18420290753 | `person` | `status` |

   The boards don't set Monday's `is_done` flag reliably (some mark `Resolved` as not-done), so filter on the status
   *text* above, never on `is_done`. There is no recency cut-off — an open item shows however old it is.

## 2. Build the data block

Shape the data exactly like the `#dashboard-data` example in [template.html](template.html):

| Field | Holds |
|---|---|
| `generated` | Local `YYYY-MM-DD HH:MM`. |
| `projects[]` | `slug`, `title`, `path` (absolute `project.md`), `openStories`, optional `note` (one line). |
| `prs[]` | `repo` (`org/name`), `number`, `title`, `url`, `age`. |
| `beads[]` | `id`, `title`, `status`, `priority`, `type`, optional `repo`. |
| `monday[]` | `board` (short label), `title`, `url`, `status`, `age`. |

Leave an array empty when a source has nothing; the page hides nothing but shows an empty-state line.

## 3. Write and open

1. Copy [template.html](template.html) to `~/.headquarters/dashboard/index.html` (create the folder).
2. Replace the JSON inside `<script type="application/json" id="dashboard-data">` with this run's data, and change
   nothing else. Inside that block, write every `</` as `<\/`.
3. Hand it over the way the guide describes: `open` it, and give the clickable `file:///…/dashboard/index.html`
   link. Then say in one line what most needs attention (the oldest PR, or the highest-priority bead).

The page links each project's `project.md` with a `vscode://` link and each PR to GitHub, so it stays useful
whether the user acts from the editor or the browser.
