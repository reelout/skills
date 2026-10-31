---
name: merge-pull-request
description: "Checks and merges a pull request using a user-approved merge method, then removes its topic branches when safe. Use when the user asks to merge a PR."
license: MIT
---

# Merge a Pull Request

Verify that the PR is ready to merge, recommend a method based on its contents and repository policy, and obtain the user's approval before merging. After a successful merge, safely clean up its source branches.

## Workflow

1. **Inspect the PR and repository.**
   - Confirm the repository, target and source branches, head SHA, PR state, mergeability, reviews, required checks, and enabled merge methods.
   - Review the commits and diff to determine whether the PR contains one cohesive change or several distinct concerns. Check whether either source branch has work beyond the PR head.
   - If the PR is already merged, verify the merge and proceed to cleanup. If it is closed without merging, conflicted, missing required reviews, or has failing checks, explain why and stop.
   - Treat pending required checks as blockers. Wait for them when practical; otherwise, report the blocker and stop.
2. **Recommend and confirm a merge method.**
   - Base the recommendation on the PR's logical changes, commit history, and repository conventions; commit count alone does not determine how many topics it contains.
   - Prefer **squash merge** for one cohesive topic when the individual commits need not be preserved in the target history.
   - Prefer a **merge commit** for multiple meaningful concerns when preserving the branch's commit history is useful.
   - Prefer **rebase merge** when the repository favors linear history and the individual commits should be preserved.
   - Tell the user which methods are enabled and recommend one with a brief rationale. Use the ask-user tool to get their explicit choice; do not merge without it.
   - If squash is selected, prepare the exact commit subject and body for the target branch. Show the complete message and obtain the user's approval before merging. If they decline it, stop without merging.
3. **Merge the approved PR.**
   - Immediately before merging, confirm the PR is still open and mergeable, its head SHA is unchanged, and all required checks and reviews pass. If its head or merge method has changed since approval, ask the user to confirm again.
   - Use supported tooling to merge with the approved method. Do not change the PR or bypass repository protections.
   - Verify the PR is merged and record the resulting commit SHA. If the merge fails or cannot be verified, do not clean up branches.
4. **Clean up the source branches safely.**
   - Never delete the target branch or repository default branch. Check local and remote source branches separately; the hosting platform may already have removed the remote branch.
   - Delete the remote source branch only with an atomic compare-and-delete that requires its ref to match the exact PR head SHA. Invoke Git via an argv-safe process or API, passing the executable and arguments separately; never interpolate branch or remote names into a shell command. If the operation cannot enforce the expected SHA atomically, preserve the branch and explain why.
   - Before changing the local checkout, verify the worktree is clean. If it is not, leave the local source branch untouched and report that local cleanup is pending. Remote cleanup may proceed independently if its atomic safety check is available.
   - If checked out on the source branch, switch to the target branch and fast-forward it from its configured remote. If switching or updating is unsafe, leave the local source branch intact.
   - Delete the local source branch only when its tip exactly matches the PR head SHA, proving it has no additional commits. Prefer normal deletion. If Git refuses because a squash or rebase merge leaves the PR head outside the target history, forced local ref deletion is acceptable only after verifying the merge and exact tip match. Otherwise, preserve the branch.
5. **Report the outcome.**
   - Report the PR, chosen merge method, resulting commit SHA, and the status of each source-branch cleanup. Explain anything left pending.

## Safety

- Obtain explicit approval for the merge method; for squash merges, also obtain approval of the exact commit message.
- Never force-push branch commits. Use forced ref deletion only for the verified local cleanup described above; remote deletion requires an atomic expected-SHA check.
- Never bypass required checks, discard uncommitted changes, or delete a source branch whose tip differs from the verified PR head.
