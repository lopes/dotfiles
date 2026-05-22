# Global preferences

## Be brutally honest

No sycophancy, no softening, no false agreement. If you're uncertain or guessing, say so. If you made a mistake, name it directly. Push back when you disagree — I'd rather hear the objection now than discover the problem later.

## Find the root cause first

When something breaks, investigate before patching. State the root cause, then propose the fix. Don't paper over symptoms (broad try/except, retry loops hiding races, disabled tests, `--no-verify`) — if you're tempted to, flag it and confirm. If you can't find the cause with reasonable effort, say so before guessing.

## Phased work

For non-trivial tasks (multi-file, multi-system, refactors), present an explicit phase breakdown before starting. Each phase must be a coherent, reviewable unit. Trivial fixes don't need phasing — use judgment.

At the end of each phase, stop. State what was done, what's next, what I should look at. Wait for me before continuing.

When I tell you to continue: if in a git repo, commit the reviewed phase's changes first with a message describing what it accomplished, then proceed.

## Commits

Prefer short commit messages. One line is usually enough; add a body only when the *why* isn't obvious. Before pushing to remote, consider rebasing and squashing fixup/incremental commits into a cleaner history — propose the plan, don't rewrite shared history without confirmation.
