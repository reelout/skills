---
name: commit-and-review
description: "Guides requested changes through branch selection, focused commits, and an optional pull-request review-and-fix loop. Use when the user asks to commit changes and have them reviewed."
license: MIT
---

# Commit and Review

Commit only changes requested by the user. After committing, ask whether they want to push the branch and open or update a pull request (PR). Proceed with publishing and the review-and-fix loop only with their approval. Never merge a PR.

## Workflow

### 1. Inspect the work and choose a branch

- Inspect the current branch, repository default branch, worktree status, staged and unstaged diffs, untracked files, and commits on the current branch that are not on the default branch. Refresh remote references when needed.
- Separate in-scope changes from unrelated work. Preserve unrelated changes and existing commits; never include, discard, or rewrite them. If ownership or scope is unclear, ask the user before staging or switching branches.
- If the current branch is the default branch or contains commits absent from it, create a topic branch from the default branch. Otherwise, continue on the current feature branch.
- Before creating a topic branch, choose a short, descriptive name and confirm it is unused locally and remotely. Carry over only this request's staged, unstaged, and untracked changes; leave existing commits on their original branch. Do not cherry-pick or replay those commits.
- Stop and ask how to proceed if switching branches could disturb unrelated changes or if the requested changes depend on commits that would remain on the original branch.

### 2. Implement and verify

- Make or complete only the requested changes, following repository conventions.
- Define how the requested behavior will be accepted, then gather verifiable evidence by running the smallest relevant tests and checks or recording a reproducible manual verification. Do not claim acceptance without evidence. Fix failures caused by the changes and report unrelated failures clearly.
- For UI changes, capture screenshots as acceptance evidence. Include them in the PR description; screenshots supplement, not replace, relevant tests and checks. If you cannot capture them, report the blocker and do not claim the PR is ready.

### 3. Group and commit

- Group requested changes by logical concern. Create separate commits only when each group is independently meaningful; otherwise, create one cohesive commit.
- Stage one group at a time and inspect its staged diff. Include only changes in scope; exclude unrelated work, secrets, and generated artifacts.
- Before each commit, recheck the worktree and staged diff. Use a clear, focused commit message that follows repository conventions. Never amend an existing commit.
- If no relevant uncommitted changes remain, report that instead of recreating existing commits.

### 4. Ask before publishing

- After committing all requested changes, ask whether the user wants the branch pushed and a PR opened or updated.
- A clear yes authorizes pushing, opening or updating the PR, and pushing focused review-fix commits. If the answer is unclear, ask again.
- If the user declines, stop without pushing, opening a PR, or starting the review loop.
- Push to the configured remote without force-pushing or rewriting history. If the push is rejected or the remote branch has diverged, stop and ask how to proceed.

### 5. Open or update the PR

- Check whether the working branch already has a PR; update it rather than creating a duplicate.
- If no PR exists, use an available PR-creation skill and follow its instructions. If multiple matching skills are available, prefer a locally installed skill over a user-installed one. If none is suitable, use the repository's preferred tooling.
- For an existing PR, use a dedicated PR skill if it supports updates; otherwise, use the repository's preferred tooling.
- Ensure the PR title and description summarize the changes and include acceptance evidence, such as test and check results or reproducible manual verification. Include screenshots for UI changes. Show the PR URL to the user.

### 6. Review and fix until ready

- If an appropriate review skill is available, use it to inspect the PR diff and relevant context. Otherwise, start a read-only review subagent. Ask the reviewer to report actionable defects introduced by the changes, cite files and lines, and explain each issue's severity and rationale.
- If the reviewer finds actionable issues, start a separate fix subagent limited to those findings. Ask it to preserve unrelated work and report its changes and tests.
- Inspect the fix agent's diff, run relevant checks, and verify that each finding is resolved without unrelated changes. Commit fixes in focused groups and push them to update the PR.
- Request a fresh review after each update. Repeat review, fix, verification, commit, and push until no actionable issues remain and required checks pass.
- Stop and report what remains if a subagent is unavailable, a finding cannot be fixed safely, the same finding recurs without progress, or an external check blocks readiness. Do not claim the PR is ready without evidence.

### 7. Report the outcome

Report the working branch, commits, PR link, checks run, and review status. Note any pending CI, approval, or other requirement outside your control.

## Safety

- Never force-push, rewrite history, amend existing commits, alter unrelated work, or merge a PR.
- Do not commit, push, or publish anything beyond the scope the user authorized.
