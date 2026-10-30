---
name: test-naming
description: "Helps create, rename, and review clear, accurate test titles grounded in asserted behavior and local conventions for JavaScript and TypeScript suites, including Jest, Vitest, Playwright, and Cypress; use when the user asks to name or improve test titles."
license: MIT
---

# Test Naming

Write test titles that tell the reader exactly what the test proves and what condition makes it pass or fail. The title should help someone understand a failure from the test report without opening the file. Apply these rules to JavaScript and TypeScript suites, including Jest, Vitest, Playwright, Cypress, and similar frameworks.

## Workflow

1. **Inspect the test and its context.** Read the assertions, setup, fixtures, framework title syntax, and parent suite names before deciding on a title. For a rename or review, check nearby tests to match the repository's conventions without copying vague wording.
2. **Identify the verified contract.** Pin down the observable behavior the test actually asserts: the result, returned value, side effect, state change, rejection, or interaction that the assertions check.
3. **Draft a precise title.** State the outcome and include a condition when it changes the contract or distinguishes this case from related tests. Avoid narrating setup steps or inventing details that are not established by the test.
4. **Check the title against the test.** Make sure it does not claim more or less than the assertions verify, and that it remains understandable in the full suite output alongside any parent titles.
5. **Follow the requested scope.** For review work, explain the issue and suggest a replacement title; do not edit files unless asked. For renames, change only the requested titles. Do not change logic, assertions, fixtures, or production code unless separately requested.
6. **Surface uncertainty.** If the setup or assertions do not establish the behavior clearly enough for an accurate title, do not guess. Explain the ambiguity and ask for clarification when it cannot be resolved from nearby code.

## Naming Principles

- **Describe the asserted behavior, not the implementation.** Prefer the observable result, returned value, state change, error, or externally meaningful interaction over incidental details such as helper names, internal calls, or mock setup.
  - **Prefer:** `persists the session token after a successful login`
  - **Avoid:** `calls setItem`
- **Choose verbs that match the assertion.** Distinguish a synchronous throw from a rejected promise when the test does; describe resolved values, rendered state, or emitted events according to what is actually observed.
- **Name the interaction when it is the contract.** Some tests intentionally verify collaboration or a dependency call rather than a user-visible outcome. Name the relevant actor and interaction; include arguments, counts, or ordering only when the assertions verify them.
- **Include the distinguishing condition.** Name the input, state, role, event, boundary, or context that separates this case from the related ones. Avoid generic titles such as `handles invalid input`.
  - **Prefer:** `rejects uploads larger than the configured size limit`
  - **Avoid:** `handles invalid uploads`
- **Make negative outcomes explicit.** State what is rejected, prevented, denied, or absent, and include the relevant condition when the reader needs it.
  - **Prefer:** `does not retry the request after a 401 response`
  - **Avoid:** `does not work with expired tokens`
- **Represent the test's claim, not every step.** If a test checks several details of one contract, use a title that accurately covers their shared outcome. Do not turn setup actions or assertion mechanics into a step-by-step title; do not split or rewrite the test unless asked.
- **Keep it concise, but do not strip meaning.** Remove filler words that add no information. `should` and `correctly` are not automatically wrong, but they are only useful when they convey the actual expectation or match the local style.
- **Use parent suite titles as context.** Avoid repeating information already clear from the enclosing `describe` or suite name, while keeping the individual title understandable on its own.
- **Match local conventions when they are clear.** Follow the neighboring tests' capitalization, tense, punctuation, and phrasing unless doing so would make the title less accurate or less informative.
- **Do not invent values or behavior.** Use concrete values and names only when they are present in the actual test or are required by the asserted scenario; do not create example values just to make a title sound more specific.

## Useful Title Patterns

A common pattern is:

> `[verified outcome] when [distinguishing condition]`

This is a starting point, not a required formula. Other structures, such as `given [context]`, `while [state]`, or event-driven titles, can be clearer for a specific test.

| Verified case            | Example title                                                   |
| ------------------------ | --------------------------------------------------------------- |
| Successful outcome       | `returns discounted pricing when the account qualifies`         |
| Rejection                | `rejects the upload when the file exceeds its configured limit` |
| Non-occurrence           | `does not send a notification when alerts are disabled`         |
| State-dependent behavior | `disables submit while payment is processing`                   |
| Error contract           | `throws InvalidTokenError when the token signature is invalid`  |

Use actual error names, configured thresholds, units, and values when they matter to the assertion. When a boundary value matters, use the value exercised by the test and the relevant configured limit; do not guess or substitute illustrative values.

## Parameterized Tests

- Make each generated title identify the case that distinguishes it when the data changes the expected behavior.
- Preserve the framework's interpolation syntax and conventions; do not introduce unsupported placeholders.
- Include a value in the rendered title only when it helps the reader understand which case failed or what condition was exercised; raw data that does not distinguish behavior can make reports noisy.
- Check representative rendered titles, not only the raw template, when the framework makes that practical. Ensure placeholders produce useful output rather than missing, ambiguous, or duplicated values.

## Final Review Checklist

Before proposing or applying a title, confirm:

- It describes what the assertions verify, not what the author may have intended.
- The outcome and any necessary condition are specific and unambiguous.
- Any negative result is stated explicitly.
- It does not duplicate context already supplied by the parent suite title.
- It follows local conventions without sacrificing accuracy or clarity.
- It makes sense in test output, including for parameterized cases.
- Its verbs accurately describe the observed result, including sync errors versus async rejections where relevant.
