#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_DIR="${HOME}/.kiro"
WITH_HOOKS=false
USE_LINK=false
FORCE=false
MARKER=".oh-my-kiro-managed"

for arg in "$@"; do
  case "$arg" in
    --with-hooks) WITH_HOOKS=true ;;
    --link)       USE_LINK=true ;;
    --force)      FORCE=true ;;
  esac
done

backup_name() {
  echo "$1.bak.$(date +%Y%m%d%H%M%S)"
}

# Install skill directories. Each skill is a subdirectory.
# Same-name dirs without our marker are treated as user-owned and skipped
# unless --force is set. --force backs up the existing directory first.
install_skills() {
  local src="$1" dst="$2"
  local installed=0 updated=0 skipped=0 backed_up=0
  [[ -d "$src" ]] || return
  mkdir -p "$dst"
  for item in "$src"/*/; do
    [[ -d "$item" ]] || continue
    local name; name="$(basename "$item")"
    local target="$dst/$name"

    if "$USE_LINK"; then
      # --link is dev-only: skip marker policy. Replace symlinks freely; refuse to clobber regular dirs.
      if [[ -d "$target" && ! -L "$target" ]]; then
        if ! $FORCE; then
          echo "  skip: $name (regular dir at $target; use --force)"
          (( skipped++ )) || true
          continue
        fi
        local bak; bak="$(backup_name "$target")"
        mv "$target" "$bak"
        echo "  backed up: $name -> $(basename "$bak")"
        (( backed_up++ )) || true
      fi
      [[ -L "$target" ]] && rm "$target"
      ln -s "$item" "$target"
      echo "  linked: $name"
      (( installed++ )) || true
      continue
    fi

    # Copy mode with marker policy
    if [[ -e "$target" ]]; then
      if [[ -d "$target" && -f "$target/$MARKER" ]]; then
        # Managed: overlay-copy so user-added files inside the dir survive.
        # Packaged files overwrite; extras (e.g. user notes) are preserved.
        cp -R "$item". "$target"/
        touch "$target/$MARKER"
        echo "  updated: $name"
        (( updated++ )) || true
        continue
      fi
      if ! $FORCE; then
        echo "  skip: $name (user-owned at $target; use --force to overwrite)"
        (( skipped++ )) || true
        continue
      fi
      local bak; bak="$(backup_name "$target")"
      mv "$target" "$bak"
      echo "  backed up: $name -> $(basename "$bak")"
      (( backed_up++ )) || true
    fi

    cp -R "$item" "$target"
    touch "$target/$MARKER"
    echo "  installed: $name"
    (( installed++ )) || true
  done
  echo "  total: $installed installed, $updated updated, $skipped skipped, $backed_up backed up"
}

# Install agent JSON files (flat). Track managed files in $dst/$MARKER manifest;
# files present at dst but absent from the manifest are user-owned.
install_agents() {
  local src="$1" dst="$2"
  local installed=0 updated=0 skipped=0 backed_up=0
  [[ -d "$src" ]] || return
  shopt -s nullglob
  local files=("$src"/*.json)
  shopt -u nullglob
  [[ ${#files[@]} -eq 0 ]] && return
  mkdir -p "$dst"
  local manifest="$dst/$MARKER"
  touch "$manifest"

  for f in "${files[@]}"; do
    local name; name="$(basename "$f")"
    local target="$dst/$name"
    local in_manifest=false
    grep -qxF "$name" "$manifest" && in_manifest=true

    if "$USE_LINK"; then
      if [[ -e "$target" && ! -L "$target" ]]; then
        if ! $FORCE; then
          echo "  skip: $name (regular file at $target; use --force)"
          (( skipped++ )) || true
          continue
        fi
        local bak; bak="$(backup_name "$target")"
        mv "$target" "$bak"
        echo "  backed up: $name -> $(basename "$bak")"
        (( backed_up++ )) || true
      fi
      [[ -L "$target" ]] && rm "$target"
      ln -s "$f" "$target"
      $in_manifest || echo "$name" >> "$manifest"
      if $in_manifest; then
        echo "  linked (updated): $name"; (( updated++ )) || true
      else
        echo "  linked: $name"; (( installed++ )) || true
      fi
      continue
    fi

    # Copy mode with manifest policy
    if [[ -e "$target" ]] && ! $in_manifest; then
      if ! $FORCE; then
        echo "  skip: $name (user-owned at $target; use --force to overwrite)"
        (( skipped++ )) || true
        continue
      fi
      local bak; bak="$(backup_name "$target")"
      mv "$target" "$bak"
      echo "  backed up: $name -> $(basename "$bak")"
      (( backed_up++ )) || true
    fi

    cp "$f" "$target"
    $in_manifest || echo "$name" >> "$manifest"
    if $in_manifest; then
      echo "  updated: $name"; (( updated++ )) || true
    else
      echo "  installed: $name"; (( installed++ )) || true
    fi
  done
  echo "  total: $installed installed, $updated updated, $skipped skipped, $backed_up backed up"
}

# Install hook scripts — opt-in only (--with-hooks).
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
  if [[ ! -t 0 ]] || [[ "${CI:-}" == "true" ]]; then
    echo "  Skipped (non-interactive environment)."
    return
  fi
  read -r -p "  Install hooks? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "  Skipped."; return; }

  mkdir -p "$dst"
  local installed=0 skipped=0
  for f in "${files[@]}"; do
    local name; name="$(basename "$f")"
    local target="$dst/$name"
    if [[ -e "$target" && ! -L "$target" ]]; then
      echo "  skip: $name (regular file exists at $target — remove manually to install)"
      (( skipped++ )) || true
      continue
    fi
    ln -sfn "$f" "$target"
    chmod +x "$target"
    echo "  installed: $name"
    (( installed++ )) || true
  done
  echo "  total: $installed installed, $skipped skipped"
}

echo "Installing oh-my-kiro-cli..."
[[ "$USE_LINK" == true ]] && echo "  mode: symlink (--link)" || echo "  mode: copy"
[[ "$FORCE"    == true ]] && echo "  force: enabled (will back up user-owned items)"
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
