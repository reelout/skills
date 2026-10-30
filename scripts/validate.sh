#!/usr/bin/env bash
#
# Validate the structure and metadata of every skill in this repository.
# This is the repo's only "test suite" — run it before every commit.
#
# Usage:
#   ./scripts/validate.sh            # validate the repo this script lives in
#   ./scripts/validate.sh <path>     # validate another checkout
#
# Exit codes: 0 = no errors, 1 = validation errors found.

set -u

if [ $# -ge 1 ]; then
  ROOT=$1
else
  ROOT=$(cd "$(dirname "$0")/.." && pwd)
fi
ROOT=${ROOT%/}
[ -n "$ROOT" ] || ROOT=/

ERRORS=0
WARNINGS=0
SKILLS=0

err()  { printf '  ERROR: %s\n' "$1"; ERRORS=$((ERRORS + 1)); }
warn() { printf '  WARN:  %s\n' "$1"; WARNINGS=$((WARNINGS + 1)); }

# Print the frontmatter value of `key:` from a SKILL.md (single-line values).
fm_value() { # $1 = file, $2 = key
  awk -v key="$2" '
    NR == 1 { if ($0 != "---") exit 1; infm = 1; next }
    infm && $0 == "---" { exit }
    infm && $0 ~ "^" key ":" {
      sub("^" key ":[ ]*", "")
      gsub(/^[ ]+|[ ]+$/, "")
      print
      exit
    }
  ' "$1"
}

printf 'Validating skills in %s\n' "$ROOT"

SKILLS_DIR="$ROOT/skills"
for dir in "$SKILLS_DIR"/*/; do
  [ -d "$dir" ] || continue
  name_dir=$(basename "$dir")
  case "$name_dir" in
    .*|node_modules) continue ;;
  esac

  printf '\n[%s]\n' "$name_dir"
  SKILLS=$((SKILLS + 1))
  skill_md="$dir/SKILL.md"

  if [ ! -f "$skill_md" ]; then
    err "missing SKILL.md (expected skills/$name_dir/SKILL.md)"
    continue
  fi

  first_line=$(head -n 1 "$skill_md")
  if [ "$first_line" != "---" ]; then
    err "SKILL.md must start with YAML frontmatter (first line '---')"
    continue
  fi

  fm_name=$(fm_value "$skill_md" name)
  fm_desc=$(fm_value "$skill_md" description)

  if [ -z "$fm_name" ]; then
    err "frontmatter: missing 'name'"
  else
    if [ "$fm_name" != "$name_dir" ]; then
      err "frontmatter name '$fm_name' does not match directory '$name_dir'"
    fi
    case "$fm_name" in
      *[!a-z0-9-]*)
        err "name '$fm_name' must be lowercase kebab-case [a-z0-9-]" ;;
      -*) err "name '$fm_name' must not start with a hyphen" ;;
      *-) err "name '$fm_name' must not end with a hyphen" ;;
    esac
    if [ ${#fm_name} -gt 64 ]; then
      err "name '$fm_name' is longer than 64 characters"
    fi
  fi

  if [ -z "$fm_desc" ]; then
    err "frontmatter: missing 'description'"
  else
    if [ ${#fm_desc} -gt 1024 ]; then
      err "description is longer than 1024 characters"
    fi
    if [ ${#fm_desc} -lt 30 ]; then
      warn "description is shorter than 30 chars — it is the skill's only trigger; say what it does and when to use it"
    fi
  fi

  lines=$(wc -l < "$skill_md" | tr -d ' ')
  if [ "$lines" -gt 500 ]; then
    warn "SKILL.md is $lines lines — move detail into references/ (progressive disclosure)"
  fi

  if [ -z "$(fm_value "$skill_md" license)" ]; then
    warn "no 'license' in frontmatter — skills.sh displays licenses; consider adding one"
  fi
done

# Junk files must never be committed — they get installed onto users' machines.
junk=$(find "$ROOT" \( -name .git -o -name node_modules \) -type d -prune -o \
  -type f \( -name '.DS_Store' -o -name '*.orig' -o -name '*~' \) -print 2>/dev/null)
if [ -n "$junk" ]; then
  printf '\n[junk files]\n'
  while IFS= read -r f; do
    err "junk file committed: ${f#"$ROOT"/}"
  done <<< "$junk"
fi

# node_modules files must never be committed.
if git -C "$ROOT" ls-files --cached | grep -qE '(^|/)node_modules/'; then
  err "node_modules files are tracked by Git"
fi

# Every SKILL.md must live at skills/<name>/SKILL.md. The CLI also discovers
# root-level skills (depth-1 walk) and nested ones via fallback, so a SKILL.md
# outside the container would be published unintentionally.
while IFS= read -r f; do
  rel=${f#"$ROOT"/}
  case "$rel" in
    skills/*) ;;
    *) err "SKILL.md outside skills/: $rel — the CLI discovers root-level skills too; move it under skills/" ;;
  esac
  depth=$(awk -F/ '{print NF - 1}' <<< "$rel")
  if [ "$depth" -gt 2 ]; then
    warn "SKILL.md not in flat layout: $rel (expected skills/<name>/SKILL.md)"
  fi
done < <(find "$ROOT" -name .git -type d -prune -o -type f -name SKILL.md -print 2>/dev/null)

printf '\n%d skill(s) checked, %d error(s), %d warning(s)\n' "$SKILLS" "$ERRORS" "$WARNINGS"

if [ "$SKILLS" -eq 0 ]; then
  printf 'No skills found in skills/ — nothing to validate beyond repo hygiene.\n'
fi

[ "$ERRORS" -eq 0 ] || exit 1
exit 0
