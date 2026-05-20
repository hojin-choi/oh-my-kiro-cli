#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_DIR="${HOME}/.kiro"
WITH_HOOKS=false
USE_LINK=false

for arg in "$@"; do
  case "$arg" in
    --with-hooks) WITH_HOOKS=true ;;
    --link)       USE_LINK=true ;;
  esac
done

# Install skill directories (each skill is a subdirectory)
install_skills() {
  local src="$1" dst="$2"
  local count=0
  [[ -d "$src" ]] || return
  mkdir -p "$dst"
  for item in "$src"/*/; do
    [[ -d "$item" ]] || continue
    local name; name="$(basename "$item")"
    if "$USE_LINK"; then
      [[ -L "$dst/$name" ]] && rm "$dst/$name"
      ln -s "$item" "$dst/$name"
    else
      rm -rf "$dst/$name"
      cp -R "$item" "$dst/$name"
    fi
    echo "  installed: $name"
    (( count++ )) || true
  done
  echo "  total: $count skill(s)"
}

# Install agent JSON files (flat files, not directories)
install_agents() {
  local src="$1" dst="$2"
  local count=0
  [[ -d "$src" ]] || return
  shopt -s nullglob
  local files=("$src"/*.json)
  shopt -u nullglob
  [[ ${#files[@]} -eq 0 ]] && return
  mkdir -p "$dst"
  for f in "${files[@]}"; do
    local name; name="$(basename "$f")"
    if "$USE_LINK"; then
      [[ -L "$dst/$name" ]] && rm "$dst/$name"
      ln -s "$f" "$dst/$name"
    else
      cp "$f" "$dst/$name"
    fi
    echo "  installed: $name"
    (( count++ )) || true
  done
  echo "  total: $count agent(s)"
}

# Install hook scripts — opt-in only (--with-hooks)
install_hooks() {
  local src="$REPO_DIR/hooks"
  local dst="$KIRO_DIR/hooks"
  shopt -s nullglob
  local files=("$src"/*.sh)
  shopt -u nullglob
  [[ ${#files[@]} -eq 0 ]] && { echo "  (no hooks to install)"; return; }

  echo ""
  echo "  Hooks to be installed:"
  for f in "${files[@]}"; do echo "    - $(basename "$f")"; done
  echo ""
  # Skip interactive prompt in non-interactive environments (CI, postinstall)
  if [[ ! -t 0 ]] || [[ "${CI:-}" == "true" ]] || [[ "${npm_lifecycle_event:-}" == "postinstall" ]]; then
    echo "  Skipped (non-interactive environment — use --with-hooks to install)."
    return
  fi
  read -r -p "  Install hooks? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "  Skipped."; return; }

  mkdir -p "$dst"
  local count=0
  for f in "${files[@]}"; do
    local name; name="$(basename "$f")"
    # Refuse to overwrite existing non-symlink files
    if [[ -e "$dst/$name" && ! -L "$dst/$name" ]]; then
      echo "  skip: $name (regular file exists at $dst/$name — remove manually to install)"
      continue
    fi
    ln -sfn "$f" "$dst/$name"
    chmod +x "$dst/$name"
    echo "  installed: $name"
    (( count++ )) || true
  done
  echo "  total: $count hook(s)"
}

echo "Installing oh-my-kiro-cli..."
[[ "$USE_LINK" == true ]] && echo "  mode: symlink (--link)" || echo "  mode: copy"
echo ""

echo "[skills] -> $KIRO_DIR/skills/"
install_skills "$REPO_DIR/skills" "$KIRO_DIR/skills"
echo ""

echo "[agents] -> $KIRO_DIR/agents/"
install_agents "$REPO_DIR/agents" "$KIRO_DIR/agents"
echo ""

echo "[hooks]  -> $KIRO_DIR/hooks/"
if "$WITH_HOOKS"; then
  install_hooks
else
  echo "  Skipped (use --with-hooks to install)"
fi

echo ""
echo "Done. Restart Kiro CLI to load new skills and agents."
