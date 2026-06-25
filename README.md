# dotfiles

Personal config backup for this Mac (`pweraburudpo`).

## What's tracked

| Path in repo                          | Lives at                                              | How it's restored |
| ------------------------------------- | ----------------------------------------------------- | ----------------- |
| `config/starship.toml`                | `~/.config/starship.toml`                             | symlink           |
| `config/ghostty/config`               | `~/.config/ghostty/config`                            | symlink           |
| `claude/CLAUDE.md`                    | `~/.claude/CLAUDE.md` (global instructions)           | copy (snapshot)   |
| `claude/settings.json`                | `~/.claude/settings.json`                             | copy (snapshot)   |
| `claude/statusline-command.sh`        | `~/.claude/statusline-command.sh`                     | copy (snapshot)   |
| `claude/agents/`                      | `~/.claude/agents/` (custom subagents)                | copy (snapshot)   |
| `claude/skills/`                      | `~/.claude/skills/` (custom skills)                   | copy (snapshot)   |
| `claude/plugins/*.json`               | `~/.claude/plugins/`                                  | copy (snapshot)   |
| `Brewfile`                            | Homebrew formulae + casks                              | `brew bundle`     |

**Not** backed up (secrets / runtime state, see `.gitignore`):
`~/.claude.json`, Claude `sessions/` `projects/` `shell-snapshots/` `backups/`
`cache/` `session-env/` `history.jsonl` and `*-cache.json`.
Claude `plans/` (work artifacts) and `memory/` are intentionally left out —
add them here if you want them tracked.

## Restore on a new machine

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh        # symlinks configs + installs Homebrew packages
```

## Update the backup

After changing configs or installing brew packages:

```sh
cd ~/dotfiles
./backup.sh         # re-copies snapshots + regenerates Brewfile
git add -A && git commit -m "chore: update dotfiles" && git push
```

> `starship.toml` and `ghostty/config` are **symlinked**, so edits to the live
> files are tracked automatically — no need to re-run `backup.sh` for those.
