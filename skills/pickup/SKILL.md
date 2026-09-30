---
name: pickup
description: Resume a story in a fresh session from its headquarters handoffs.
argument-hint: "[story ID]"
disable-model-invocation: true
---

Read [../hq/GUIDE.md](../hq/GUIDE.md) first for resolving the project and story and for loading Related projects.

The goal is to understand how the work got here before touching it, then hand the user a brief and wait.

## 1. Find the trail

1. Resolve the project. Resolve the story from the argument or the branch.
2. With no story resolved (a new day, or a branch without an ID), list the stories under `~/.headquarters/<project-slug>/stories/` that have handoffs, plus `general/`, each with its newest handoff's date and title. Ask which one to pick up.
3. Soft guard: if the chosen story has no handoffs, say so and ask whether to start from the story file alone.

## 2. Load the context

Read, in this order:

1. **The newest handoff**, in full.
2. **Earlier handoffs** for the story, from newest to oldest, following `previous:`. Read their TL;DRs and Decisions sections, enough to see how the work arrived here. Stop when they no longer add to the picture.
3. **The story file** the handoff links.
4. **`project.md`**, every Related project's `project.md`, and `stories/<ID>/notes.md` if present.
5. **The current repo state**: `git status`, `git log` since the handoff's `commit:`, and the branch. Compare it with the handoff and note what has moved since (new commits, a different branch, uncommitted changes).

## 3. Brief and wait

Give the user:

- **Where we are**: two or three sentences in plain language.
- **What changed since the handoff**, if anything.
- **The first next step** from the handoff, and any open question that blocks it.

Then wait for the user's go-ahead before starting work.
