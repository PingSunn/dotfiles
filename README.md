# dotfiles

Personal config backup for this Mac (`pweraburudpo`).

## What's tracked

| Path in repo                          | Lives at                                              | How it's restored |
| ------------------------------------- | ----------------------------------------------------- | ----------------- |
| `config/starship.toml`                | `~/.config/starship.toml`                             | symlink           |
| `config/ghostty/config`               | `~/.config/ghostty/config`                            | symlink           |
| `claude/plugins/*.json`               | `~/.claude/plugins/`                                  | copy (snapshot)   |
| `Brewfile`                            | Homebrew formulae + casks                              | `brew bundle`     |

**Not** backed up (secrets / runtime state, see `.gitignore`):
`~/.claude.json`, Claude `sessions/` `projects/` `shell-snapshots/` `backups/`.
Claude `memory/` and `plans/` are currently empty — add them here if they fill up.

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
