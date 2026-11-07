---
name: commit-and-review
description: "Coordinates requested commits and an approved pull-request review-and-fix cycle. Use when the user asks to commit changes and have them reviewed."
license: MIT
---

# Commit and Review

Commit only changes requested by the user. This workflow does not merge PRs. A request to commit does not authorize publishing changes; get the user's explicit approval before pushing, opening or updating a PR, or starting the review cycle.

## 1. Inspect scope and choose a branch

- Inspect the repository and default branch, worktree status, staged and unstaged diffs, untracked files, and commits on the current branch that are not on the default branch. Refresh remote references when needed.
- Identify which changes belong to the request. Preserve unrelated work and existing commits; never include, discard, or rewrite them. If ownership or scope is unclear, ask before staging or switching branches.
- Reuse the current branch only if it is not the default branch and has no commits absent from the default branch. Otherwise, create a topic branch from the default branch.
- Before creating a topic branch, choose a short, descriptive name and confirm it is unused locally and remotely. Carry over only this request's staged, unstaged, and untracked changes; leave existing commits on their original branch. Do not cherry-pick or replay them.
- Stop and ask how to proceed if switching branches could disturb unrelated work, requested and unrelated changes cannot be safely separated, or the request depends on commits that would remain on the original branch.

## 2. Implement and verify

- Follow repository conventions and make only the requested changes. Define acceptance criteria, then run the smallest relevant tests and checks or perform reproducible manual verification. Fix failures caused by the changes; report unrelated failures clearly. Do not claim acceptance without evidence.
- Record check commands and results for the PR description. Do not archive routine output. Archive only evidence the description cannot reproduce, such as screenshots or otherwise unavailable results. Unless the user or repository specifies another location, store it under `evidence/<branch-name>/` with a brief index. Exclude secrets, personal data, and irrelevant machine-specific output.
- For UI changes, capture screenshots and include them in the PR as supplemental evidence, not as a substitute for relevant checks. If required screenshots cannot be captured, report the blocker and do not claim the PR is ready.

## 3. Stage and commit

- Group requested changes by logical concern. Create separate commits only when each group is independently meaningful; otherwise, create one cohesive commit.
- Stage one group at a time and inspect its staged diff. Include only in-scope changes and relevant evidence; exclude unrelated work, secrets, and irrelevant or bulky generated files. If evidence cannot safely be included, provide equivalent reproducible evidence in the PR and explain the omission.
- Before each commit, recheck the worktree and staged diff. Use a clear, focused commit message that follows repository conventions. Never amend an existing commit.
- If no relevant uncommitted changes remain, do not create a replacement commit. Report that status and continue only with any other steps the user has authorized.

## 4. Get approval and publish

- After committing (or confirming there is nothing new to commit), ask whether the user wants the branch pushed and a PR opened or updated. A clear yes authorizes those actions and the review-and-fix cycle, including pushing focused fix commits. If the answer is unclear, ask again. Silence is not approval.
- If the user declines, stop without publishing or starting the review cycle.
- Push to the configured remote without force-pushing or rewriting history. If the push is rejected or the remote branch has diverged, stop and ask how to proceed.
- Check whether the branch already has a PR; update it rather than creating a duplicate. If none exists, use a suitable PR-creation skill, preferring a locally installed skill when several match. If no suitable skill is available, use the repository's preferred tooling. For an existing PR, use a dedicated update skill when available; otherwise, use the preferred tooling.
- Ensure the PR title and description summarize the changes and acceptance results. Include check commands and results or reproducible manual verification; link and summarize archived evidence, if any. Show the PR URL to the user.

## 5. Review and fix until ready

- Review only after the user authorizes publication and the PR is available. Use an appropriate review skill or, if none is available, a read-only review subagent. Ask the reviewer to identify actionable defects introduced by the changes, cite files and lines, and explain their severity and rationale.
- Have the reviewer verify that acceptance claims are supported by recorded results and archived evidence, when present. Treat inconsistent or irreproducible results, manual steps that cannot be reproduced, and missing required screenshots as actionable findings.
- If actionable findings remain, use a separate fix subagent limited to those findings. Ask it to preserve unrelated work and report its changes and tests.
- Inspect the fix diff, run relevant checks, and verify that each finding is resolved without unrelated changes. Update acceptance results and evidence, commit the focused fixes, and push them to update the PR.
- Request a fresh review after each update. Repeat the review, fix, verification, commit, and push cycle until no actionable issues remain and required checks pass.
- Stop and report what remains if a subagent is unavailable, a finding cannot be fixed safely, the same finding recurs without progress, or an external check blocks readiness. Do not claim the PR is ready without evidence.

## 6. Report the outcome

Report the branch, commits, PR link, evidence archive location (if any), checks run, and review status, as applicable. Note pending CI, approvals, or other requirements outside your control.
