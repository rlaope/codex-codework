# Codex Codework

[![Verify](https://github.com/rlaope/codex-codework/actions/workflows/verify.yml/badge.svg)](https://github.com/rlaope/codex-codework/actions/workflows/verify.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

`codework` is a Codex skill for running a complete repository delivery loop:
goal selection, planning, implementation, verification, PR/review, CI/DCO,
merge, remote sync, and local runnable sync.

It is based on OMX (oh-my-codex) workflow surfaces and uses the same delivery
spine: `$ralplan` for planning, `$ultragoal` or `$ultrawork` for execution, and
`$code-review` before merge. Outside an OMX tmux runtime, Codex can still follow
the skill directly as a native Codex skill.

It is useful when a user does not want only a patch or a plan, but wants an
agent to keep driving a repo task until it is merged or explicitly blocked.

## What It Does

- Chooses or clarifies the next repo goal.
- Runs a real planning gate before meaningful edits.
- Selects an implementation lane: direct, `$ultragoal`, or `$ultrawork`.
- Keeps commits and PRs reviewable.
- Runs targeted and broad verification.
- Requires code review before merge unless review is explicitly waived.
- Waits for CI/DCO and fixes failures in the same active goal.
- After merge, syncs local `main`, remote `main`, and the user's local runnable surface when applicable.

## Install

One-line install:

```bash
curl -fsSL https://raw.githubusercontent.com/rlaope/codex-codework/main/install.sh | bash
```

Then restart Codex so the skill is discovered.

You can also ask Codex to install this skill from GitHub:

```text
Install the codework skill from https://github.com/rlaope/codex-codework/tree/main/skills/codework
```

Or install manually:

```bash
mkdir -p ~/.codex/skills
git clone https://github.com/rlaope/codex-codework.git /tmp/codex-codework
cp -R /tmp/codex-codework/skills/codework ~/.codex/skills/codework
```

## Use

Invoke it explicitly:

```text
$codework implement the next highest-leverage repository improvement and merge it when checks pass
```

Or use it for a concrete delivery goal:

```text
$codework improve the dashboard observability UX, add tests, update docs, review, merge, and sync my local CLI
```

## Skill Path

The installable skill lives at:

```text
skills/codework
```

## Verify

```bash
npm test
```

## License

MIT
