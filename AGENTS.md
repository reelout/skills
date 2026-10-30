# Agent instructions

This repository contains installable agent skills. Treat the contents of `skills/` as the source of truth for what is published to users. Every change should preserve that contract: accurate metadata, flat layout, self-contained skill directories, and no accidental publication of private or machine-specific files.

## Repository purpose

- Skills are packaged as standalone directories under `skills/<skill-name>/`.
- Each skill ships with a root-level `SKILL.md` file that the agent discovery system reads.
- The repository intentionally has no application runtime, build step, or package dependencies for the published skills themselves.
- Everything in a published skill directory is distributed verbatim. Do not include secrets, credentials, local paths, or files intended only for a developer machine.

## Required project structure

- Every skill must be a direct child of `skills/`.
- The directory name must be lowercase kebab-case, for example `python-linting` or `git-workflow`.
- Each skill directory must contain exactly one root-level `SKILL.md` file.
- Optional content belongs inside that same skill directory: `scripts/`, `references/`, and `assets/`.
- Keep every `SKILL.md` under `skills/<skill-name>/`. A `SKILL.md` elsewhere in the repo may be discovered and published accidentally.
- Keep the layout flat: `skills/<skill-name>/SKILL.md`, not deeper nested directories unless something is intentionally stored under that skill's own subfolders.

## Required skill manifest format

Every `skills/<skill-name>/SKILL.md` must begin with YAML frontmatter in this form:

```yaml
---
name: skill-name
description: Performs a specific task. Use when the user asks to <trigger>.
license: MIT # recommended
---
```

Rules:

- `name` and `description` are required. `license` is optional but recommended.
- `name` must exactly match the directory name.
- `name` must match `^[a-z0-9]+(-[a-z0-9]+)*$` and be no longer than 64 characters.
- `description` must be no more than 1024 characters.
- Write the description in the third person and make it actionable: state what the skill does, then state the trigger conditions or user requests that should select it.
- Prefer concrete wording such as "Lints a Rust workspace with clippy and explains each warning" over vague labels such as "Rust helper".
- Keep frontmatter valid YAML. If punctuation could be interpreted as YAML syntax, quote the description.
- Keep each `SKILL.md` to 500 lines or fewer. Move long-form guidance into `references/` and link to it from the manifest.
- A skill that is internal or not meant for default installation must include:

```yaml
metadata:
  internal: true
```

This is a repository-level convention. Internal-only skills should be excluded from default installs unless `INSTALL_INTERNAL_SKILLS=1` is set.

## Content and implementation rules

- Keep each skill self-contained. Do not reference files outside that skill directory.
- Do not require users to install dependencies or run setup commands as part of the skill itself.
- Prefer relative paths, local assets, and bundled scripts. Avoid host-specific absolute paths.
- Use `scripts/` for executable helpers only when necessary. Keep them tiny, portable, and reproducible.
- Do not add runtime code or package manifests to the repository unless the task explicitly requires it for a new skill's behavior.
- If a skill depends on external tools, document that requirement clearly and keep the dependency optional or clearly named; do not silently assume the environment has it.
- If a skill is a work-in-progress or intentionally limited, state that in the manifest and docs rather than leaving ambiguity.

## Creating a skill

1. Create the directory `skills/<skill-name>/`.
2. Add `SKILL.md` with valid frontmatter and a useful description.
3. Keep additional files inside the same skill directory only.
4. Prefer concise, clear instructions focused on the initial invocation and the main use cases.
5. Run `./scripts/validate.sh` from the repository root and fix any reported errors or warnings.
6. If end-to-end installation testing is needed, do it in an isolated test location. Do not alter a user's existing agent profile or installation location unless they explicitly ask you to.

## Good and bad description examples

Good:

- `Lints a Rust workspace with clippy and explains each warning. Use when the user asks to lint, audit, or clean up Rust code.`
- `Creates a small TypeScript project scaffold with strict config and example code. Use when the user asks to initialize or bootstrap a TypeScript app.`

Bad:

- `A skill for Rust`
- `Code quality helper`
- `Useful tooling`

These descriptions are too vague and do not tell the discovery system or the user when the skill should be selected.

## Validation and release policy

- `./scripts/validate.sh` is the repository's structural and metadata check. It verifies skill discovery, YAML metadata, layout, and repository hygiene.
- CI runs this validator on pushes and pull requests. Run it before requesting review or proposing a change.
- Do not commit, push, or publish unless the user explicitly asks you to do so.
- When asked to commit a skill change, keep each skill in its own commit and use a Conventional Commit message such as `feat: add my-skill`.
- The `skills.sh` index reflects the repository on GitHub, so local or unpushed changes are not visible to users. Push to `main` only when you are explicitly asked and authorized to do so.
- Treat the manifest and directory structure as a public contract. If a change could accidentally publish a misplaced or duplicated `SKILL.md`, fix it before review.
