#!/usr/bin/env bash
# Claude Code statusLine — refined, glyph + truecolor layout
# Receives JSON on stdin from Claude Code.
# Requires a Nerd Font (already installed for Starship).

input=$(cat)

# ── Data extraction ─────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
dir=""
[ -n "$cwd" ] && dir=$(basename "$cwd")

branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
rl_five=$(echo "$input"       | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rl_week=$(echo "$input"       | jq -r '.rate_limits.seven_day.used_percentage // empty')
rl_week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
now=$(date +%s)

# ── Palette (24-bit truecolor, soft pastels) ────────────────────
R=$'\033[0m'                       # reset
DIM=$'\033[2m'
C_DIR=$'\033[38;2;125;211;252m'    # sky      — directory
C_GIT=$'\033[38;2;196;181;253m'    # violet   — branch
C_MOD=$'\033[38;2;148;163;184m'    # slate    — model
C_SEP=$'\033[38;2;71;85;105m'      # faint    — dividers / empty bar cells
C_OK=$'\033[38;2;134;239;172m'     # green
C_WARN=$'\033[38;2;253;224;71m'    # yellow
C_HOT=$'\033[38;2;252;165;165m'    # red

SEP="${C_SEP}·${R}"                # faint middot divider

# ── Helpers ─────────────────────────────────────────────────────
# Pick a colour from a percentage (green <50, yellow 50-79, red 80+).
_pct_color() {
  if   [ "$1" -ge 80 ]; then printf '%s' "$C_HOT"
  elif [ "$1" -ge 50 ]; then printf '%s' "$C_WARN"
  else                       printf '%s' "$C_OK"
  fi
}

# Format seconds-until-reset as a compact countdown: 2d3h · 4h12m · 47m · due.
_fmt_eta() {
  local s="$1"
  [ "$s" -le 0 ] && { printf 'due'; return; }
  local d=$(( s / 86400 )) h=$(( (s % 86400) / 3600 )) m=$(( (s % 3600) / 60 ))
  if   [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"
  else                      printf '%dm' "$m"
  fi
}

# Render: <icon> [label ]NN%  [↻ <countdown to reset>]  — coloured by threshold.
# Args: icon  pct  [reset_epoch]  [label]
_meter() {
  local icon="$1" pct; pct=$(printf '%.0f' "$2")
  local reset="$3" label="$4"
  local color; color=$(_pct_color "$pct")
  [ -n "$label" ] && label="$label "
  printf '%s%s %s%d%%%s' "$color" "$icon" "$label" "$pct" "$R"
  if [ -n "$reset" ]; then
    printf '%s ↻ %s%s' "$DIM$C_MOD" "$(_fmt_eta $(( reset - now )))" "$R"
  fi
}

# ── Assemble ────────────────────────────────────────────────────
out=""
add() { [ -n "$out" ] && out+="  ${SEP}  "; out+="$1"; }

[ -n "$dir" ]    && add "$(printf '%s %s%s'   "$C_DIR " "$dir" "$R")"
[ -n "$branch" ] && add "$(printf '%s %s%s'   "$C_GIT " "$branch" "$R")"
[ -n "$model" ]  && add "$(printf '%s %s%s%s' "$DIM$C_MOD" "󰚩 " "$model" "$R")"
[ -n "$used" ]    && add "$(_meter "" "$used" "" "ctx")"
[ -n "$rl_five" ] && add "$(_meter "" "$rl_five" "$rl_five_reset")"
[ -n "$rl_week" ] && add "$(_meter "" "$rl_week" "$rl_week_reset")"

printf '%s' "$out"
