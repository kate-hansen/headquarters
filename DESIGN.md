# Headquarters — Kate's adaptation design

This is a fork of **[nothingalike/headquarters](https://github.com/nothingalike/headquarters)** — full credit to
nothingalike for the system and the skills. This doc records how the fork is being adapted to Kate Hansen's
workflow. Upstream stays wired as the `upstream` git remote so his future updates can be pulled in.

## Goal

Make Headquarters Kate's **primary work dashboard and cross-repo memory**, while keeping the processes that
already work. The heaviest change is on the Obsidian side: the current vault + `vault-sync` stack is replaced by
an HQ-native HTML dashboard.

## Decisions (locked)

1. **Public fork** at `kate-hansen/headquarters`, crediting upstream.
2. **Drop the audio daily brief** entirely.
3. **Start minimal**, grow from there.
4. This design doc lives in the repo (here), linked from the README.

## What Headquarters is (upstream)

Seven skills plus a memory root at `~/.headquarters` (outside every code repo):

| Skill | Role |
|---|---|
| `hq` | recall / remember / update / forget memory; holds the shared `GUIDE.md` |
| `hq-setup` | once per machine: create `~/.headquarters`, write `me.md`, point agents at it |
| `hq-init` | once per project: questionnaire → `project.md` |
| `hq-handoff` / `hq-pickup` | write / read dated session handoffs |
| `hq-review` | per-slice HTML report, each claim linked to a file:line in VS Code |
| `hq-artifact-design` | house style for the HTML reports |

In this fork every skill carries an `hq-` prefix (upstream left `handoff` / `pickup` / `review` bare). This
avoids colliding with the `handoff` trigger in `orca-cli` / `orchestration` and with the `code-review` family,
and reads as one `/hq-*` command family. Cost: those renamed files won't auto-merge upstream changes — port
them by hand on a `git pull upstream main`.

Out of the box there is **no cross-project dashboard** — that's the main thing this fork adds.

## Architecture — keep / adapt / replace

| Current piece | Fate | Notes |
|---|---|---|
| Beads (`bd`) tracker | **Keep** | HQ story resolution rewired to Beads/Monday IDs instead of `pmt` |
| `.claude/.../memory/` per-fact memory | **Keep** | Stays the recall store; HQ owns `project.md`, handoffs, reviews, dashboard |
| "Kate owns commit/push" | **Keep** | Already matches HQ's "the user commits" rule |
| `/code-review` + review-findings mod | **Keep** | HQ `/hq-review` is the narrative HTML layer; wires into `/code-review` |
| Branch `feat/<slug>` | **Keep, adapt HQ** | HQ assumes a story ID in the branch; relax that, resolve story from Beads/arg |
| Obsidian vault + `vault-sync` | **Replace** | New `hq-dashboard` skill renders the same data as HQ HTML |
| Audio daily brief | **Drop** | Removed |
| `~/.claude/CLAUDE.md` | **Append only** | HQ adds a `## Headquarters` block + `@~/.headquarters/me.md` import; diff shown before writing |

## v1 dashboard scope (minimal)

A single HTML page at `~/.headquarters/dashboard/index.html`, styled by `hq-artifact-design`, showing just:

- **Projects** — the `~/.headquarters/<project>` folders and their state.
- **Review-requested PRs** — GitHub `user-review-requested:@me` (login `kate-hansen`, org `ce-software`, repos craft + recraft).
- **Today's Beads** — open/active items from `bd`.

Everything else from the old Obsidian dashboard (calendar, Harvest, standup blending, topic foldering) is
deferred until v1 feels right.

## Obsidian reshape

- New `hq-dashboard` skill aggregates across HQ projects + live sources (GitHub, Beads; Monday/Harvest/Calendar
  later) into the HTML page above.
- Existing `standup` / `weekly-harvest` / `meeting-synopsis` skills feed HQ instead of writing vault markdown.
- The Obsidian vault becomes a **read-only archive** — nothing is deleted. Human-curated content (`## My Notes`,
  `## 📝 Scratchpad`, `REFERENCE/`, `PERSONAL/`) is migrated deliberately if/when the vault is retired.

## "Adapt to me" skill edits

- `hq-init` + `GUIDE.md`: swap `pmt` story resolution for **Beads / Monday**; drop the branch-must-carry-an-ID assumption.
- `me.md` seed: commit ownership, report-every-write, `feat/<slug>` naming, "RTFM over the simplest fix".
- `hq-review`: wire to `/code-review` + the review-findings mod.
- Add the `hq-dashboard` skill.
- Prefix the three bare skills (`handoff` / `pickup` / `review`) as `hq-*`.

## Install footprint (deferred — needs an explicit go)

Not done yet. When greenlit, installing will:

- Symlink the repo's `skills/*` into `~/.claude/skills/` (editing the repo = live skill changes, tracked in git).
- Create `~/.headquarters/` with `me.md` and per-project folders.
- Append one `## Headquarters` section to `~/.claude/CLAUDE.md` (diff shown first).

Nothing is written under any code repo — HQ lives outside them by design.

## Status

- [x] Fork created, upstream wired, design doc captured
- [ ] Adapt skills (`pmt` → Beads, branch handling, `me.md` seed, `review` wiring)
- [ ] Build `hq-dashboard` v1
- [ ] Install on the machine (symlinks, `~/.headquarters`, CLAUDE.md append)
- [ ] Retire / archive the Obsidian vault
