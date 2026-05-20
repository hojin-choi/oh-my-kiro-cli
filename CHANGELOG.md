# Changelog

All notable changes to this project are documented here. This project follows
[Semantic Versioning](https://semver.org/spec/v2.0.0.html); during the 0.x
series, minor and patch versions may include behavior changes that are
documented as "breaking" below.

## 0.1.4 — 2026-05-20

### Added
- **Managed-file protection** in `install.sh` (addresses Codex M-1).
  Skill directories are tagged with `.oh-my-kiro-managed`; agent installs are
  tracked via a per-directory manifest. Same-name items lacking the marker are
  treated as user-owned and skipped.
- `--force` flag for `oh-my-kiro-cli setup` — overwrite user-owned items after
  creating a timestamped `.bak.<ts>` backup.
- Setup output now reports installed / updated / skipped / backed-up counts.
- `release.yml` now SHA-pins `actions/checkout` and `actions/setup-node`
  (addresses S1).
- `release.yml` gates publishes through a protected `release` environment;
  configure required reviewers under repo Settings → Environments (addresses
  S2).
- `release.yml` verifies that the pushed tag matches `package.json.version`
  and that `README.md` pins the released version, failing the publish
  otherwise.
- Optional supply-chain verification snippet in README using
  `npm view ... dist.attestations`.

### Removed
- `postinstall` lifecycle script removed from `package.json` for stricter
  enterprise-scanner compatibility (addresses Codex L-2). The `bin/cli.js`
  usage message replaces the postinstall hint.
- `curl | bash` install path removed from `README.md` (addresses Codex L-3).
  npm + explicit setup, or git clone + review, are the only documented paths.

### Changed
- `README.md` version pins updated from `0.1.2` to `0.1.4` (addresses T1 /
  Codex L-1) and now states the Node.js 22+ requirement explicitly.

### Migration from 0.1.3
- Existing `~/.kiro/skills/*` directories from earlier versions do not carry
  the new marker. Run setup once with `--force` to take ownership and create
  backups of any local edits before the marker policy applies on subsequent
  runs:

  ```bash
  oh-my-kiro-cli setup --force
  ```

## 0.1.3 — 2026-05-20

### Changed
- **Breaking (engines):** `engines.node` raised from `>=18.17.0` to `>=22.0.0`
  (Node 18 EOL April 2025, Node 20 EOL April 2026). Users on older Node will
  see install warnings; users with `engine-strict=true` will be blocked.
- Publish pipeline migrated to GitHub Actions OIDC **Trusted Publishing**.
  npm tokens are no longer used; releases carry SLSA-v1 provenance
  attestations.

## 0.1.2 — 2026-05-20

### Changed
- CI iteration release to stabilize Trusted Publishing. No source changes
  user-visible outside CI.

## 0.1.1 — 2026-05-20

### Added
- `bin/cli.js` exposes an explicit `oh-my-kiro-cli setup` command. Setup is no
  longer triggered automatically by `npm install`.
- README documents pinned-version installs and reviewability tradeoffs across
  channels.

### Removed
- Postinstall fallback `|| bash install.sh` (cwd-dependent hijack vector)
  removed.

### Changed
- `engines.node` raised to `>=18.17.0`.

## 0.1.0 — 2026-05-20

Initial public release. Skills, agents, and (opt-in) hook installer for
[Kiro CLI](https://kiro.dev/docs/cli/) — ported from
[oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode).
