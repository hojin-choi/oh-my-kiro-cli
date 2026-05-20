# Contributing to oh-my-kiro-cli

Thanks for considering a contribution. This project is a small, declarative
workflow harness (Skills, Agents, Hooks) for [Kiro CLI](https://kiro.dev/docs/cli/) —
mostly markdown, JSON, and a single bash installer. Changes should stay in
that spirit: small, reviewable, and easy to reason about.

## Reporting issues

- **Bugs / feature requests** — open a GitHub issue with a minimal repro and
  the version you saw it on (`oh-my-kiro-cli --version` if applicable,
  otherwise the npm dist-tag).
- **Security vulnerabilities** — please do **not** open a public issue.
  Report privately via [GitHub Security Advisories](https://github.com/hojin-choi/oh-my-kiro-cli/security/advisories/new)
  so we can ship a coordinated fix.

## Development setup

```bash
git clone https://github.com/hojin-choi/oh-my-kiro-cli ~/.oh-my-kiro-cli
cd ~/.oh-my-kiro-cli
./install.sh --link   # contributor-only: symlinks so edits go live immediately
```

`--link` is rejected when running from an npm install — it is intentionally
gated to git-clone setups so you can iterate without rebuilding the tarball.

## What goes where

| Path | What lives here |
|---|---|
| `skills/<name>/SKILL.md` | A single skill definition. Front-matter + body. |
| `agents/<name>.json` | An agent definition (declarative JSON). |
| `hooks/*.sh` | Opt-in hook scripts (`--with-hooks`). Document the trigger in a header comment. |
| `bin/cli.js` | The user-facing CLI. Keep it tiny: dispatch only. |
| `install.sh` | The installer. Marker policy lives here — see below. |

## Conventions

- **Match existing style.** Skim a few sibling files before adding something
  new. No new linter or framework just to land a change.
- **Smallest viable diff.** Don't refactor adjacent code unless the PR is
  explicitly about that.
- **No new runtime deps.** This package has zero npm dependencies and we'd
  like to keep it that way unless there is a compelling reason.
- **Comments are for non-obvious WHY.** What the code does should read from
  the code; comments explain why a constraint exists when it isn't obvious.

## Pull request flow

1. Fork (external) or create a branch off `main` (maintainers).
2. One logical change per PR. Small PRs land faster than large ones.
3. Run the local checks below before pushing.
4. Open the PR against `main`. Reference any issue it closes
   (e.g. `Closes #12`).
5. Expect review feedback — the maintainer may push small edits directly.

## Local checks

These are the smoke checks the release workflow also exercises in spirit:

```bash
bash -n install.sh                          # shell syntax
node --check bin/cli.js                     # JS syntax
python3 -m json.tool agents/*.json          # JSON validity
TMPHOME=$(mktemp -d); HOME="$TMPHOME" ./install.sh   # end-to-end install
# verify ~/.kiro/skills, ~/.kiro/agents populated, then:
rm -rf "$TMPHOME"
```

For changes to `install.sh`, also re-run the smoke test with a user-added
file inside `~/.kiro/skills/<some-skill>/` to confirm the managed-marker
policy still preserves user files.

## Adding a new skill

1. Create `skills/<name>/SKILL.md`.
2. Top of the file: YAML front-matter with `name`, `description`,
   `argument-hint`.
3. Body describes when to use, when not to use, and the protocol.
4. Add a one-line row to the **Skills** table in `README.md`.

## Adding a new agent

1. Create `agents/<name>.json`.
2. Keys: `name`, `description`, `prompt`, `tools`, `allowedTools`.
3. Read-only roles must omit `shell` and `write` from `allowedTools`.
4. Roles with `shell` access **must** include a `## Security Guardrails`
   section in their `prompt` (see `agents/executor.json` for the canonical
   shape).
5. Add a one-line row to the **Agents** table in `README.md`.

## Release process (maintainers only)

Releases are driven by tag pushes and gated by a protected `release`
environment.

1. Land all PRs targeting the next version onto `main`.
2. Bump `package.json` `version` and update `README.md` pins
   (`@<version>`, `git checkout v<version>`). The release workflow will
   fail-fast if these drift.
3. Update `CHANGELOG.md` with the new section.
4. Commit and tag:

   ```bash
   git commit -am "release: vX.Y.Z — <summary>"
   git tag -a vX.Y.Z -m "vX.Y.Z — <summary>"
   git push origin main
   git push origin vX.Y.Z
   ```

5. Approve the run under
   [Actions → release](https://github.com/hojin-choi/oh-my-kiro-cli/actions/workflows/release.yml)
   when the `release` environment requests review.
6. The workflow publishes to npm via OIDC Trusted Publishing — no npm
   token is involved. SLSA-v1 provenance is attached automatically.

Verifying a release afterwards:

```bash
npm view oh-my-kiro-cli@<version> dist.attestations
npm view oh-my-kiro-cli@<version> _npmUser
# expect publisher = "GitHub Actions" (Trusted Publisher), not a personal user
```

## License

By contributing, you agree that your contribution is licensed under the
MIT License (see `LICENSE`).
