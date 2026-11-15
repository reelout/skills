---
name: vanilla-extract-style-ordering
description: Reorders vanilla-extract style properties and createVar declarations according to the repository's CSS property order and explicit mapping rules. Use when the user asks to organize or reorder vanilla-extract styles.
license: MIT
---

# Vanilla Extract Style Ordering

Reorder CSS properties and `createVar()` declarations without changing their meaning or the boundaries of their existing style objects and declaration groups.

## Scope

- Reorder CSS properties only within their existing style object or block.
- Reorder `createVar()` declarations only within a contiguous group of `createVar()` declarations.
- Do not move declarations across style objects or blocks.
- Do not split, merge, or otherwise restructure style objects.
- Do not move properties into or out of a style object.
- Keep shared references outside style objects; do not inline them.

## Determine the Property Order

Use the `properties` arrays in `stylelint-config-recess-order/groups.js` as the source of truth:

1. Prefer the version installed in the project.
2. If the package is not installed, fetch `groups.js` from UNPKG. Use the version pinned by the project, if available; otherwise use the latest version:
   - `https://unpkg.com/stylelint-config-recess-order@<version>/groups.js`
   - `https://unpkg.com/stylelint-config-recess-order/groups.js`
3. If UNPKG is unavailable, download and inspect the package tarball from npmjs, preferring the pinned version or, if none is pinned, the latest published version.
4. If neither source is available, check for another explicitly documented property-order source in the project. If none exists, leave CSS properties and corresponding `createVar()` declarations in their current order, and ask the user which order to apply.

Do not install the package or modify project dependencies or lockfiles.

Flatten the `properties` arrays in their declared order. Sort recognized properties by their index in the flattened list, preserving source order when properties have the same index.

## Apply the Order

- Keep the `vars` field and CSS custom properties (for example, `--theme-color`) at the beginning of each style block. Preserve their existing order relative to one another.
- For `createVar()` declarations, use each identifier as the corresponding CSS property name when determining its order. Remove a trailing `var` suffix before matching (for example, `fontSizeVar` maps to `fontSize`), and map `outset` to `inset`.
- Treat `icon` as part of the `font` group, after other font properties such as `fontSize` and `lineHeight`.
- When variant suffixes occur in the same ordering scope, use this order: base (no suffix), `hover`, `focus`, `active`, `checked`, `checked-hover`, `checked-focus`, `checked-active`, `disabled`.
- Do not infer an order for unknown properties or variable names. Leave them in their original positions and preserve their relative order while sorting recognized entries.

## Shorthands

Combine related longhand properties into a shorthand only when all required values are literals and the shorthand is semantically equivalent. Do not combine variable, referenced, or otherwise non-literal values. Place the shorthand before any remaining longhand properties with the same prefix.

## Verify the Result

Confirm that style object boundaries, property values, shared references, and CSS behavior are unchanged. The only intended changes are declaration ordering and safe shorthand consolidation.
