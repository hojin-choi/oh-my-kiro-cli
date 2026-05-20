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

**Recommended** — review before running:

```bash
git clone https://github.com/hojin-choi/oh-my-kiro-cli ~/.oh-my-kiro-cli
cd ~/.oh-my-kiro-cli
less install.sh   # review first
./install.sh
```

Options:
- `--link` — symlink instead of copy (for development/contributors)
- `--with-hooks` — also install hook scripts (opt-in)

<details>
<summary>Quick install (convenience only)</summary>

```bash
curl -fsSL https://raw.githubusercontent.com/hojin-choi/oh-my-kiro-cli/main/install.sh | bash
```

⚠️ This executes a remote script without review. Pin to a release tag if you use this method.
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
