#!/usr/bin/env bash
# ─── Compact Reminder Hook ─────────────────────────────────────────────────
# Type: Stop hook — runs after every Claude response
# Purpose: Track conversation turns and remind to /compact at thresholds
#
# Install: Register in ~/.claude/settings.json under hooks.Stop
# ──────────────────────────────────────────────────────────────────────────

TURNS_FILE="${HOME}/.claude/.session_turns"
THRESHOLD_1=20
THRESHOLD_2=40
THRESHOLD_URGENT=60

# ── Init or increment turn counter ────────────────────────────────────────
if [[ ! -f "$TURNS_FILE" ]]; then
  echo "1" > "$TURNS_FILE"
  exit 0
fi

turns=$(cat "$TURNS_FILE" 2>/dev/null || echo "0")
turns=$((turns + 1))
echo "$turns" > "$TURNS_FILE"

# ── Emit reminder at thresholds ───────────────────────────────────────────
if (( turns == THRESHOLD_URGENT )); then
  echo ""
  echo "┌─────────────────────────────────────────────────────────┐"
  echo "│  ⚠️  Turn ${turns} — Context may be 80%+ full                    │"
  echo "│  Run /compact NOW to summarize history and free context │"
  echo "│  Or /clear if switching to a new, unrelated task        │"
  echo "└─────────────────────────────────────────────────────────┘"
elif (( turns == THRESHOLD_2 )); then
  echo ""
  echo "┌────────────────────────────────────────────────────────────┐"
  echo "│  💡 Turn ${turns} — Consider /compact to compress conversation  │"
  echo "│  Especially useful after finishing a major task phase      │"
  echo "└────────────────────────────────────────────────────────────┘"
elif (( turns == THRESHOLD_1 )); then
  echo ""
  echo "┌──────────────────────────────────────────────────────────────┐"
  echo "│  💡 Turn ${turns} — Tip: /compact after each major phase saves    │"
  echo "│  tokens and keeps context clean for better responses        │"
  echo "└──────────────────────────────────────────────────────────────┘"
fi

# ── Periodic reminder every 20 turns after 60 ─────────────────────────────
if (( turns > THRESHOLD_URGENT && (turns - THRESHOLD_URGENT) % 20 == 0 )); then
  echo ""
  echo "┌─────────────────────────────────────────────────────────────────────┐"
  echo "│  ⚠️  Turn ${turns} — Long session detected. /compact or /clear recommended │"
  echo "└─────────────────────────────────────────────────────────────────────┘"
fi
