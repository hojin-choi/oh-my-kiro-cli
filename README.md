# oh-my-kiro-cli

> Workflow harness for [Kiro CLI](https://kiro.dev/docs/cli/) — skills, agents, and hooks inspired by [oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode).

## What is this?

A curated collection of **Skills**, **Agents**, and **Hooks** for Kiro CLI.  
No extra CLI, no TypeScript runtime — just markdown, JSON, and shell scripts that plug directly into Kiro's native extension points.

```
oh-my-kiro-cli/
├── skills/     # Skill markdown files (skill:// resources)
├── agents/     # Agent JSON configurations
└── hooks/      # Hook shell scripts
```

## Install

Requirements: **Node.js 22+** (LTS or current). Earlier Node versions are no longer security-supported upstream.

| Method | Command | Reviewability |
|---|---|---|
| npm (recommended) | `npm i -g oh-my-kiro-cli@<version>` then `oh-my-kiro-cli setup` | medium |
| git clone | `git clone ... && less install.sh && ./install.sh` | high |

**npm** (recommended):

```bash
npm i -g oh-my-kiro-cli@0.1.4
oh-my-kiro-cli setup
```

Always pin to a specific version (`@0.1.4`). Running `oh-my-kiro-cli setup` is a separate explicit step — nothing is written to `~/.kiro` until you run it.

Setup options:
- `--with-hooks` — also install hook scripts (opt-in)
- `--force` — overwrite user-owned items in `~/.kiro` after creating a `.bak.<timestamp>` backup
- `--link` — symlink instead of copy (git-clone installs only)

By default, same-name skills or agents that lack the `.oh-my-kiro-managed` marker are treated as user-owned and skipped. Pass `--force` once when upgrading from a pre-0.1.4 install to take over the marker.

**git clone** (highest reviewability):

```bash
git clone https://github.com/hojin-choi/oh-my-kiro-cli ~/.oh-my-kiro-cli
cd ~/.oh-my-kiro-cli
git checkout v0.1.4
less install.sh   # review first
./install.sh
```

Verifying the npm artifact (optional but recommended for supply-chain auditing):

```bash
npm view oh-my-kiro-cli@0.1.4 dist.attestations
# Expect: provenance.predicateType = https://slsa.dev/provenance/v1
# Publisher: GitHub Actions (Trusted Publisher), not a personal npm token.
```

## How it works

| Kiro concept | This repo |
|---|---|
| `~/.kiro/skills/` | `skills/*/SKILL.md` |
| `~/.kiro/agents/` | `agents/*.json` |
| Hook scripts | `hooks/*.sh` |

Skills are loaded on-demand when Kiro's agent determines they're relevant based on the skill description.  
Agents can be switched with `/agent` inside a Kiro CLI session.

## Skills

| Skill | Description |
|---|---|
| `deep-interview` | Socratic clarification loop before execution. Use when requirements are vague or ambiguous. |
| `autopilot` | Full autonomous execution from idea to working code across planning, implementation, QA, and validation. |
| `ralph` | PRD-driven persistence loop that keeps working until all acceptance criteria are verified. |
| `ralplan` | Consensus planning with Planner/Architect/Critic loop before any code is written. |
| `code-review` | Parallel two-lane code review (code quality + architecture) with deterministic verdict. |
| `deepsearch` | Multi-strategy codebase search across symbols, usages, and structural patterns. |

## Agents

| Agent | Description |
|---|---|
| `architect` | Strategic architecture & debugging advisor. Read-only analysis with file:line evidence. |
| `code-reviewer` | Severity-rated code review with SOLID/security checks. Read-only. |
| `critic` | Final quality gate with multi-perspective review and pre-commitment predictions. Read-only. |
| `debugger` | Root-cause analysis with 3-failure circuit breaker. |
| `executor` | Minimal-diff implementation specialist. |
| `planner` | Structured planning consultant. Creates plans only, never implements. |
| `security-reviewer` | OWASP Top 10 analysis and secrets detection. Read-only. |
| `qa-tester` | Behavior verification with evidence capture and clean teardown. |

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT
