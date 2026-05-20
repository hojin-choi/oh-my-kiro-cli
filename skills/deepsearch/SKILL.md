---
name: deepsearch
description: Deep codebase search and analysis. Use when searching for symbols, patterns, or understanding how something works across the codebase.
argument-hint: ""
---

Deepsearch performs a structured, multi-strategy codebase investigation to find where
something is defined, how it flows through the system, and what depends on it.

## When to Use

- User says "deepsearch", "search the codebase", or "find in the codebase"
- Locating where a symbol, pattern, or behavior is implemented
- Understanding data flow or call chains across multiple files
- Finding all usages of an interface, function, or configuration key

## When NOT to Use

- Simple single-file lookup — use `grep` or `code` tool directly
- User already knows the file location — read it directly

## Search Strategy

Run these lanes in parallel, then synthesize:

1. **Symbol search**: Find definitions and declarations
   - Use `code` tool (`search_symbols`, `lookup_symbols`) for semantic search
   - Use `grep` for literal pattern matching

2. **Usage search**: Find all call sites and references
   - Search for import statements, function calls, type references
   - Trace through re-exports and aliases

3. **Structural search**: Find patterns by code shape
   - Use `code` tool (`pattern_search`) for AST-based structural matching
   - Useful for finding all `async function` declarations, all `try/catch` blocks, etc.

## Output Format

```
DEEPSEARCH RESULTS
==================
Query: {query}

DEFINITIONS (N found)
---------------------
- path/to/file.ts:42 — brief description

USAGES (N found)
----------------
- path/to/caller.ts:88 — how it's used

RELATED (N found)
-----------------
- path/to/related.ts:12 — why it's related

SUMMARY
-------
{1-3 sentence synthesis of findings}

SUGGESTED NEXT STEPS
--------------------
- ...
```

## Tips

- Start broad, then narrow: search for the symbol name first, then filter by context
- Check both the definition file and its index/barrel exports
- For configuration keys, search both the definition and all read sites
- For interfaces, search both implementations and consumers
