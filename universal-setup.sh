#!/usr/bin/env bash
# ============================================================
#  Universal AI Tool Config — Works with multiple AI assistants
#  Supports: Claude Code, Cursor, Aider, Windsurf (Codeium)
#  Copies the right config file to your project directory
# ============================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭  $1${NC}"; }
info() { echo -e "  ${CYAN}ℹ  $1${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   🔀 Universal AI Tool Setup                  ║${NC}"
echo -e "${BOLD}${CYAN}║   One config for all your AI coding tools     ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  Target directory: ${BOLD}$TARGET_DIR${NC}"
echo ""
echo -e "  ${BOLD}Select which AI tools to configure:${NC}"
echo ""
echo -e "    ${CYAN}1${NC}) 🟣 Claude Code only (CLAUDE.md)"
echo -e "    ${CYAN}2${NC}) 🟢 Cursor only (.cursorrules)"
echo -e "    ${CYAN}3${NC}) 🔵 Aider only (.aider.conf.yml)"
echo -e "    ${CYAN}4${NC}) 🟡 Windsurf only (.windsurfrules)"
echo -e "    ${CYAN}5${NC}) 🌐 ALL tools (recommended)"
echo -e "    ${CYAN}0${NC}) ❌ Exit"
echo ""

read -rp "  Enter your choice [0-5]: " choice
echo ""

install_claude() {
  if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
    skip "CLAUDE.md already exists in $TARGET_DIR"
  else
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    ok "CLAUDE.md → $TARGET_DIR/CLAUDE.md"
  fi
}

install_cursor() {
  if [ -f "$TARGET_DIR/.cursorrules" ]; then
    skip ".cursorrules already exists in $TARGET_DIR"
  else
    cp "$SCRIPT_DIR/.cursorrules" "$TARGET_DIR/.cursorrules"
    ok ".cursorrules → $TARGET_DIR/.cursorrules"
  fi
}

install_aider() {
  if [ -f "$TARGET_DIR/.aider.conf.yml" ]; then
    skip ".aider.conf.yml already exists in $TARGET_DIR"
  else
    cp "$SCRIPT_DIR/.aider.conf.yml" "$TARGET_DIR/.aider.conf.yml"
    ok ".aider.conf.yml → $TARGET_DIR/.aider.conf.yml"
  fi
}

install_windsurf() {
  if [ -f "$TARGET_DIR/.windsurfrules" ]; then
    skip ".windsurfrules already exists in $TARGET_DIR"
  else
    cp "$SCRIPT_DIR/.windsurfrules" "$TARGET_DIR/.windsurfrules"
    ok ".windsurfrules → $TARGET_DIR/.windsurfrules"
  fi
}

case $choice in
  1) install_claude ;;
  2) install_cursor ;;
  3) install_aider ;;
  4) install_windsurf ;;
  5)
    install_claude
    install_cursor
    install_aider
    install_windsurf
    ;;
  0)
    echo "  Bye!"
    exit 0
    ;;
  *)
    echo -e "  ${YELLOW}Invalid choice${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${BOLD}Supported AI Tools:${NC}"
echo ""
echo -e "  ${BOLD}🟣 Claude Code${NC} ${DIM}(our priority — best for coding)${NC}"
echo -e "     Reads: CLAUDE.md + ~/.claude/skills/"
echo -e "     Install: npm i -g @anthropic-ai/claude-code"
echo ""
echo -e "  ${BOLD}🟢 Cursor${NC}"
echo -e "     Reads: .cursorrules"
echo -e "     Install: https://cursor.sh"
echo ""
echo -e "  ${BOLD}🔵 Aider${NC}"
echo -e "     Reads: .aider.conf.yml"
echo -e "     Install: pip install aider-chat"
echo ""
echo -e "  ${BOLD}🟡 Windsurf${NC}"
echo -e "     Reads: .windsurfrules"
echo -e "     Install: https://codeium.com/windsurf"
echo ""
echo -e "  ${DIM}All configs share the same coding standards from CLAUDE.md${NC}"
echo ""
