#!/usr/bin/env bash
# Refresh snapshots in this repo from the live machine.
set -euo pipefail

DF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Claude config"
cp "$HOME/.claude/CLAUDE.md"                        "$DF/claude/CLAUDE.md"
cp "$HOME/.claude/settings.json"                    "$DF/claude/settings.json"
cp "$HOME/.claude/statusline-command.sh"            "$DF/claude/statusline-command.sh"
rm -rf "$DF/claude/agents" "$DF/claude/skills"
cp -R "$HOME/.claude/agents" "$DF/claude/agents"
cp -R "$HOME/.claude/skills" "$DF/claude/skills"
cp "$HOME/.claude/plugins/installed_plugins.json"  "$DF/claude/plugins/installed_plugins.json"
cp "$HOME/.claude/plugins/known_marketplaces.json" "$DF/claude/plugins/known_marketplaces.json"

# starship.toml and ghostty/config are symlinks (see install.sh) — tracked live,
# but copy them too in case this machine wasn't set up via install.sh.
echo "==> zshrc / starship / ghostty (only if not already a symlink into this repo)"
for pair in \
  "$HOME/.zshrc:$DF/config/zshrc" \
  "$HOME/.config/starship.toml:$DF/config/starship.toml" \
  "$HOME/.config/ghostty/config:$DF/config/ghostty/config"; do
  src="${pair%%:*}"; dst="${pair##*:}"
  if [ -e "$src" ] && [ "$(readlink "$src" 2>/dev/null)" != "$dst" ]; then
    cp "$src" "$dst"
  fi
done

echo "==> Brewfile"
brew bundle dump --file="$DF/Brewfile" --force

echo "Done. Review changes with: cd $DF && git status"
