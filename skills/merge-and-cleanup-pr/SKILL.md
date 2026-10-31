---
name: merge-and-cleanup-pr
description: "Checks and merges a pull request using a user-approved merge method, then safely removes its local and remote topic branches. Use when the user asks to merge a PR and clean up its branches."
license: MIT
---

# Merge a Pull Request and Clean Up

Verify that the pull request is ready, recommend a merge method based on its commits and repository policy, and ask the user which method to use before merging. After verifying the merge, remove the local and remote topic branches when safe.

## Workflow

1. **Identify the PR and inspect repository state.**
   - Resolve the requested PR and confirm its repository, target branch, source branch, current head commit, and merge state.
   - Check the PR's review status, required checks, conflicts, and which merge methods the repository allows. Do not proceed if the PR is closed, already merged, blocked, or not ready; explain the blocker.
   - Inspect the commits and diff to understand whether the PR contains one cohesive topic or multiple distinct concerns. Check the local worktree and whether the source branch has local or remote commits not included in the PR.
2. **Recommend and confirm the merge method.**
   - Explain the available methods and recommend one based on the commit history and repository conventions:
     - **Squash merge:** usually best for one cohesive topic when the PR's individual commits do not need to remain in the target history.
     - **Merge commit:** usually best when the PR contains multiple meaningful topics or commits whose separate history and branch context should be preserved.
     - **Rebase merge:** preserves individual commits while keeping target history linear; recommend it when that matches repository policy and the commits are suitable for a linear history.
   - Tailor the recommendation to the actual PR; do not infer topic count from commit count alone.
   - Use the ask-user tool to present the available methods, state the recommendation and rationale, and ask which method the user approves. Do not merge until the user chooses a method.
   - If the preferred method is not enabled or the user declines, stop without merging.
3. **Merge using the approved method.**
   - Recheck that the PR is still open, mergeable, and passing its required checks. If its head or readiness changed since confirmation, stop and ask again.
   - For a squash merge, draft the exact commit subject and body that will appear on the target branch. Show the complete message to the user and obtain approval before merging; do not merge until both the method and message are approved.
   - Merge with the selected method using the repository's supported tooling. Do not change the PR's content or bypass required checks.
   - Verify that the PR reports merged and record the resulting merge commit or squash/rebase commit.
4. **Safely clean up branches.**
   - Identify the PR source branch and target branch. Never delete the target branch or the repository's default branch.
   - Before changing the local checkout, confirm the worktree is clean. If it is dirty, do not stash, discard, or move changes; leave the local branch intact and report that cleanup is pending.
   - If currently on the source branch, switch to the target branch and update it from its configured remote using a fast-forward-only update. If switching or updating is unsafe, stop local cleanup without disturbing work.
   - Delete the local source branch only after confirming it points to the PR head and contains no additional commits or work that was not merged. Use a non-forced deletion when possible; if squash or rebase merging prevents Git from recognizing the branch as merged, forced local ref deletion is acceptable only after verifying the PR is merged and the branch tip exactly matches the merged PR head. Otherwise, preserve it and explain why.
   - Check whether the remote source branch still exists; hosting platforms may have deleted it during merge. Delete it only after confirming it still points to the PR head. If it has advanced or diverged, do not delete it; report the discrepancy.
5. **Report the result.**
   - Report the PR, selected merge method, resulting commit, branch cleanup performed, and any cleanup left pending. Never imply a branch was deleted unless verified.

## Safety

- The user's request authorizes merging and branch cleanup, but the merge method requires the user's explicit choice after seeing the recommendation.
- For squash merges, obtain the user's approval of the exact target-branch commit message before merging.
- Never force-push, delete the target/default branch, bypass required checks, or discard uncommitted changes.
- If the PR head, local branch, or remote branch contains work beyond the merged PR, preserve that work and ask how to proceed.
