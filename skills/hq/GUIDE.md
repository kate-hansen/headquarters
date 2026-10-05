# Headquarters guide

Headquarters is shared memory for agents and the user, kept outside every code repo at `~/.headquarters` (on Windows, `%USERPROFILE%\.headquarters`). It holds what helps the next session work well: project knowledge, story-level working memory, handoffs, and review reports. Every headquarters skill (`hq`, `hq-setup`, `hq-init`, `hq-handoff`, `hq-pickup`, `hq-review`, `hq-dashboard`) follows this guide. Pages written for the user to read follow `hq-artifact-design`.

If `~/.headquarters/me.md` is missing, the machine hasn't been set up: point it out and suggest `/hq-setup`.

## Layout

```
~/.headquarters/
  me.md                          the user's cross-project working preferences
  <project-slug>/
    project.md                   what the project is, how it runs, dependencies, quirks, Related list
    stories/<ID>/
      notes.md                   story-level memory that isn't a handoff
      handoffs/YYYY-MM-DD-HHMM-<slug>.md
      reviews/YYYY-MM-DD-HHMM-<slug>/index.html   plus assets/ for screenshots
      reports/YYYY-MM-DD-HHMM-<slug>/index.html   other reports, such as analyses
    general/                     work that belongs to no story
      handoffs/...
      reviews/...
```

A project folder can hold more than `project.md` and `stories/`. Add a file or folder when a kind of knowledge outgrows `project.md`, and link it from `project.md`. The layout is meant to grow as the workflow matures.

## Resolving the project

The project slug is the git root folder's name (`git rev-parse --show-toplevel`), lowercased, with spaces and underscores turned into hyphens: `Tussle Town` → `tussle-town`. Outside a git repo, use the current folder's name the same way.

If `~/.headquarters/<project-slug>/project.md` is missing, point it out and suggest `/hq-init`. Carry on either way, creating the project folder as needed.

## Resolving the story

A story is a Beads issue (`bd`). IDs look like `<project-slug>-<shortid>` (`recraft-fb7`, `tussle-town-a12`); some work is also tracked in Monday, where IDs are numeric board-item ids. Resolve the story in this order:

1. **Argument**: a `bd` id (or Monday id) the user passed.
2. **Branch**: the convention is `feat/<slug>` and usually carries no id. Only when a branch embeds a `bd` id (`feat/recraft-fb7-...`) match `[a-z0-9]+-[a-z0-9]{3,}` from it.
3. **`bd` / ask**: run `bd list` to show open issues and ask which one, or ask the user directly. For work tied to no issue, use `general/`.

The branch rarely names the story here, so prefer the argument or `bd list` over parsing it.

The story itself lives in Beads, not a repo file: read it with `bd show <id>`, query with `bd list` / `bd query`. Headquarters keys its `stories/<ID>/` folder on that id.

## Related projects

`project.md` has a **Related** list naming other headquarters projects this one depends on (a shared library, a sibling service). When loading a project's memory, also read each Related project's `project.md`.

## Where knowledge goes

Apply the **audience test** first, then the **lifespan test**:

1. **Audience**: would a teammate picking up this story need it, with or without an agent?
   - Yes → the **Beads issue**: decisions that change the plan, open questions, scope changes, progress. Record them on the bead with `bd comment` / `bd note` / `bd update`.
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
- **Reports stay in headquarters.** Every report (reviews, analyses, any other page written for the user) is a file in the project's headquarters folder, kept local even when the harness can publish pages elsewhere.
- **Hand over pages ready to open.** When a page is written, open it in the default browser (`start "" "<path>"` on Windows, `open` on macOS, `xdg-open` on Linux), and give the user a clickable `file:///` link with the full absolute path and forward slashes (`file:///C:/Users/<you>/.headquarters/<project>/.../index.html`). Terminals open a `file:///` link on Ctrl+click; a `~` path can't be clicked.
- **The user commits.** Leave all git commits and pushes to the user, who reviews work first.

## Workflow states

The agentic workflow for a story moves through **fresh → working → in review → closed**. Its transitions are skills: `/hq-pickup` (or a future `/hq-start`) takes fresh to working, `/hq-handoff` takes working back to fresh, `/hq-review` takes working to in review, and the user's reply to a review takes it back to working. Finish comes later. These states are worked out from what exists in `stories/<ID>/` and from the conversation; nothing stores them.

They are separate from the project's story statuses (backlog, todo, in-progress, complete). Change a story's status only when the user asks.

**Soft guards**: when a transition's preconditions look off (no handoff to pick up, a branch without an ID), say what you noticed and ask whether to continue.

## Companion skills

The `mattpocock-skills` plugin supplies focused skills that pair with these states. Reach for one when its moment arrives, and invoke it by its exact `mattpocock-skills:<name>` id.

- **Fresh → working (orient and plan)**: `mattpocock-skills:research` to settle an open question against primary sources before building; `mattpocock-skills:domain-modeling` when the story reshapes terminology, a `CONTEXT.md`, or an ADR; `mattpocock-skills:codebase-design` when designing a module's interface and seams; `mattpocock-skills:grilling` to stress-test the plan before committing to it.
- **Working (build)**: `mattpocock-skills:tdd` for the red-green-refactor loop; `mattpocock-skills:prototype` for throwaway code that settles a design question; `mattpocock-skills:diagnosing-bugs` when a hard bug or regression has you stuck.
- **Working → in review**: `mattpocock-skills:code-review` alongside `/hq-review` — it reviews the diff on the Standards and Spec axes in parallel sub-agents, and its findings feed the review report.
- **Any state (utilities)**: `mattpocock-skills:resolving-merge-conflicts` for an in-progress merge or rebase; `mattpocock-skills:wizard` for setup steps only a human can do (credentials, CI secrets, a third-party dashboard); `mattpocock-skills:writing-for-agents` when editing a skill, `CLAUDE.md`, or `AGENTS.md`.

## Daily close-out

Separate from any story's workflow, a daily rhythm closes out logged time. A LaunchAgent nudges once each weekday afternoon (3:45pm ET) to log the day in Harvest — the reminder lives in `reminders/harvest-timesheet/` and points at the timesheet skill. Run `/harvest-timesheet` to gather the day's work, compare it against what Harvest already has, and log the rest; `/weekly-harvest-report` and `/monthly-harvest-report` summarise logged time. The timesheet skills are [nothingalike/harvest-skills](https://github.com/nothingalike/harvest-skills); every Harvest entry is the user's to confirm, and nothing writes to Harvest unattended.
