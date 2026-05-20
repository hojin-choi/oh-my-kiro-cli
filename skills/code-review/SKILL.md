---
name: code-review
description: Comprehensive code review for quality, security, and maintainability with severity-rated feedback. Use when reviewing a PR, after implementing a major feature, or when a quality assessment is needed.
argument-hint: ""
---

Conduct a thorough code review using two parallel lanes — a code/security lane and an
architecture/tradeoff lane — then synthesize into a single deterministic verdict.

## When to Use

- User requests "review this code" or "code review"
- Before merging a pull request
- After implementing a major feature
- User wants a quality assessment

## Review Process

1. **Identify Changes**
   - Run `git diff` to find changed files
   - Determine scope (specific files or entire diff)

2. **Launch Parallel Review Lanes** (run simultaneously)
   - **Code lane**: spec compliance, security, code quality, performance, maintainability
   - **Architect lane**: system boundaries, hidden coupling, tradeoff tensions, devil's advocate

3. **Severity Rating**
   - **CRITICAL** — Security vulnerability (must fix before merge)
   - **HIGH** — Bug or major code smell (should fix before merge)
   - **MEDIUM** — Minor issue (fix when possible)
   - **LOW** — Style/suggestion (consider fixing)

4. **Architectural Status**
   - **CLEAR** — No unresolved architectural blocker
   - **WATCH** — Non-blocking design concern (must appear in synthesis)
   - **BLOCK** — Unresolved design concern that prevents merge-ready verdict

5. **Final Synthesis** (deterministic rules)
   - Architect `BLOCK` → **REQUEST CHANGES**
   - Code lane `REQUEST CHANGES` → **REQUEST CHANGES**
   - Architect `WATCH` → **COMMENT**
   - Otherwise → follow code lane verdict

## Review Checklist

### Security
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs sanitized
- [ ] SQL/NoSQL injection prevention
- [ ] XSS prevention (escaped outputs)
- [ ] Authentication/authorization properly enforced

### Code Quality
- [ ] Functions < 50 lines (guideline)
- [ ] Cyclomatic complexity < 10
- [ ] No deeply nested code (> 4 levels)
- [ ] No duplicate logic (DRY)
- [ ] Clear, descriptive naming

### Performance
- [ ] No N+1 query patterns
- [ ] Appropriate caching where applicable
- [ ] Efficient algorithms
- [ ] No unnecessary re-renders

### Best Practices
- [ ] Error handling present and appropriate
- [ ] Logging at appropriate levels
- [ ] Documentation for public APIs
- [ ] Tests for critical paths
- [ ] No commented-out code

## Output Format

```
CODE REVIEW REPORT
==================
Files Reviewed: N
Total Issues: N
Architectural Status: CLEAR|WATCH|BLOCK

CRITICAL (N)
------------
...

HIGH (N)
--------
...

MEDIUM (N)
----------
1. src/foo.ts:42
   Issue: ...
   Risk: ...
   Fix: ...

LOW (N)
-------
...

ARCHITECTURE
------------
...

SYNTHESIS
---------
- Code lane: APPROVE|COMMENT|REQUEST CHANGES
- Architect status: CLEAR|WATCH|BLOCK
- Final recommendation: APPROVE|COMMENT|REQUEST CHANGES
```

## Approval Criteria

- **APPROVE** — Code lane APPROVE + Architect CLEAR
- **REQUEST CHANGES** — Code lane REQUEST CHANGES or Architect BLOCK
- **COMMENT** — Only LOW/MEDIUM issues remain, or Architect WATCH
