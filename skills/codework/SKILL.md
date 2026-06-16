---
name: codework
description: "Run the recurring repo delivery loop: choose or clarify the next goal, run the real ralplan gate, implement through ultragoal or ultrawork, open a PR, run code review, wait for CI/DCO, fix failures, then ask for human-in-the-loop merge approval before merging and syncing. Use when the user says codework, asks for the next implementation cycle, or wants planning-to-PR automation with explicit HITL before merge."
---

# Codework

Use `codework` when the user wants the full coding delivery cycle, not just a plan or a patch.

## Default Outcome

Deliver one merge-ready PR automatically, then stop for human-in-the-loop
approval before merging.

Do not merge on standing authority alone. Even if the user says "merge까지",
"끝까지", "ship it", or invokes `codework` in a repo where prior standing
instructions allow merge, ask a final HITL merge question after review and
checks pass. Merge and sync only after the user gives an affirmative response
to that final question in the current thread/session.

If the user does not approve, declines, or is unavailable, stop at a
merge-ready PR with review and CI evidence.

## Delivery Grain

Treat one user goal as one PR by default.

Use multiple focused commits inside that PR when it improves reviewability:
planning docs, implementation, tests, review fixes, CI fixes, and small
follow-up documentation can all belong to the same goal PR.

Do not split review feedback, test fixes, DCO/CI fixes, or small follow-up
adjustments into a new PR merely because a commit already exists. Keep fixing
the active PR until the goal is review-clean and check-clean.

Split only when the next change has a different user-facing goal, independent
release or rollback value, materially different risk, a blocking external
decision, or explicit user instruction to stack/split PRs.

## Workflow Spine

`codework` is not a mini planning shortcut. Its normal path is:

`$ralplan -> $ultragoal` or `$ultrawork -> PR -> $code-review -> CI/DCO -> HITL merge approval -> merge/sync`

Use the real workflow surfaces whenever they are available:

- In an attached OMX CLI/tmux runtime, invoke the corresponding OMX workflows
  (`omx ralplan`, `omx ultragoal` or `omx ultrawork`, and code review).
- In Codex App or another non-tmux surface, load and follow the named skills
  directly as native skill workflows.
- Do not replace the ralplan gate with a casual local summary for normal
  codework. A compact inline plan is only a fallback for tiny, reversible
  changes or when the full workflow surface is unavailable.

## Loop

1. **Next Goal**
   - If the user gives a concrete goal, use it.
   - If the goal is optional or says "next", choose the next highest-leverage repo task from current evidence: recent analysis, TODOs, failing checks, PR comments, roadmap docs, review findings, or obvious maintainability debt.
   - Do not invent product direction that depends on taste, business priority, credentials, production access, or destructive changes. For those, ask one concise question.
   - State the chosen goal, why it is next, and the stop condition.

2. **Evaluation / Ralplan**
   - Run the real `$ralplan` gate before editing by default.
   - The gate must produce the desired outcome, constraints, rejected options,
     risks, acceptance criteria, verification commands, and stop condition.
   - Use a compact inline ralplan only for truly tiny, reversible changes where
     a full gate would add ceremony without improving safety.
   - If architecture, security, migrations, public behavior, workflow contracts,
     release metadata, or ambiguous scope are involved, mini-ralplan is not
     enough.

3. **Implementation Lane**
   - Use `$ultragoal` after ralplan when the work has sequential stories,
     durable checkpoints, or finish-until-done pressure.
   - Use `$ultrawork` after ralplan when independent implementation, test,
     docs, or review lanes can run in parallel.
   - Execute directly only for tiny single-file fixes, and state why the
     ultragoal/ultrawork lane is unnecessary while preserving this skill's
     verification, review, PR, CI, and merge gates.
   - Keep commits reviewable. Prefer multiple small signed commits over one noisy commit.

4. **Verification**
   - Run targeted tests first, then broader gates appropriate to the repo.
   - For Python repos, typical gates are unit tests, `compileall`, generated-doc checks, and `git diff --check`.
   - If a check fails, fix root cause and rerun the failing check before continuing.
   - Record any validation gap explicitly.

5. **PR**
   - Create a branch with the default `codex/` prefix unless the repo says otherwise.
   - Commit with DCO/signoff when required.
   - Push and open one PR for the cycle automatically.
   - PR body must include summary, verification, review expectations, and any known risks.
   - Keep later review/CI fixes for this same goal in the same PR as additional focused commits.

6. **Code Review**
   - Run the real `$code-review` against the PR or branch diff before merge.
   - In an attached OMX CLI/tmux runtime, use the repo's OMX code-review
     surface. In Codex App or another non-tmux surface, load and follow the
     `$code-review` skill directly.
   - If independent review lanes are unavailable, report that review is unavailable and do not call the PR merge-ready unless the user explicitly waives review.
   - Fix actionable review findings, push updates, rerun verification, and rerun review when the diff materially changes.

7. **CI / DCO / Merge**
   - Wait for required checks, including DCO.
   - If checks fail, inspect logs, fix, push, and wait again.
   - When local verification passed, review is clear or waived, required checks pass, and the branch is mergeable, ask a final HITL merge question before merging.
   - The HITL question must summarize the PR URL, review result, CI/DCO result, local verification, merge strategy, and local sync plan, then ask whether to merge now.
   - Do not merge until the user gives an affirmative response to that final HITL question. If the user declines, defers, or does not answer, stop at the merge-ready PR.
   - Prefer merge commits when preserving commit structure matters; use squash only if repo policy or user request says so.
   - After merge, push or fetch the merged `main` as needed so local `main` and the default remote agree.
   - Sync the user's local runnable surface when the repo ships a CLI, plugin, app, or generated tool the user runs from this machine. Use the repo's established local install/update command; for Loop, run `npm install -g .` from the repo root.
   - Confirm the synced local command or app starts and reports the expected version/help/status, then confirm a clean worktree.

## Stop Conditions

Stop with a concise report when one of these is true:

- PR is merged, remote/default `main` and local `main` agree, the user's local runnable surface is synced when applicable, and the worktree is clean.
- PR is merge-ready and awaiting HITL merge approval.
- PR is merge-ready and the user declined or deferred merge approval.
- A blocker requires user authority, credentials, destructive action, production access, or a materially branching decision.
- The same blocking condition repeats after reasonable fix attempts.

## Final Report

Include:

- Goal chosen and why.
- PR URL and merge commit, if merged.
- HITL merge approval status.
- Remote/default branch sync result.
- Local runnable sync result, when applicable.
- Changed files or high-level change summary.
- Review result.
- CI/DCO status.
- Local verification commands.
- Remaining risks or next suggested `codework` goal.
