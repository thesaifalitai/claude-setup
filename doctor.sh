#!/usr/bin/env bash
# ============================================================
#  Health Check — Verify your development environment
#  Like `flutter doctor` but for your entire full-stack setup
#  Usage: ./doctor.sh
# ============================================================
set -e

# ─── Colors ──────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

PASS=0
WARN=0
FAIL=0

pass()  { echo -e "  ${GREEN}[✓]${NC} $1"; PASS=$((PASS + 1)); }
warn_() { echo -e "  ${YELLOW}[!]${NC} $1"; WARN=$((WARN + 1)); }
fail_() { echo -e "  ${RED}[✗]${NC} $1"; FAIL=$((FAIL + 1)); }
hint()  { echo -e "      ${DIM}→ $1${NC}"; }
h1()    { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   🩺 Development Environment Health Check    ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""

# ─── OS & System ──────────────────────────────────────────────
h1 "System"

OS="$(uname -s)"
ARCH="$(uname -m)"
if [[ "$OS" == "Darwin" ]]; then
  MAC_VER="$(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
  pass "macOS $MAC_VER ($ARCH)"
elif [[ "$OS" == "Linux" ]]; then
  if [ -f /etc/os-release ]; then
    DISTRO="$(. /etc/os-release && echo "$PRETTY_NAME")"
    pass "Linux: $DISTRO ($ARCH)"
  else
    pass "Linux ($ARCH)"
  fi
else
  warn_ "Unsupported OS: $OS"
fi

# Disk space
if command -v df &>/dev/null; then
  AVAIL_GB=$(df -BG / 2>/dev/null | awk 'NR==2{print $4}' | tr -d 'G' || echo "0")
  if [ -z "$AVAIL_GB" ] || [ "$AVAIL_GB" = "0" ]; then
    AVAIL_GB=$(df -g / 2>/dev/null | awk 'NR==2{print $4}' || echo "?")
  fi
  if [[ "$AVAIL_GB" =~ ^[0-9]+$ ]] && [ "$AVAIL_GB" -lt 10 ]; then
    warn_ "Low disk space: ${AVAIL_GB}GB available"
    hint "Recommend at least 10GB free for Docker images and builds"
  else
    pass "Disk space: ${AVAIL_GB}GB available"
  fi
fi

# ─── Core Tools ───────────────────────────────────────────────
h1 "Core Tools"

# Homebrew (macOS) or apt (Linux)
if [[ "$OS" == "Darwin" ]]; then
  if command -v brew &>/dev/null; then
    pass "Homebrew $(brew --version 2>/dev/null | head -1 | awk '{print $2}')"
  else
    fail_ "Homebrew not installed"
    hint "Run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  fi
fi

# Git
if command -v git &>/dev/null; then
  pass "Git $(git --version | awk '{print $3}')"
  # Check git config
  if git config --global user.email &>/dev/null; then
    pass "Git user: $(git config --global user.name) <$(git config --global user.email)>"
  else
    warn_ "Git user.email not configured"
    hint "Run: git config --global user.email 'you@example.com'"
  fi
else
  fail_ "Git not installed"
fi

# GitHub CLI
if command -v gh &>/dev/null; then
  if gh auth status &>/dev/null 2>&1; then
    pass "GitHub CLI $(gh --version | head -1 | awk '{print $3}') — authenticated"
  else
    warn_ "GitHub CLI installed but not authenticated"
    hint "Run: gh auth login"
  fi
else
  fail_ "GitHub CLI (gh) not installed"
  hint "Run: brew install gh (macOS) or sudo apt install gh (Linux)"
fi

# ─── Node.js & npm ────────────────────────────────────────────
h1 "Node.js Ecosystem"

if command -v node &>/dev/null; then
  NODE_VER="$(node --version)"
  NODE_MAJOR="${NODE_VER#v}"
  NODE_MAJOR="${NODE_MAJOR%%.*}"
  if [ "$NODE_MAJOR" -ge 18 ]; then
    pass "Node.js $NODE_VER"
  else
    warn_ "Node.js $NODE_VER — recommend v18+ or v20+"
    hint "Run: nvm install 20 && nvm use 20"
  fi
else
  fail_ "Node.js not installed"
  hint "Run: nvm install 20"
fi

if command -v npm &>/dev/null; then
  pass "npm $(npm --version)"
else
  fail_ "npm not found"
fi

# NVM
if [ -s "$HOME/.nvm/nvm.sh" ] || command -v nvm &>/dev/null 2>&1; then
  pass "NVM installed"
else
  warn_ "NVM not found — managing Node versions manually"
  hint "Install NVM for easy Node.js version switching"
fi

# Global npm packages
for pkg_bin in "tsc:typescript" "tsx:tsx" "nest:@nestjs/cli" "eas:eas-cli"; do
  bin="${pkg_bin%%:*}"
  pkg="${pkg_bin#*:}"
  if command -v "$bin" &>/dev/null; then
    pass "$pkg ($($bin --version 2>/dev/null | head -1))"
  else
    warn_ "$pkg not installed globally"
    hint "Run: npm install -g $pkg"
  fi
done

# ─── Claude Code ──────────────────────────────────────────────
h1 "Claude Code"

if command -v claude &>/dev/null; then
  pass "Claude CLI $(claude --version 2>/dev/null | head -1)"
else
  fail_ "Claude CLI not installed"
  hint "Run: npm install -g @anthropic-ai/claude-code"
fi

# Skills check
SKILLS_DIR="$HOME/.claude/skills"
if [ -d "$SKILLS_DIR" ]; then
  SKILL_COUNT=$(find "$SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$SKILL_COUNT" -ge 30 ]; then
    pass "Claude skills: $SKILL_COUNT installed"
  elif [ "$SKILL_COUNT" -gt 0 ]; then
    warn_ "Claude skills: $SKILL_COUNT installed (run install_skills.sh --all for all)"
  else
    fail_ "No Claude skills installed"
    hint "Run: ./install_skills.sh --all"
  fi
else
  fail_ "Skills directory not found (~/.claude/skills/)"
  hint "Run: ./install_skills.sh --all"
fi

# CLAUDE.md
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  pass "Global CLAUDE.md configured"
else
  warn_ "~/.claude/CLAUDE.md not found"
  hint "Run: cp CLAUDE.md ~/.claude/CLAUDE.md"
fi

# ─── Mobile Development ──────────────────────────────────────
h1 "Mobile Development"

# Flutter
if command -v flutter &>/dev/null; then
  pass "Flutter $(flutter --version 2>/dev/null | head -1 | awk '{print $2}')"
else
  warn_ "Flutter not installed"
  hint "Run: brew install --cask flutter (macOS)"
fi

# Dart
if command -v dart &>/dev/null; then
  pass "Dart $(dart --version 2>/dev/null | awk '{print $4}')"
else
  warn_ "Dart not installed (comes with Flutter)"
fi

# Expo
if command -v expo &>/dev/null; then
  pass "Expo CLI $(expo --version 2>/dev/null)"
else
  warn_ "Expo CLI not installed"
  hint "Run: npm install -g expo-cli"
fi

# ─── Infrastructure ──────────────────────────────────────────
h1 "Infrastructure"

# Docker
if command -v docker &>/dev/null; then
  if docker info &>/dev/null 2>&1; then
    pass "Docker $(docker --version | awk '{print $3}' | tr -d ',') — daemon running"
  else
    warn_ "Docker installed but daemon not running"
    hint "Start Docker Desktop or run: sudo systemctl start docker"
  fi
else
  warn_ "Docker not installed"
  hint "Install: brew install --cask docker (macOS) or sudo apt install docker.io (Linux)"
fi

# PostgreSQL
if command -v psql &>/dev/null; then
  PG_VER="$(psql --version | awk '{print $3}')"
  # Check if PostgreSQL is accepting connections
  if pg_isready &>/dev/null 2>&1; then
    pass "PostgreSQL $PG_VER — accepting connections"
  else
    warn_ "PostgreSQL $PG_VER installed but not running"
    hint "Run: brew services start postgresql@16 (macOS) or sudo systemctl start postgresql (Linux)"
  fi
else
  warn_ "PostgreSQL not installed"
fi

# Redis
if command -v redis-cli &>/dev/null; then
  if redis-cli ping &>/dev/null 2>&1; then
    pass "Redis $(redis-cli --version | awk '{print $2}') — responding"
  else
    warn_ "Redis installed but not responding"
    hint "Run: brew services start redis (macOS) or sudo systemctl start redis (Linux)"
  fi
else
  warn_ "Redis not installed"
fi

# Nginx
if command -v nginx &>/dev/null; then
  pass "Nginx $(nginx -v 2>&1 | awk -F/ '{print $2}')"
else
  warn_ "Nginx not installed"
fi

# AWS CLI
if command -v aws &>/dev/null; then
  if aws sts get-caller-identity &>/dev/null 2>&1; then
    pass "AWS CLI $(aws --version 2>/dev/null | awk '{print $1}' | cut -d/ -f2) — configured"
  else
    warn_ "AWS CLI installed but not configured"
    hint "Run: aws configure"
  fi
else
  warn_ "AWS CLI not installed"
fi

# ─── Code Editor ──────────────────────────────────────────────
h1 "Editor"

if command -v code &>/dev/null; then
  EXT_COUNT=$(code --list-extensions 2>/dev/null | wc -l | tr -d ' ')
  pass "VS Code ($(code --version 2>/dev/null | head -1)) — $EXT_COUNT extensions"
else
  warn_ "VS Code not installed"
fi

# ─── AI Tool Configs ─────────────────────────────────────────
h1 "AI Tool Configs"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for config_file in "CLAUDE.md:Claude Code" ".cursorrules:Cursor" ".aider.conf.yml:Aider" ".windsurfrules:Windsurf"; do
  file="${config_file%%:*}"
  name="${config_file#*:}"
  if [ -f "$SCRIPT_DIR/$file" ]; then
    pass "$name config ($file) available"
  else
    warn_ "$name config ($file) not found in repo"
  fi
done

# ─── Summary ──────────────────────────────────────────────────
echo ""
echo -e "${BOLD}═══════════════════════════════════════════════${NC}"
TOTAL=$((PASS + WARN + FAIL))
echo -e "${BOLD}  Summary:${NC}  ${GREEN}$PASS passed${NC}  ${YELLOW}$WARN warnings${NC}  ${RED}$FAIL failed${NC}  ${DIM}($TOTAL checks)${NC}"

if [ "$FAIL" -eq 0 ] && [ "$WARN" -eq 0 ]; then
  echo -e "\n  ${GREEN}${BOLD}Your environment is fully configured!${NC}"
elif [ "$FAIL" -eq 0 ]; then
  echo -e "\n  ${YELLOW}${BOLD}Environment is working — address warnings for best experience.${NC}"
else
  echo -e "\n  ${RED}${BOLD}Fix the failed items above, then re-run: ./doctor.sh${NC}"
fi
echo ""
