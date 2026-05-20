---
name: ralplan
description: Consensus planning with Planner/Architect/Critic loop before execution. Use when a task needs scoping, tradeoff analysis, and a verified plan before any code is written.
argument-hint: "[--interactive] [--deliberate]"
---

Ralplan runs iterative consensus planning — Planner creates a plan, Architect reviews for
soundness, Critic validates quality — looping until consensus is reached. The result is a
`pending approval` plan artifact. No code is written until the user explicitly approves.

## When to Use

- Task needs scoping before execution (vague `ralph`/`autopilot` requests)
- User says "ralplan", "plan this", or "plan before doing"
- High-risk work: auth/security, migrations, destructive changes, public API changes
- User wants to review tradeoffs before committing to an approach

## When NOT to Use

- Request already has concrete file paths, function names, or a numbered task list — execute directly
- A plan already exists and execution should start — use `ralph` or `autopilot`

## Planning/Execution Boundary

Ralplan is a **planning module only**. Before explicit execution approval it MUST NOT:
- Run mutation shell commands
- Edit source files
- Commit, push, or open PRs
- Delegate implementation tasks

All plan artifacts are marked `pending approval` until the user explicitly approves.

## Flags

- `--interactive`: Prompts user at draft review (Step 2) and final approval (Step 6)
- `--deliberate`: Forces high-rigor mode — adds pre-mortem (3 scenarios) and expanded test planning

Deliberate mode also auto-enables when the request signals high risk:
auth/security, migrations, destructive changes, production incidents, compliance/PII, public API breakage.

## Consensus Workflow

1. **Planner** creates initial plan with a compact decision summary:
   - Principles (3–5)
   - Decision Drivers (top 3)
   - Viable Options (≥2) with bounded pros/cons
   - Deliberate mode only: pre-mortem (3 scenarios) + expanded test plan

2. **User feedback** *(--interactive only)*: Present draft plan before review.
   Otherwise, automatically proceed.

3. **Architect** reviews for architectural soundness — must provide:
   - Strongest steelman antithesis
   - At least one real tradeoff tension
   - Synthesis where possible
   - **Await completion before Step 4**

4. **Critic** evaluates (run only after Step 3 completes):
   - Principle-option consistency
   - Fair alternatives
   - Risk mitigation clarity
   - Testable acceptance criteria
   - Concrete verification steps

5. **Re-review loop** (max 5 iterations):
   Any non-`APPROVE` Critic verdict triggers: collect feedback → revise → Architect → Critic → repeat
   If 5 iterations reached without `APPROVE`, present best version to user.

6. On Critic approval, mark plan `pending approval`.
   *(--interactive only)*: Present plan with execution options:
   - Approve execution via `ralph`
   - Approve execution via `autopilot`
   - Request changes
   - Reject

7. *(--interactive only)* On approval: invoke `ralph` or `autopilot` with the plan.

## Plan Output

Final plan saved to `.kiro/plans/ralplan-{slug}.md` with:
- Decision, Drivers, Alternatives considered, Why chosen, Consequences, Follow-ups (ADR format)
- All acceptance criteria testable and concrete
- Marked `pending approval` until user approves

## Pre-Execution Gate

Ralplan intercepts underspecified execution requests and redirects them through consensus planning.

**Passes the gate** (specific enough for direct execution):
- `ralph fix the null check in src/hooks/bridge.ts:326`
- `autopilot implement issue #42`
- `ralph do:\n1. Add input validation\n2. Write tests`

**Gated — redirected to ralplan** (needs scoping first):
- `ralph fix this`
- `autopilot build the app`
- `ralph add authentication`

**Bypass the gate:**
- Prefix with `force:` or `!` (e.g., `force: ralph refactor the auth module`)

The gate auto-passes when ANY concrete signal is present:
file path, issue/PR number, camelCase/PascalCase/snake_case symbol, test runner command,
numbered steps, acceptance criteria, error reference, code block, or escape prefix.
