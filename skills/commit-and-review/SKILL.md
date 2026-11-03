---
name: commit-and-review
description: "Guides requested changes through branch selection, focused commits, and an optional pull-request review-and-fix loop. Use when the user asks to commit changes and have them reviewed."
license: MIT
---

# Commit and Review

Commit only changes requested by the user, grouped into focused commits. After committing, ask whether they want to push the branch and open or update a pull request (PR). Proceed with publishing and the review-and-fix loop only if they agree. Never merge the PR.

## Workflow

### 1. Inspect the work and select a branch

- Check the current branch and repository default branch, worktree status, staged and unstaged diffs, untracked files, and commits on the current branch that are not in the default branch. Refresh remote references when needed.
- Separate changes in scope from unrelated work. Preserve unrelated changes and existing commits; never include, discard, or rewrite them. If ownership or scope is unclear, ask the user before staging or switching branches.
- If the current branch is the default branch or contains commits absent from it, create a topic branch from the default branch. Otherwise, continue on the current feature branch.
- Before creating a topic branch, choose a short, descriptive name and confirm it is unused locally and remotely. Carry over only this request's staged, unstaged, and untracked changes; leave existing commits on their original branch. Do not cherry-pick or replay them.
- If switching branches could disturb unrelated changes, or the requested changes depend on commits that would remain on the original branch, stop and ask how to proceed.

### 2. Implement and verify

- Make or complete only the requested changes, following repository conventions.
- Run the smallest relevant tests and checks. Fix failures caused by the changes; report unrelated failures clearly.

### 3. Group and commit

- Group requested changes by logical concern. Use separate commits only when each group is independently meaningful; otherwise, create one cohesive commit.
- Stage one group at a time and inspect its staged diff. Include only request-specific changes; exclude unrelated work, secrets, and generated artifacts.
- Before each commit, recheck the worktree and staged diff. Use a clear, focused commit message that follows repository conventions. Keep commit order coherent and never amend an existing commit.
- If no relevant uncommitted changes remain, report that instead of recreating existing commits.

### 4. Ask before publishing

- After all requested changes are committed, ask whether the user wants the branch pushed and a PR opened or updated.
- A clear yes authorizes pushing, opening or updating the PR, and pushing focused review-fix commits. If the answer is unclear, ask again.
- If the user declines, stop without pushing, opening a PR, or starting the review loop.
- Push to the configured remote without force-pushing or rewriting history. If the push is rejected or the remote branch has diverged, stop and ask how to proceed.

### 5. Open or update the PR

- Check whether the working branch already has a PR; update it rather than creating a duplicate.
- If no PR exists, use an available PR-creation skill and follow its instructions. If multiple matching skills are available, prefer a locally installed skill over a user-installed one. If none is suitable, use the repository's preferred tooling.
- For an existing PR, use a dedicated PR skill if it supports updates; otherwise, use the repository's preferred tooling.
- Ensure the PR title and description summarize the changes and verification performed. Show the PR URL to the user. Never merge the PR.

### 6. Review and fix until ready

- If an appropriate review skill is available, use it (for example, `code-review`) to inspect the PR diff and relevant context. Only if no suitable review skill is available, start a read-only review subagent. Ask the reviewer to report actionable defects introduced by the changes, citing files and lines and explaining severity and rationale.
- If the reviewer finds actionable issues, start a separate fix subagent limited to those findings. Ask it to preserve unrelated work and report its changes and tests.
- Inspect the fix agent's diff, run relevant checks, and verify that each finding is resolved without unrelated changes. Commit fixes in focused groups and push them to update the PR.
- Request a fresh review after each update. Repeat review, fix, verification, commit, and push until no actionable issues remain and required checks pass.
- Stop and report what remains if a subagent is unavailable, a finding cannot be fixed safely, the same finding recurs without progress, or an external check blocks readiness. Do not claim the PR is ready without evidence.

### 7. Report the outcome

Report the working branch, commits, PR link, checks run, and review status. Note any pending CI, approval, or other requirement outside your control.

## Safety

- Never force-push, rewrite history, amend existing commits, alter unrelated work, or merge the PR.
- Do not commit, push, or publish anything beyond the scope the user authorized.
