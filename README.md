# Headquarters

Shared memory and workflow skills for agentic programming. Agents keep project knowledge, story-level working memory, and handoffs in `~/.headquarters`, outside every code repo, so any agent (Claude Code, Codex, ...) can pick up where another left off.

## Skills

| Skill | Invoked by | What it does |
|---|---|---|
| `hq` | you or the agent | Recall, remember, update, or forget memory. Holds [the guide](skills/hq/GUIDE.md) every other skill follows. |
| `hq-init` | you | Interactive questionnaire that sets up or refreshes a project's `project.md`. |
| `handoff` | you | Writes a dated handoff for the current story so a fresh session can continue. |
| `pickup` | you | Reads a story's handoff trail and briefs you before resuming. |

The skills form part of a story workflow: **fresh → working → in review → closed**. `/pickup` and `/handoff` move between fresh and working; review, start, and finish skills are planned.

## Install

The skills live in `skills/`. Link each one into your agent's skills folder.

**PowerShell (Windows):** directory junctions need no admin rights.

```powershell
$repo = "$HOME\source\repos\headquarters\skills"
foreach ($target in "$HOME\.claude\skills", "$HOME\.codex\skills") {
  foreach ($skill in "hq", "hq-init", "handoff", "pickup") {
    New-Item -ItemType Junction -Path "$target\$skill" -Target "$repo\$skill"
  }
}
```

**bash (macOS/Linux):**

```bash
repo=~/source/repos/headquarters/skills
for target in ~/.claude/skills ~/.codex/skills; do
  for skill in hq hq-init handoff pickup; do ln -s "$repo/$skill" "$target/$skill"; done
done
```

**Or with the skills CLI:** `npx skills add <github-user>/headquarters`.

The skills resolve `../hq/GUIDE.md` relative to themselves, so install all four side by side.

## Point your agents at it

Create `~/.headquarters/me.md` for your cross-project working preferences, then add this to `~/.claude/CLAUDE.md`:

```md
## Headquarters

Shared memory for projects and stories lives in `~/.headquarters`. Use the `hq` skill to recall or record what was learned; its GUIDE.md says where each kind of knowledge goes.

@~/.headquarters/me.md
```

Codex's `~/.codex/AGENTS.md` has no import syntax, so it names the file instead:

```md
## Headquarters

Shared memory for projects and stories lives in `~/.headquarters`. Use the `hq` skill to recall or record what was learned; its GUIDE.md says where each kind of knowledge goes. Read `~/.headquarters/me.md` at the start of every session: it holds the user's working preferences.
```

Then run `/hq-init` in each project you work on.
