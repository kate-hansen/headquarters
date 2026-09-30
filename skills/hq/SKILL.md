---
name: hq
description: Headquarters, the shared memory at ~/.headquarters for projects and user stories. Use to recall what was learned or decided (a past meeting, an SME conversation, a project quirk), to remember something new, to update or forget stale memory, and whenever work would benefit from project or story memory the session hasn't loaded yet.
---

Read [GUIDE.md](GUIDE.md) first. It defines the layout, how to resolve the project and story, where knowledge goes, and the writing rules. Everything below assumes it.

## Pick the intent

Infer the intent from the user's phrasing, or from what the work needs when acting on your own:

- **Recall**: "what did we learn about auth?", "what did we talk about in last week's meeting?"
- **Remember**: "I just talked to Bob and we learned X, save it", or a lesson you want the next session to have.
- **Update**: a memory is outdated, incomplete, or contradicted by the code.
- **Forget**: the user asks to remove something, or a memory is simply wrong.

When the intent is still ambiguous, ask one short question.

## Recall

1. Resolve the project and, if relevant, the story.
2. Search `~/.headquarters/<project-slug>/` (including `stories/` and handoffs) and the Related projects. Start with `project.md`, then grep for the topic.
3. Answer with the source path of each fact. If headquarters has nothing, say so and name where else the answer might live (the story file, the repo's docs, git history).

## Remember

1. Resolve the project and story.
2. Run the audience and lifespan tests from the guide to choose the destination: the story file, the repo, or a headquarters file.
3. Within headquarters, choose the most specific home: a story-level fact goes in `stories/<ID>/notes.md`, a project-wide fact goes in the matching section of `project.md`, a preference about how the user works across all projects goes in `~/.headquarters/me.md`.
4. Check whether an existing entry already covers it. If one does, update that entry instead of adding a near-duplicate.
5. Write it as affirmative guidance, dated when timing matters (`2026-09-30, from Bob: ...`).
6. Report the write.

## Update

Edit the entry in place so it states the current truth. Report the change with the old claim and the new one, so the user can course-correct.

## Forget

Delete the entry, then report what was removed and from where.
