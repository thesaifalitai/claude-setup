#!/usr/bin/env bash
# ============================================================
#  Full Stack Freelancer — Auto Setup Script (Linux)
#  Works on Ubuntu 22.04+, Debian 12+, and derivatives
#  Skips anything already installed — safe to re-run anytime
# ============================================================

set -euo pipefail

# ─── Colors ──────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭  $1 — already installed${NC}"; }
info() { echo -e "  ${CYAN}ℹ  $1${NC}"; }
warn() { echo -e "  ${YELLOW}⚠  $1${NC}"; }
err()  { echo -e "  ${RED}❌ $1${NC}"; }
h1()   { echo -e "\n${BOLD}${BLUE}━━━ $1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# ─── OS Check ────────────────────────────────────────────────
if [[ "$(uname)" != "Linux" ]]; then
  err "This script is for Linux only. Use setup.sh for macOS."
  exit 1
fi

# Detect distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO="$ID"
  DISTRO_VERSION="$VERSION_ID"
else
  err "Cannot detect Linux distribution"
  exit 1
fi

case "$DISTRO" in
  ubuntu|debian|pop|linuxmint|elementary|zorin)
    PKG_MANAGER="apt"
    ;;
  fedora|rhel|centos|rocky|alma)
    PKG_MANAGER="dnf"
    ;;
  arch|manjaro|endeavouros)
    PKG_MANAGER="pacman"
    ;;
  *)
    warn "Untested distribution: $DISTRO — attempting with apt"
    PKG_MANAGER="apt"
    ;;
esac

ARCH=$(uname -m)

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   Full Stack Freelancer — Linux Setup        ║${NC}"
echo -e "${BOLD}${CYAN}║   React Native • Flutter • Node • Next.js    ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo -e "  Distribution: ${PRETTY_NAME:-$DISTRO} ($ARCH)"
echo -e "  Package manager: $PKG_MANAGER"
echo -e "  Re-run anytime — skips what's already installed"
echo ""

# ─── Helpers ──────────────────────────────────────────────────
install_apt() {
  local pkg=$1
  local name=${2:-$1}
  if dpkg -l "$pkg" &>/dev/null 2>&1; then
    skip "$name"
  else
    info "Installing $name..."
    sudo apt-get install -y "$pkg" && ok "$name installed" || warn "$name install failed"
  fi
}

install_npm_global() {
  local pkg=$1
  local bin=${2:-$1}
  if command -v "$bin" &>/dev/null; then
    skip "$pkg ($(${bin} --version 2>/dev/null | head -1))"
  else
    info "Installing $pkg globally..."
    npm install -g "$pkg" && ok "$pkg installed" || warn "$pkg install failed"
  fi
}

# ═══════════════════════════════════════════════════════════════
h1 "1. System Update & Essential Packages"
# ═══════════════════════════════════════════════════════════════
info "Updating package lists..."
sudo apt-get update -qq

ESSENTIALS="build-essential curl wget git jq unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release"
for pkg in $ESSENTIALS; do
  install_apt "$pkg"
done

# ═══════════════════════════════════════════════════════════════
h1 "2. Git"
# ═══════════════════════════════════════════════════════════════
if command -v git &>/dev/null; then
  skip "Git ($(git --version))"
else
  install_apt "git" "Git"
fi

# ═══════════════════════════════════════════════════════════════
h1 "3. GitHub CLI"
# ═══════════════════════════════════════════════════════════════
if command -v gh &>/dev/null; then
  skip "GitHub CLI ($(gh --version | head -1))"
else
  info "Installing GitHub CLI..."
  (type -p wget >/dev/null || sudo apt-get install wget -y) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt-get update -qq \
    && sudo apt-get install gh -y \
    && ok "GitHub CLI installed" || warn "GitHub CLI install failed"
fi

# ═══════════════════════════════════════════════════════════════
h1 "4. Node.js (via NVM)"
# ═══════════════════════════════════════════════════════════════
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  skip "NVM"
  source "$HOME/.nvm/nvm.sh"
else
  info "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  ok "NVM installed"
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" 2>/dev/null || true

if command -v node &>/dev/null; then
  skip "Node.js ($(node --version))"
else
  info "Installing Node.js 20 LTS..."
  nvm install 20 && nvm use 20 && nvm alias default 20
  ok "Node.js $(node --version) installed"
fi

# ═══════════════════════════════════════════════════════════════
h1 "5. Claude Code CLI"
# ═══════════════════════════════════════════════════════════════
if command -v claude &>/dev/null; then
  skip "Claude CLI ($(claude --version 2>/dev/null | head -1))"
else
  info "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code && ok "Claude CLI installed" || warn "Claude CLI install failed"
fi
info "After setup, run: claude auth login"

# ═══════════════════════════════════════════════════════════════
h1 "6. Global npm Tools"
# ═══════════════════════════════════════════════════════════════
install_npm_global "typescript" "tsc"
install_npm_global "tsx" "tsx"
install_npm_global "@nestjs/cli" "nest"
install_npm_global "eas-cli" "eas"

# ═══════════════════════════════════════════════════════════════
h1 "7. Flutter & Dart"
# ═══════════════════════════════════════════════════════════════
if command -v flutter &>/dev/null; then
  skip "Flutter ($(flutter --version 2>/dev/null | head -1))"
else
  info "Installing Flutter via snap..."
  if command -v snap &>/dev/null; then
    sudo snap install flutter --classic && ok "Flutter installed" || warn "Flutter install failed"
  else
    warn "Snap not available — install Flutter manually from https://flutter.dev"
  fi
fi

# ═══════════════════════════════════════════════════════════════
h1 "8. Docker"
# ═══════════════════════════════════════════════════════════════
if command -v docker &>/dev/null; then
  skip "Docker ($(docker --version))"
else
  info "Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER"
  ok "Docker installed (log out and back in for group changes)"
fi

# Docker Compose plugin
if docker compose version &>/dev/null 2>&1; then
  skip "Docker Compose ($(docker compose version --short 2>/dev/null))"
else
  info "Installing Docker Compose plugin..."
  sudo apt-get install -y docker-compose-plugin 2>/dev/null && ok "Docker Compose installed" || warn "Install docker-compose-plugin manually"
fi

# ═══════════════════════════════════════════════════════════════
h1 "9. PostgreSQL & Redis"
# ═══════════════════════════════════════════════════════════════
if command -v psql &>/dev/null; then
  skip "PostgreSQL ($(psql --version))"
else
  info "Installing PostgreSQL..."
  sudo apt-get install -y postgresql postgresql-contrib
  sudo systemctl enable postgresql
  sudo systemctl start postgresql
  ok "PostgreSQL installed and started"
fi

if command -v redis-cli &>/dev/null; then
  skip "Redis ($(redis-cli --version))"
else
  info "Installing Redis..."
  sudo apt-get install -y redis-server
  sudo systemctl enable redis-server
  sudo systemctl start redis-server
  ok "Redis installed and started"
fi

# ═══════════════════════════════════════════════════════════════
h1 "10. Nginx"
# ═══════════════════════════════════════════════════════════════
if command -v nginx &>/dev/null; then
  skip "Nginx ($(nginx -v 2>&1))"
else
  install_apt "nginx" "Nginx"
fi

# ═══════════════════════════════════════════════════════════════
h1 "11. AWS CLI"
# ═══════════════════════════════════════════════════════════════
if command -v aws &>/dev/null; then
  skip "AWS CLI ($(aws --version 2>/dev/null))"
else
  info "Installing AWS CLI..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o /tmp/awscliv2.zip
  unzip -q -o /tmp/awscliv2.zip -d /tmp/
  sudo /tmp/aws/install && ok "AWS CLI installed" || warn "AWS CLI install failed"
  rm -rf /tmp/aws /tmp/awscliv2.zip
fi

# ═══════════════════════════════════════════════════════════════
h1 "12. VS Code"
# ═══════════════════════════════════════════════════════════════
if command -v code &>/dev/null; then
  skip "VS Code ($(code --version | head -1))"
else
  info "Installing VS Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  sudo apt-get update -qq
  sudo apt-get install -y code && ok "VS Code installed" || warn "VS Code install failed"
  rm -f /tmp/packages.microsoft.gpg
fi

# ═══════════════════════════════════════════════════════════════
h1 "13. Claude Skills & Config"
# ═══════════════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

if [ -d "${SCRIPT_DIR}/skills" ]; then
  for skill_dir in "${SCRIPT_DIR}/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "${SKILLS_DIR}/${skill_name}/SKILL.md" ]; then
      skip "Skill: $skill_name"
    else
      mkdir -p "${SKILLS_DIR}/${skill_name}"
      cp "${skill_dir}SKILL.md" "${SKILLS_DIR}/${skill_name}/SKILL.md"
      ok "Skill installed: $skill_name"
    fi
  done
fi

if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  skip "~/.claude/CLAUDE.md"
else
  [ -f "${SCRIPT_DIR}/CLAUDE.md" ] && cp "${SCRIPT_DIR}/CLAUDE.md" "$HOME/.claude/CLAUDE.md" && ok "CLAUDE.md installed"
fi

# ════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   ✅  Linux Setup Complete!                  ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"
echo -e "  1. Run: ${CYAN}claude auth login${NC}"
echo -e "  2. Run: ${CYAN}./doctor.sh${NC} to verify everything"
echo -e "  3. Log out and back in for Docker group permissions"
echo ""
echo -e "  ${BOLD}Re-run this script anytime — it will skip already-installed items.${NC}"
echo ""
