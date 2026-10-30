# Skills

This repository hosts a curated collection of installable agent skills for AI coding assistants. Each skill is packaged as a self-contained directory under `skills/`, with a `SKILL.md` manifest that describes what it does and when it should be used.

## Install

```sh
npx skills add aicest/skills
```

This command installs the published skills in this repo into your local agent tooling.

## Development

Install the development dependencies to enable the Git hooks:

```bash
pnpm install
```

Husky runs lint-staged before each commit. Staged Markdown files are formatted
with Prettier.
