---
name: ralph
description: Persistence loop that keeps working until ALL acceptance criteria are verified. Use when a task requires guaranteed completion with reviewer sign-off, not just best-effort.
argument-hint: "[--no-deslop]"
---

Ralph is a PRD-driven persistence loop that keeps working on a task until all user stories
have `passes: true` and are reviewer-verified. It wraps parallel execution with session
persistence, automatic retry on failure, structured story tracking, and mandatory verification
before completion.

## When to Use

- Task requires guaranteed completion with verification (not just "do your best")
- User says "ralph", "don't stop", "must complete", "finish this", or "keep going until done"
- Work may span multiple iterations and needs persistence across retries
- Task benefits from structured PRD-driven execution with reviewer sign-off

## When NOT to Use

- User wants a full autonomous pipeline from idea to code — use `autopilot` instead
- User wants to explore or plan before committing — use `ralplan` instead
- User wants a quick one-shot fix — delegate directly
- User wants manual control over completion — execute directly

## How It Works

Complex tasks often fail silently: partial implementations get declared "done", tests get
skipped, edge cases get forgotten. Ralph prevents this by:

1. Structuring work into discrete user stories with testable acceptance criteria (`prd.json`)
2. Iterating story-by-story until each one passes
3. Tracking progress and learnings across iterations (`progress.txt`)
4. Requiring fresh reviewer verification against specific acceptance criteria before completion

## Execution Loop

1. **PRD Setup** (first iteration only)
   - Check for existing PRD at `.kiro/state/prd.json`
   - If none exists, auto-generate a scaffold
   - **CRITICAL**: Replace generic acceptance criteria with task-specific, verifiable criteria
   - Initialize `progress.txt`

2. **Pick next story**: Select highest-priority story with `passes: false`

3. **Implement the story**
   - Use `subagent` tool for parallel independent tasks
   - If sub-tasks are discovered, add them as new stories to `prd.json`

4. **Verify acceptance criteria**
   - For EACH criterion, verify with fresh evidence
   - Run relevant checks (test, build, lint)
   - If any criterion is NOT met, continue working — do NOT mark complete

5. **Mark story complete**
   - Set `passes: true` in `prd.json`
   - Record progress in `progress.txt`

6. **Check PRD completion**
   - If NOT all stories complete → loop back to Step 2
   - If ALL complete → proceed to reviewer verification

7. **Reviewer verification**
   - Reviewer verifies against the SPECIFIC acceptance criteria from `prd.json`
   - On APPROVAL → proceed immediately to Step 7.5 (do NOT pause to report)
   - On REJECTION → fix issues, re-verify, loop back

7.5. **Cleanup pass** (unless `--no-deslop` specified)
   - Review changed files for unnecessary complexity, AI-generated verbosity, dead code
   - Scope bounded to files changed during this Ralph session only

7.6. **Regression re-verification**
   - Re-run all relevant tests, build, and lint after cleanup
   - Only proceed to completion after regression passes

8. **Completion**: Clean up state files

## State Files

- `.kiro/state/prd.json` — user stories with acceptance criteria and pass status
- `.kiro/state/progress.txt` — implementation log across iterations

## Flags

- `--no-deslop`: Skip the mandatory post-review cleanup pass (Step 7.5)

## Stopping Conditions

- All `prd.json` stories have `passes: true` AND reviewer approved → complete
- Fundamental blocker requiring user input (missing credentials, unclear requirements)
- Same issue recurs across 3+ iterations → report as potential fundamental problem
- User says "stop", "cancel", or "abort"

## Completion Checklist

- [ ] All `prd.json` stories have `passes: true`
- [ ] Acceptance criteria are task-specific (not generic boilerplate)
- [ ] All requirements from the original task are met
- [ ] Fresh test run output shows all tests pass
- [ ] Fresh build output shows success
- [ ] Reviewer verification passed against specific acceptance criteria
- [ ] Cleanup pass completed on changed files (or `--no-deslop` specified)
- [ ] Post-cleanup regression tests pass
- [ ] State files cleaned up

## PRD Refinement Example

**Bad scaffold (do not keep):**
```json
"acceptanceCriteria": ["Implementation is complete", "Code compiles without errors"]
```

**Good (task-specific):**
```json
"acceptanceCriteria": [
  "Function parseConfig returns null when input is missing required 'name' field",
  "All existing tests in src/__tests__/config.test.ts pass",
  "TypeScript compiles with no errors"
]
```
