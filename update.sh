#!/usr/bin/env bash
# ============================================================
#  Update — Pull latest skills and configs from the repo
#  Usage: ./update.sh [--skills] [--configs] [--all]
# ============================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭  $1${NC}"; }
info() { echo -e "  ${CYAN}ℹ  $1${NC}"; }
warn() { echo -e "  ${YELLOW}⚠  $1${NC}"; }
err()  { echo -e "  ${RED}❌ $1${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
REPO_URL="https://github.com/thesaifalitai/claude-setup.git"

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   🔄 Update claude-setup                     ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

update_repo() {
  info "Pulling latest changes from GitHub..."

  if [ -d "$SCRIPT_DIR/.git" ]; then
    cd "$SCRIPT_DIR"
    local BEFORE=$(git rev-parse HEAD 2>/dev/null)
    git pull origin main 2>/dev/null || git pull 2>/dev/null || {
      warn "Could not pull — trying fetch + merge"
      git fetch origin
      git merge origin/main
    }
    local AFTER=$(git rev-parse HEAD 2>/dev/null)

    if [ "$BEFORE" = "$AFTER" ]; then
      ok "Already up to date"
    else
      local NEW_COMMITS=$(git log --oneline "$BEFORE..$AFTER" 2>/dev/null | wc -l | tr -d ' ')
      ok "Updated: $NEW_COMMITS new commit(s)"
      echo ""
      echo -e "  ${DIM}Recent changes:${NC}"
      git log --oneline "$BEFORE..$AFTER" 2>/dev/null | head -10 | while read -r line; do
        echo -e "    ${DIM}$line${NC}"
      done
    fi
  else
    warn "Not a git repo — cannot auto-update"
    info "Clone fresh: git clone $REPO_URL"
  fi
}

update_skills() {
  info "Updating skills in ~/.claude/skills/..."
  mkdir -p "$SKILLS_DIR"

  local updated=0
  local added=0

  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    local skill_name=$(basename "$skill_dir")
    [ -f "$skill_dir/SKILL.md" ] || continue

    if [ -f "$SKILLS_DIR/$skill_name/SKILL.md" ]; then
      # Compare checksums
      local repo_hash=$(md5sum "$skill_dir/SKILL.md" 2>/dev/null | awk '{print $1}' || md5 -q "$skill_dir/SKILL.md" 2>/dev/null)
      local local_hash=$(md5sum "$SKILLS_DIR/$skill_name/SKILL.md" 2>/dev/null | awk '{print $1}' || md5 -q "$SKILLS_DIR/$skill_name/SKILL.md" 2>/dev/null)

      if [ "$repo_hash" != "$local_hash" ]; then
        cp "$skill_dir/SKILL.md" "$SKILLS_DIR/$skill_name/SKILL.md"
        ok "Updated: $skill_name"
        updated=$((updated + 1))
      fi
    else
      mkdir -p "$SKILLS_DIR/$skill_name"
      cp "$skill_dir/SKILL.md" "$SKILLS_DIR/$skill_name/SKILL.md"
      ok "Added: $skill_name"
      added=$((added + 1))
    fi
  done

  local total=$(find "$SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
  echo ""
  echo -e "  ${DIM}Skills: $added new, $updated updated, $total total${NC}"
}

update_configs() {
  info "Updating global configs..."

  # Update CLAUDE.md
  if [ -f "$SCRIPT_DIR/CLAUDE.md" ]; then
    local repo_hash=$(md5sum "$SCRIPT_DIR/CLAUDE.md" 2>/dev/null | awk '{print $1}' || md5 -q "$SCRIPT_DIR/CLAUDE.md" 2>/dev/null)
    local local_hash=""
    if [ -f "$HOME/.claude/CLAUDE.md" ]; then
      local_hash=$(md5sum "$HOME/.claude/CLAUDE.md" 2>/dev/null | awk '{print $1}' || md5 -q "$HOME/.claude/CLAUDE.md" 2>/dev/null)
    fi

    if [ "$repo_hash" != "$local_hash" ]; then
      # Backup existing
      if [ -f "$HOME/.claude/CLAUDE.md" ]; then
        cp "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.backup"
        info "Backed up existing CLAUDE.md"
      fi
      cp "$SCRIPT_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
      ok "CLAUDE.md updated"
    else
      skip "CLAUDE.md already up to date"
    fi
  fi
}

show_version() {
  echo -e "  ${BOLD}Installed version:${NC}"
  if [ -f "$SCRIPT_DIR/CHANGELOG.md" ]; then
    local version=$(grep -m1 "^## \[" "$SCRIPT_DIR/CHANGELOG.md" | sed 's/## \[\(.*\)\].*/\1/')
    echo -e "    ${CYAN}v$version${NC}"
  fi

  local skill_count=$(find "$SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
  echo -e "    ${DIM}$skill_count skills installed${NC}"
  echo ""
}

show_help() {
  echo -e "${BOLD}Usage:${NC} ./update.sh [OPTIONS]"
  echo ""
  echo -e "${BOLD}Options:${NC}"
  echo "  (no args)     Update everything (repo + skills + configs)"
  echo "  --skills      Update skills only"
  echo "  --configs     Update CLAUDE.md only"
  echo "  --repo        Pull latest from GitHub only"
  echo "  --version     Show installed version"
  echo "  --help        Show this help"
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────
case "${1:-}" in
  --skills)
    update_skills
    ;;
  --configs)
    update_configs
    ;;
  --repo)
    update_repo
    ;;
  --version)
    show_version
    ;;
  --all|"")
    update_repo
    echo ""
    update_skills
    echo ""
    update_configs
    echo ""
    show_version
    ok "All updates complete!"
    ;;
  --help|-h)
    show_help
    ;;
  *)
    err "Unknown option: $1"
    show_help
    exit 1
    ;;
esac

echo ""
