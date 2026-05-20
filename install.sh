#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_DIR="${HOME}/.kiro"

install_dir() {
  local src="$1" dst="$2"
  if [[ ! -d "$src" ]] || [[ -z "$(ls -A "$src" 2>/dev/null | grep -v '.gitkeep')" ]]; then
    return
  fi
  mkdir -p "$dst"
  for item in "$src"/*/; do
    [[ -d "$item" ]] || continue
    local name
    name="$(basename "$item")"
    if [[ -L "$dst/$name" ]]; then
      rm "$dst/$name"
    fi
    ln -s "$item" "$dst/$name"
    echo "  linked: $name"
  done
}

install_hooks() {
  local src="$REPO_DIR/hooks"
  local dst="$KIRO_DIR/hooks"
  if [[ ! -d "$src" ]] || [[ -z "$(ls -A "$src" 2>/dev/null | grep -v '.gitkeep')" ]]; then
    return
  fi
  mkdir -p "$dst"
  for f in "$src"/*.sh; do
    [[ -f "$f" ]] || continue
    local name
    name="$(basename "$f")"
    ln -sf "$f" "$dst/$name"
    chmod +x "$f"
    echo "  linked: $name"
  done
}

echo "Installing oh-my-kiro-cli..."
echo ""

echo "[skills] -> $KIRO_DIR/skills/"
install_dir "$REPO_DIR/skills" "$KIRO_DIR/skills"

echo "[agents] -> $KIRO_DIR/agents/"
install_dir "$REPO_DIR/agents" "$KIRO_DIR/agents"

echo "[hooks]  -> $KIRO_DIR/hooks/"
install_hooks

echo ""
echo "Done. Restart Kiro CLI to load new skills and agents."
