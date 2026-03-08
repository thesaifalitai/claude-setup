#!/usr/bin/env bash
# ============================================================
#  Claude Code — Hooks & Efficiency Settings Installer
#  Safely merges hooks into ~/.claude/settings.json
#  and copies hook scripts to ~/.claude/hooks/
#  Safe to re-run — skips what's already installed
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭  $1 — already set${NC}"; }
info() { echo -e "  ${CYAN}ℹ  $1${NC}"; }
err()  { echo -e "  ${RED}❌ $1${NC}"; }
h1()   { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_SRC="${SCRIPT_DIR}/hooks"
SETTINGS_SRC="${SCRIPT_DIR}/settings/efficiency.json"
CLAUDE_DIR="${HOME}/.claude"
HOOKS_DEST="${CLAUDE_DIR}/hooks"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   Claude Code — Efficiency Hooks Installer   ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# ── Check dependencies ────────────────────────────────────────────────────
if ! command -v jq &>/dev/null; then
  err "jq is required. Install it: brew install jq"
  exit 1
fi

# ── Create directories ────────────────────────────────────────────────────
h1 "Directories"
mkdir -p "$HOOKS_DEST"
ok "~/.claude/hooks/ ready"
mkdir -p "${CLAUDE_DIR}"
ok "~/.claude/ ready"

# ── Copy hook scripts ─────────────────────────────────────────────────────
h1 "Hook Scripts"
for script in "${HOOKS_SRC}"/*.sh; do
  name=$(basename "$script")
  dest="${HOOKS_DEST}/${name}"
  if [[ -f "$dest" ]]; then
    # Check if newer
    if cmp -s "$script" "$dest"; then
      skip "$name"
    else
      cp "$script" "$dest"
      chmod +x "$dest"
      ok "$name (updated)"
    fi
  else
    cp "$script" "$dest"
    chmod +x "$dest"
    ok "$name"
  fi
done

# ── Merge env settings ────────────────────────────────────────────────────
h1 "Efficiency Env Settings"

# Create settings.json if it doesn't exist
if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo '{}' > "$SETTINGS_FILE"
  info "Created ~/.claude/settings.json"
fi

add_env_var() {
  local key="$1"
  local value="$2"
  local current
  current=$(jq -r ".env.\"${key}\" // empty" "$SETTINGS_FILE" 2>/dev/null || echo "")
  if [[ -n "$current" ]]; then
    skip "${key}=${current}"
  else
    tmp=$(mktemp)
    jq ".env.\"${key}\" = \"${value}\"" "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
    ok "${key}=${value}"
  fi
}

# Initialize env object if missing
if ! jq -e '.env' "$SETTINGS_FILE" &>/dev/null; then
  tmp=$(mktemp)
  jq '.env = {}' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
fi

add_env_var "MAX_THINKING_TOKENS" "10000"
add_env_var "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE" "50"
add_env_var "CLAUDE_CODE_SUBAGENT_MODEL" "claude-haiku-4-5-20251001"

# ── Merge hook registrations ──────────────────────────────────────────────
h1 "Hook Registrations"

# Initialize hooks object if missing
if ! jq -e '.hooks' "$SETTINGS_FILE" &>/dev/null; then
  tmp=$(mktemp)
  jq '.hooks = {}' "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
fi

# ── Stop hook: compact-reminder ───────────────────────────────────────────
STOP_CMD="bash ~/.claude/hooks/compact-reminder.sh"
has_stop=$(jq -r "
  (.hooks.Stop // [])
  | map(select(.hooks != null))
  | map(.hooks[])
  | map(select(.command == \"${STOP_CMD}\"))
  | length
" "$SETTINGS_FILE" 2>/dev/null || echo "0")

if [[ "$has_stop" -gt 0 ]]; then
  skip "Stop hook: compact-reminder"
else
  tmp=$(mktemp)
  jq ".hooks.Stop = ((.hooks.Stop // []) + [{
    \"matcher\": \"\",
    \"hooks\": [{
      \"type\": \"command\",
      \"command\": \"${STOP_CMD}\"
    }]
  }])" "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
  ok "Stop hook: compact-reminder registered"
fi

# ── PreToolUse hook: auto-skill ───────────────────────────────────────────
PRETOOL_CMD="bash ~/.claude/hooks/auto-skill.sh"
has_pretool=$(jq -r "
  (.hooks.PreToolUse // [])
  | map(select(.hooks != null))
  | map(.hooks[])
  | map(select(.command == \"${PRETOOL_CMD}\"))
  | length
" "$SETTINGS_FILE" 2>/dev/null || echo "0")

if [[ "$has_pretool" -gt 0 ]]; then
  skip "PreToolUse hook: auto-skill"
else
  tmp=$(mktemp)
  jq ".hooks.PreToolUse = ((.hooks.PreToolUse // []) + [{
    \"matcher\": \"Read|Edit|Write|Glob|Grep\",
    \"hooks\": [{
      \"type\": \"command\",
      \"command\": \"${PRETOOL_CMD}\"
    }]
  }])" "$SETTINGS_FILE" > "$tmp" && mv "$tmp" "$SETTINGS_FILE"
  ok "PreToolUse hook: auto-skill registered"
fi

# ── Initialize session state ──────────────────────────────────────────────
h1 "Session State"
echo "0" > "${CLAUDE_DIR}/.session_turns"
ok "Turn counter initialized"
touch "${CLAUDE_DIR}/.last_skill_hint"
ok "Skill hint tracker initialized"

# ── Done ──────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   ✅  Hooks installed successfully!           ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo "  Active optimizations:"
echo "  • Auto-compact reminder at turns 20 / 40 / 60+"
echo "  • Auto skill suggestions when opening Flutter/RN/Next.js/Go/etc."
echo "  • Context auto-compacts at 50% window usage"
echo "  • Subagents use Haiku (3× cheaper) by default"
echo "  • Thinking capped at 10K tokens (fast + focused)"
echo ""
echo "  To uninstall hooks:"
echo "  Remove the hooks entries from ~/.claude/settings.json"
echo ""
