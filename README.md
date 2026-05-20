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

| Method | Command | Reviewability |
|---|---|---|
| npm (recommended) | `npm i -g oh-my-kiro-cli@<version>` then `oh-my-kiro-cli setup` | medium |
| git clone | `git clone ... && less install.sh && ./install.sh` | high |
| curl \| bash | see below | low |

**npm** (recommended):

```bash
npm i -g oh-my-kiro-cli@0.1.1
oh-my-kiro-cli setup
```

Always pin to a specific version (`@0.1.1`). Running `oh-my-kiro-cli setup` is a separate explicit step — nothing is written to `~/.kiro` until you run it.

Setup options:
- `--link` — symlink instead of copy (for contributors/development only)
- `--with-hooks` — also install hook scripts (opt-in)

**git clone** (highest reviewability):

```bash
git clone https://github.com/hojin-choi/oh-my-kiro-cli ~/.oh-my-kiro-cli
cd ~/.oh-my-kiro-cli
git checkout v0.1.1
less install.sh   # review first
./install.sh
```

<details>
<summary>curl | bash (convenience only — not recommended)</summary>

```bash
curl -fsSL https://raw.githubusercontent.com/hojin-choi/oh-my-kiro-cli/v0.1.1/install.sh | bash
```

⚠️ This executes a remote script without review. Always pin to a release tag.
</details>

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
| _(coming soon)_ | |

## Agents

| Agent | Description |
|---|---|
| _(coming soon)_ | |

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT
