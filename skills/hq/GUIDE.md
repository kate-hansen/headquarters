# Headquarters guide

Headquarters is shared memory for agents and the user, kept outside every code repo at `~/.headquarters` (on Windows, `%USERPROFILE%\.headquarters`). It holds what helps the next session work well: project knowledge, story-level working memory, and handoffs. Every headquarters skill (`hq`, `hq-init`, `handoff`, `pickup`) follows this guide.

## Layout

```
~/.headquarters/
  me.md                          the user's cross-project working preferences
  <project-slug>/
    project.md                   what the project is, how it runs, dependencies, quirks, Related list
    stories/<ID>/
      notes.md                   story-level memory that isn't a handoff
      handoffs/YYYY-MM-DD-HHMM-<slug>.md
    general/                     work that belongs to no story
      handoffs/...
```

A project folder can hold more than `project.md` and `stories/`. Add a file or folder when a kind of knowledge outgrows `project.md`, and link it from `project.md`. The layout is meant to grow as the workflow matures.

## Resolving the project

The project slug is the git root folder's name (`git rev-parse --show-toplevel`), lowercased, with spaces and underscores turned into hyphens: `Tussle Town` → `tussle-town`. Outside a git repo, use the current folder's name the same way.

If `~/.headquarters/<project-slug>/project.md` is missing, point it out and suggest `/hq-init`. Carry on either way, creating the project folder as needed.

## Resolving the story

Story IDs look like `<KEY>-NNN` (`TSTL-001`, `BV-006`). Resolve the story in this order:

1. **Argument**: a story ID the user passed.
2. **Branch**: the convention is `<type>/<ID>-<slug>` (`feat/TSTL-004-inventory-ui`); match `[A-Z]+-\d{3}` in the branch name.
3. **Ask** the user. For work tied to no story, use `general/`.

When the branch doesn't follow the convention, say so plainly so the user can fix it, then use the argument or ask.

The story's own file lives in the repo; `project.md` says where. For repos using `pmt`, it is `project/**/stories/**/<ID>-*.md`.

## Related projects

`project.md` has a **Related** list naming other headquarters projects this one depends on (for example `pm-toolbox` for any repo using `pmt`). When loading a project's memory, also read each Related project's `project.md`.

## Where knowledge goes

Apply the **audience test** first, then the **lifespan test**:

1. **Audience**: would a teammate picking up this story need it, with or without an agent?
   - Yes → the **story file** in the repo: decisions that change the plan, open questions, scope changes, progress in Work History, references. Edit the Markdown directly.
   - No → **headquarters**: handoffs, session context, how-to-work-here lessons, notes that are noise to a teammate.
2. **Lifespan**: does it outlive the story and describe the code?
   - Facts the repo needs to build, run, or be understood (a build quirk, an architectural decision) → the **repo**: its docs, `CLAUDE.md`/`AGENTS.md`, or an ADR.
   - Knowledge about working in the project that spans stories → **headquarters** `project.md`.

When something fits two places, write it once in the more shared place and link to it from the other.

## Writing rules

- **Affirmative guidance.** Write every lesson as what to do or rely on: "Auth tokens refresh in `middleware.ts`; extend there." Capture past decisions as decisions with their reason ("We chose X because Y"), so the next agent follows the chosen path.
- **Reference over repetition.** Link specs, story files, ADRs, commits, and files by path instead of copying them.
- **No secrets.** Redact API keys, passwords, tokens, connection strings, and personal information.
- **Report every write.** After writing to headquarters or a story file, tell the user what changed and where: "Saved to `earthley/project.md`: the build runs from `src/`." When fixing stale memory, call the fix out explicitly with the old and new claim, so the user can course-correct.
- **The user commits.** Leave all git commits and pushes to the user, who reviews work first.

## Workflow states

The agentic workflow for a story moves through **fresh → working → in review → closed**. Its transitions are skills: `/pickup` (or a future `/start`) takes fresh to working, `/handoff` takes working back to fresh, and review and finish come later. These states are worked out from what exists in `stories/<ID>/` and from the conversation; nothing stores them.

They are separate from the project's story statuses (backlog, todo, in-progress, complete). Change a story's status only when the user asks.

**Soft guards**: when a transition's preconditions look off (no handoff to pick up, a branch without an ID), say what you noticed and ask whether to continue.
