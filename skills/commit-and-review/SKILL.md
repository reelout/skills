---
name: commit-and-review
description: "Guides requested changes through focused commits, a working branch when needed, and a pull request, then iterates with delegated review and fixes until ready. Use when the user asks to commit changes and have them reviewed, with a branch and PR as needed."
license: MIT
---

# Commit and Review

Take the requested changes from the current worktree through focused local commits, and only if the request explicitly asks for publishing work, create a working branch, push it, and open or update a pull request. Then iterate on delegated review findings until the changes are ready. Never merge the pull request.

## Workflow

1. **Inspect the repository and identify the requested changes.**
   - Check the current branch, worktree status, staged diff, unstaged diff, untracked files, repository default branch, and commits on the current branch that are not in the default branch. Refresh remote references if needed to make this comparison reliable.
   - Identify which staged, unstaged, and untracked changes belong to this request. Preserve all unrelated changes and existing commits; never stage, discard, or rewrite them accidentally.
   - If you cannot confidently identify which changes belong to the request, ask the user before staging or switching branches.
2. **Choose the working branch.**
   - If the current branch is the default branch or contains commits not merged into it, create a new topic branch from the default branch before committing only when the user explicitly wants the work published. Otherwise, continue on the current branch and keep the work local.
   - When creating a new branch, carry over only staged, unstaged, or untracked changes that belong to this request. Do not cherry-pick, replay, or otherwise move any existing commits, even if they are related to the request; leave all existing commits on their original branch.
   - Preserve unrelated staged, unstaged, and untracked changes. If Git cannot switch branches without disturbing them, or the requested changes depend on commits that will not be on the new branch, stop and ask how to proceed rather than risking changes or including existing commits.
   - Choose a short, descriptive branch name and confirm it is unused both locally and on the remote before creating it. Never overwrite an existing branch.
3. **Implement and verify the changes.**
   - Make or complete only the requested changes, following repository conventions.
   - Run the focused tests, checks, and validation appropriate to the change. Fix failures caused by the change; report unrelated failures explicitly.
4. **Create focused commits and, if explicitly authorized, publish the branch.**
   - Group changes into logical, cohesive units before staging. Use separate commits for distinct concerns when each commit makes sense on its own; use one commit when the changes form a single cohesive unit.
   - Stage one group at a time and inspect the staged diff before each commit. Include only request-specific changes, whether they were staged or unstaged; do not accidentally include unrelated changes that were already staged. Exclude secrets and generated artifacts.
   - Create one or more focused commits with clear messages that follow repository conventions. Keep their order coherent; do not amend existing commits.
   - Only push the working branch to its configured remote if the user explicitly asked for publishing or review via a branch/PR. Do not force-push or rewrite history.
5. **Open or update the pull request only when explicitly requested.**
   - Create a PR for the working branch, or update its existing PR rather than creating a duplicate, only if the user explicitly asked for the branch to be published for review.
   - Include a concise summary and the verification performed. Do not merge.
6. **Run the delegated review-and-fix loop.**
   - Start a read-only review subagent with the PR diff and relevant context. Ask it to report actionable defects introduced by the changes, with file and line references, reasoning, and severity.
   - If the review finds actionable issues, start a separate fix subagent with those findings. Ask it to fix only the reported issues, preserve unrelated work, and report its edits and tests. A proposed fix is not complete until it is inspected and verified.
   - Inspect the fix agent's diff, run relevant checks, and confirm the findings are addressed without unrelated changes. Group the fixes into one or more focused commits, then push them to update the PR.
   - Request a fresh review of the updated PR diff. Repeat the review, fix, verification, commit, and push steps until the reviewer reports no actionable findings and required checks pass.
   - If a subagent is unavailable, an issue cannot be fixed safely, a finding recurs without progress, or external checks block readiness, stop and report what remains. Do not claim review completion or readiness without evidence.
7. **Report the outcome.**
   - Provide the branch, commit(s), PR link, checks run, and final review status. Clearly note any pending CI, approval, or other readiness requirement outside your control.

## Safety

- The user's request authorizes creating a branch, committing the requested changes, pushing the working branch, and opening or updating a PR only when those publishing steps are explicitly included in the request. It does not authorize merging.
- If the user asks only for local changes or a review without publication, keep the work local and do not push or open a PR.
- Before every commit, including review-fix commits, recheck the worktree and staged diff. Keep each commit limited to one logical group and preserve unrelated work.
- Commit only staged, unstaged, or untracked changes that belong to the request. Never move or rewrite existing commits; if no relevant uncommitted changes remain, report that rather than recreating already committed work.
- If branch state, change ownership, or tool permissions prevent safe progress, stop and explain the blocker rather than risking unrelated work.
