#!/usr/bin/env bash
# Restore dotfiles onto this machine.
set -euo pipefail

DF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() { # link <repo-relative-src> <dest>
  local src="$DF/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] || [ -e "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%s)"
    echo "  backed up existing $dest"
  fi
  ln -s "$src" "$dest"
  echo "  linked $dest -> $src"
}

copy() { # copy <repo-relative-src> <dest>
  local src="$DF/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "  copied $dest"
}

copydir() { # copydir <repo-relative-src-dir> <dest-dir>
  local src="$DF/$1" dest="$2"
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  echo "  copied $dest/"
}

echo "==> Symlinking editable configs"
link config/starship.toml      "$HOME/.config/starship.toml"
link config/ghostty/config     "$HOME/.config/ghostty/config"

echo "==> Restoring Claude config (snapshot copy)"
copy claude/CLAUDE.md                       "$HOME/.claude/CLAUDE.md"
copy claude/settings.json                   "$HOME/.claude/settings.json"
copy claude/statusline-command.sh           "$HOME/.claude/statusline-command.sh"
chmod +x "$HOME/.claude/statusline-command.sh"
copydir claude/agents                       "$HOME/.claude/agents"
copydir claude/skills                       "$HOME/.claude/skills"
copy claude/plugins/installed_plugins.json  "$HOME/.claude/plugins/installed_plugins.json"
copy claude/plugins/known_marketplaces.json "$HOME/.claude/plugins/known_marketplaces.json"

echo "==> Installing Homebrew packages"
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DF/Brewfile"
else
  echo "  brew not found — install Homebrew first: https://brew.sh"
fi

echo "Done."
