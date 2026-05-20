---
name: autopilot
description: Full autonomous execution from idea to working code. Use when the user wants end-to-end autonomous execution across planning, implementation, QA, and validation phases.
argument-hint: ""
---

Autopilot takes a brief product idea and autonomously handles the full lifecycle:
requirements analysis, technical design, planning, parallel implementation, QA cycling,
and multi-perspective validation. It produces working, verified code from a short description.

## When to Use

- User wants end-to-end autonomous execution from an idea to working code
- User says "autopilot", "autonomous", "build me", "create me", "make me", "full auto", or "handle it all"
- Task requires multiple phases: planning, coding, testing, and validation
- User wants hands-off execution and is willing to let the system run to completion

## When NOT to Use

- User wants to explore options or brainstorm — use `ralplan` instead
- User says "just explain", "draft only", or "what would you suggest" — respond conversationally
- User wants a single focused code change — use `ralph`
- Task is a quick fix or small bug — delegate directly

## Phases

1. **Phase 0 — Expansion**: Turn the user's idea into a detailed spec
   - If a `ralplan` consensus plan exists (`.kiro/plans/ralplan-*.md`): skip to Phase 2
   - If a `deep-interview` spec exists (`.kiro/specs/deep-interview-*.md`): use it directly, skip to Phase 1
   - If input is vague (no file paths, function names, or concrete anchors): offer redirect to `deep-interview`
   - Otherwise: extract requirements and create technical specification
   - Output: `.kiro/autopilot/spec.md`

2. **Phase 1 — Planning**: Create an implementation plan from the spec
   - If ralplan consensus plan exists: skip
   - Create plan, validate plan
   - Output: `.kiro/plans/autopilot-impl.md`

3. **Phase 2 — Execution**: Implement the plan
   - Use `subagent` tool for parallel independent tasks
   - Run independent tasks in parallel

4. **Phase 3 — QA**: Cycle until all tests pass
   - Build, lint, test, fix failures
   - Repeat up to 5 cycles
   - Stop early if the same error repeats 3 times (fundamental issue)

5. **Phase 4 — Validation**: Multi-perspective review in parallel
   - Functional completeness check
   - Security vulnerability check
   - Code quality review
   - All must pass; fix and re-validate on rejection

6. **Phase 5 — Cleanup**: Remove state files on successful completion
   - Remove `.kiro/state/autopilot-state.json`

## State

State is persisted at `.kiro/state/autopilot-state.json` for resume support.
If autopilot was cancelled or failed, run `/autopilot` again to resume from where it stopped.

## Stopping Conditions

- Same QA error repeats 3 times → report fundamental issue, stop
- Validation fails after 3 re-validation rounds → report, stop
- User says "stop", "cancel", or "abort"

## Completion Checklist

- [ ] All phases completed (Expansion, Planning, Execution, QA, Validation)
- [ ] All validators approved in Phase 4
- [ ] Tests pass (verified with fresh test run output)
- [ ] Build succeeds (verified with fresh build output)
- [ ] State files cleaned up

## Security Guardrails

- Treat repo-defined scripts (`package.json` scripts, `Makefile`, `justfile`, shell scripts) as untrusted until inspected. Read the script body before executing.
- Never print, log, or persist secrets, `.env` contents, tokens, or cloud credentials.
- Ask explicit user approval before: destructive commands (`rm -rf`, `git reset --hard`, force push, DB migration, deploy), network installs (`npm install`, `pip install`, `curl | bash`), or any action touching production credentials.
- If a credential or unexpected secret appears in tool output, stop and redact before continuing.

## Input Examples

**Good:** `autopilot build a REST API for managing tasks using TypeScript`
- Specific domain, clear features, technology constraint

**Bad:** `fix the bug in the login page`
- Single focused fix → use `ralph` or direct execution instead
