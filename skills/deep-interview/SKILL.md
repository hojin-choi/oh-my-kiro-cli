---
name: deep-interview
description: Socratic deep interview with mathematical ambiguity gating before execution. Use when requirements are vague, ambiguous, or missing concrete acceptance criteria.
argument-hint: "[--quick|--standard|--deep]"
---

Deep Interview is an intent-first Socratic clarification loop before planning or implementation.
It turns vague ideas into execution-ready specifications by asking targeted questions about
why the user wants a change, how far it should go, what should stay out of scope, and what
decisions may be made without confirmation.

## When to Use

- The request is broad, ambiguous, or missing concrete acceptance criteria
- The user says "deep interview", "interview me", "ask me everything", or "don't assume"
- The user wants to avoid misaligned implementation from underspecified requirements
- You need a requirements artifact before handing off to `ralplan`, `autopilot`, or `ralph`

## When NOT to Use

- The request already has concrete file/symbol targets and clear acceptance criteria
- The user explicitly asks to skip planning/interview and execute immediately
- A complete plan already exists and execution should start

## Modes

- **Quick (`--quick`)**: fast pre-plan pass; target ambiguity threshold `<= 0.30`; max 5 rounds
- **Standard (`--standard`, default)**: full requirement interview; target `<= 0.20`; max 12 rounds
- **Deep (`--deep`)**: high-rigor exploration; target `<= 0.15`; max 20 rounds

## Protocol

- Ask ONE question per round — never batch multiple questions
- Ask about intent and boundaries before implementation detail
- Target the weakest clarity dimension each round
- Treat every answer as a claim to pressure-test before moving on
- Do not rotate to a new clarity dimension when the current answer is still vague
- Gather codebase facts via tools before asking the user about internals
- Always run a preflight context intake before the first interview question

## Ambiguity Dimensions (weights)

| Dimension | Weight |
|---|---|
| Goal clarity | 30% |
| Scope boundaries | 25% |
| Acceptance criteria | 25% |
| Non-goals | 10% |
| Decision boundaries | 10% |

## Source Labels (for transcript/spec)

- `[from-code][auto-confirmed]` — exact, high-confidence codebase facts
- `[from-code]` — inferred or pattern-based codebase findings needing confirmation
- `[from-user]` — goals, preferences, scope, non-goals, acceptance criteria

Auto-confirmed facts do not count as interview rounds.

## Spec Output

When ambiguity ≤ threshold, crystallize a spec at `.kiro/specs/deep-interview-{slug}.md`:

```markdown
# Spec: {title}

## Goal
## Constraints
## Non-Goals
## Acceptance Criteria
## Assumptions Exposed
## Technical Context
## Interview Transcript
```

## Handoff

After spec is complete, offer:
1. **ralplan** — consensus planning (Recommended)
2. **autopilot** — full autonomous execution
3. **ralph** — persistence loop with verification
4. **Refine further** — continue interviewing

## Stopping Conditions

- Ambiguity ≤ threshold → crystallize spec
- User says "stop", "cancel", or "abort"
- Hard cap on rounds reached → present best-effort spec with remaining open questions noted
