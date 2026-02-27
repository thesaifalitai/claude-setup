#!/usr/bin/env bash
# Run this once in Terminal on your Mac to install Claude skills
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭  $1${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

mkdir -p "$SKILLS_DIR"
mkdir -p "$HOME/.claude"

# Copy CLAUDE.md
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  skip "~/.claude/CLAUDE.md already exists"
else
  cp "$SCRIPT_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  ok "~/.claude/CLAUDE.md installed"
fi

# Install each skill
INSTALLED=0; SKIPPED=0
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  [ -f "$skill_dir/SKILL.md" ] || continue
  if [ -f "$SKILLS_DIR/$skill_name/SKILL.md" ]; then
    skip "Skill: $skill_name"
    SKIPPED=$((SKIPPED+1))
  else
    mkdir -p "$SKILLS_DIR/$skill_name"
    cp "$skill_dir/SKILL.md" "$SKILLS_DIR/$skill_name/SKILL.md"
    ok "Skill: $skill_name"
    INSTALLED=$((INSTALLED+1))
  fi
done

echo ""
echo "✅ Done! $INSTALLED installed, $SKIPPED already existed"
echo "Total skills in ~/.claude/skills/: $(ls "$SKILLS_DIR" | wc -l | tr -d ' ')"
echo ""
echo "Open Terminal and run: claude"
echo "Then try: 'Write an Upwork proposal for a React Native job'"
