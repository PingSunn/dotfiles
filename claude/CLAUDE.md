# Global Instructions

## Git
- Do NOT add a Claude `Co-Authored-By` trailer (or any AI co-author) to commit messages in any project. Write commit messages without it.

## Skills
- `/grill-with-docs` — use whenever I express that I want to build, change, or do something non-trivial (a feature, design, decision, or task) — interview me to sharpen the intent BEFORE acting — and ALWAYS run it when entering Plan Mode, not only then. (Stress-tests the idea; also writes ADRs + glossary as we go.) Skip only for trivial/quick asks (a simple question, a one-line edit).
- `/caveman` — proactively switch to this on long or list-heavy answers, not just when I ask. BUT never let caveman compression drop the rationale, evidence, or `file:line` citations in a `/scrutinize` or code-review output — keep those findings complete even in caveman mode.
- `karpathy-guidelines` — ALWAYS follow these guidelines whenever writing, editing, or refactoring code (apply every time, automatically — do not wait to be asked).
- `/scrutinize` — run automatically whenever a feature or task is complete (to check the work), and before pushing or opening an MR; at that stage focus on tracing the real code paths and verifying the behavior actually matches what was intended (don't re-question scope — that was settled earlier when we grilled the intent with `/grill-with-docs`). Also run whenever I ask to review, audit, or sanity-check a plan, PR, diff, or design.

## Documentation
- Use Context7 to fetch current docs whenever I ask about any library, framework, SDK, API, CLI tool, or cloud service — even well-known ones, and even when you think you already know the answer. Prefer it over web search for library docs.

## When unsure
- Do NOT assume. If you are not sure what I mean or what I want, ask me to clarify before acting.