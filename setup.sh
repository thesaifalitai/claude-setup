#!/usr/bin/env bash
# ============================================================
#  Full Stack Freelancer — Auto Setup Script
#  Works on macOS (Apple Silicon & Intel)
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
if [[ "$(uname)" != "Darwin" ]]; then
  err "This script is for macOS only."
  exit 1
fi

ARCH=$(uname -m)  # arm64 or x86_64

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   Full Stack Freelancer — Auto Setup         ║${NC}"
echo -e "${BOLD}${CYAN}║   React Native • Flutter • Node • Next.js    ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo -e "  Architecture: ${ARCH}"
echo -e "  Re-run anytime — skips what's already installed"
echo ""

# ─── Helper: install_if_missing ──────────────────────────────
install_brew_cask() {
  local cask=$1
  local name=${2:-$1}
  if brew list --cask "$cask" &>/dev/null 2>&1; then
    skip "$name"
  else
    info "Installing $name..."
    brew install --cask "$cask" && ok "$name installed" || warn "$name install failed — continue manually"
  fi
}

install_brew_formula() {
  local formula=$1
  local name=${2:-$1}
  if brew list "$formula" &>/dev/null 2>&1; then
    skip "$name"
  else
    info "Installing $name..."
    brew install "$formula" && ok "$name installed" || warn "$name install failed — continue manually"
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
h1 "1. Xcode Command Line Tools"
# ═══════════════════════════════════════════════════════════════
if xcode-select -p &>/dev/null 2>&1; then
  skip "Xcode CLI Tools"
else
  info "Installing Xcode CLI Tools (popup may appear)..."
  xcode-select --install 2>/dev/null || true
  ok "Xcode CLI Tools install triggered"
fi

# ═══════════════════════════════════════════════════════════════
h1 "2. Homebrew"
# ═══════════════════════════════════════════════════════════════
if command -v brew &>/dev/null; then
  skip "Homebrew ($(brew --version | head -1))"
else
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add to PATH for Apple Silicon
  if [[ "$ARCH" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
fi

# ═══════════════════════════════════════════════════════════════
h1 "3. Core CLI Tools"
# ═══════════════════════════════════════════════════════════════
install_brew_formula "git" "Git"
install_brew_formula "gh" "GitHub CLI"
install_brew_formula "wget" "wget"
install_brew_formula "jq" "jq (JSON processor)"

# ═══════════════════════════════════════════════════════════════
h1 "4. Node.js (via NVM)"
# ═══════════════════════════════════════════════════════════════
if command -v nvm &>/dev/null || [ -s "$HOME/.nvm/nvm.sh" ] || [ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ]; then
  skip "NVM"
else
  install_brew_formula "nvm" "NVM"
  # Add NVM to shell config
  SHELL_RC="$HOME/.zshrc"
  NVM_INIT='
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"'
  if ! grep -q "NVM_DIR" "$SHELL_RC" 2>/dev/null; then
    echo "$NVM_INIT" >> "$SHELL_RC"
    ok "NVM added to $SHELL_RC"
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && source "$(brew --prefix)/opt/nvm/nvm.sh"
fi

# Load NVM if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" 2>/dev/null || true
[ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ] && source "$(brew --prefix nvm 2>/dev/null)/nvm.sh" 2>/dev/null || true

# Node.js
if command -v node &>/dev/null; then
  skip "Node.js ($(node --version))"
else
  if command -v nvm &>/dev/null; then
    info "Installing Node.js 20 LTS via NVM..."
    nvm install 20 && nvm use 20 && nvm alias default 20
    ok "Node.js $(node --version) installed"
  else
    install_brew_formula "node@20" "Node.js 20"
    brew link --overwrite node@20 2>/dev/null || true
  fi
fi

# npm check
if command -v npm &>/dev/null; then
  skip "npm ($(npm --version))"
fi

# ═══════════════════════════════════════════════════════════════
h1 "5. Claude Code CLI"
# ═══════════════════════════════════════════════════════════════
if command -v claude &>/dev/null; then
  skip "Claude CLI ($(claude --version 2>/dev/null | head -1))"
else
  info "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code && ok "Claude Code CLI installed" || warn "Claude Code CLI install failed — try: npm install -g @anthropic-ai/claude-code"

  # Ensure npm global bin is on PATH for this session
  NPM_GLOBAL_BIN="$(npm config get prefix 2>/dev/null)/bin"
  export PATH="$NPM_GLOBAL_BIN:$PATH"

  # Add npm global bin to ~/.zshrc for future terminal sessions
  SHELL_RC="$HOME/.zshrc"
  NPM_PATH_LINE='export PATH="$(npm config get prefix)/bin:$PATH"'
  if ! grep -q 'npm config get prefix' "$SHELL_RC" 2>/dev/null; then
    {
      echo ''
      echo '# npm global binaries (e.g. claude, typescript, nest)'
      echo "$NPM_PATH_LINE"
    } >> "$SHELL_RC"
    ok "npm global bin path added to $SHELL_RC"
  fi

  # Verify claude is now accessible
  if command -v claude &>/dev/null; then
    ok "claude command verified: $(claude --version 2>/dev/null | head -1)"
  else
    warn "claude not found in PATH yet — open a new terminal and run: claude auth login"
  fi
fi
info "👉  After setup, run: claude auth login  (one-time authentication)"

# ═══════════════════════════════════════════════════════════════
h1 "6. Global npm Tools"
# ═══════════════════════════════════════════════════════════════
install_npm_global "typescript" "tsc"
install_npm_global "tsx" "tsx"
install_npm_global "@nestjs/cli" "nest"
install_npm_global "eas-cli" "eas"

# Check/upgrade expo (it ships with expo-env but eas is separate)
if command -v expo &>/dev/null; then
  skip "Expo CLI ($(expo --version 2>/dev/null))"
else
  install_npm_global "expo-cli" "expo"
fi

# ═══════════════════════════════════════════════════════════════
h1 "7. Flutter & Dart"
# ═══════════════════════════════════════════════════════════════
if command -v flutter &>/dev/null; then
  skip "Flutter ($(flutter --version 2>/dev/null | head -1))"
else
  install_brew_cask "flutter" "Flutter SDK"
fi

if command -v dart &>/dev/null; then
  skip "Dart ($(dart --version 2>/dev/null))"
else
  info "Dart comes with Flutter — run 'flutter doctor' after setup"
fi

# ═══════════════════════════════════════════════════════════════
h1 "8. Docker Desktop"
# ═══════════════════════════════════════════════════════════════
if command -v docker &>/dev/null; then
  skip "Docker ($(docker --version))"
else
  install_brew_cask "docker" "Docker Desktop"
  info "Open Docker.app to complete setup, then run: docker --version"
fi

# ═══════════════════════════════════════════════════════════════
h1 "9. PostgreSQL & Redis"
# ═══════════════════════════════════════════════════════════════
if command -v psql &>/dev/null; then
  skip "PostgreSQL ($(psql --version))"
else
  install_brew_formula "postgresql@16" "PostgreSQL 16"
  brew services start postgresql@16 2>/dev/null || true
  # Symlink psql to PATH
  brew link --force postgresql@16 2>/dev/null || true
fi

if command -v redis-cli &>/dev/null; then
  skip "Redis ($(redis-cli --version))"
else
  install_brew_formula "redis" "Redis"
  brew services start redis 2>/dev/null || true
fi

# ═══════════════════════════════════════════════════════════════
h1 "10. Nginx"
# ═══════════════════════════════════════════════════════════════
if command -v nginx &>/dev/null; then
  skip "Nginx ($(nginx -v 2>&1))"
else
  install_brew_formula "nginx" "Nginx"
fi

# ═══════════════════════════════════════════════════════════════
h1 "11. AWS CLI"
# ═══════════════════════════════════════════════════════════════
if command -v aws &>/dev/null; then
  skip "AWS CLI ($(aws --version 2>/dev/null))"
else
  install_brew_formula "awscli" "AWS CLI"
  info "Run 'aws configure' to set up your credentials"
fi

# ═══════════════════════════════════════════════════════════════
h1 "12. VS Code"
# ═══════════════════════════════════════════════════════════════
if command -v code &>/dev/null; then
  skip "VS Code ($(code --version | head -1))"
else
  install_brew_cask "visual-studio-code" "VS Code"
fi

# ═══════════════════════════════════════════════════════════════
h1 "13. VS Code Extensions"
# ═══════════════════════════════════════════════════════════════
if command -v code &>/dev/null; then
  EXTENSIONS=(
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "eamodio.gitlens"
    "usernamehw.errorlens"
    "pkief.material-icon-theme"
    "zhuangtongfa.material-theme"
    "dsznajder.es7-react-js-snippets"
    "msjsdiag.vscode-react-native"
    "expo.vscode-expo-tools"
    "Dart-Code.flutter"
    "Dart-Code.dart-code"
    "christian-kohler.path-intellisense"
    "mikestead.dotenv"
    "rangav.vscode-thunder-client"
    "prisma.prisma"
    "ms-azuretools.vscode-docker"
    "bradlc.vscode-tailwindcss"
    "donjayamanne.githistory"
    "Orta.vscode-jest"
    "gruntfuggly.todo-tree"
    "aaron-bond.better-comments"
  )
  INSTALLED=$(code --list-extensions 2>/dev/null)
  for ext in "${EXTENSIONS[@]}"; do
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    if echo "$INSTALLED" | grep -qi "^${ext_lower}$"; then
      skip "VS Code: $ext"
    else
      info "Installing VS Code extension: $ext"
      code --install-extension "$ext" --force &>/dev/null && ok "$ext" || warn "$ext install skipped"
    fi
  done
else
  warn "VS Code not found — extensions will be installed on next run after VS Code is installed"
fi

# ═══════════════════════════════════════════════════════════════
h1 "14. VS Code Settings"
# ═══════════════════════════════════════════════════════════════
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$VSCODE_USER_DIR" ]; then
  # Settings
  if [ -f "${SCRIPT_DIR}/vscode/settings.json" ]; then
    if [ -f "${VSCODE_USER_DIR}/settings.json" ]; then
      skip "VS Code settings.json (already exists — not overwriting)"
      info "To replace: cp ${SCRIPT_DIR}/vscode/settings.json '${VSCODE_USER_DIR}/settings.json'"
    else
      cp "${SCRIPT_DIR}/vscode/settings.json" "${VSCODE_USER_DIR}/settings.json"
      ok "VS Code settings.json applied"
    fi
  fi
  # Keybindings
  if [ -f "${SCRIPT_DIR}/vscode/keybindings.json" ]; then
    if [ -f "${VSCODE_USER_DIR}/keybindings.json" ]; then
      skip "VS Code keybindings.json (already exists — not overwriting)"
    else
      cp "${SCRIPT_DIR}/vscode/keybindings.json" "${VSCODE_USER_DIR}/keybindings.json"
      ok "VS Code keybindings.json applied"
    fi
  fi
else
  info "VS Code settings directory not found — will apply on next run after VS Code is installed"
fi

# ═══════════════════════════════════════════════════════════════
h1 "15. Claude Skills & Config"
# ═══════════════════════════════════════════════════════════════
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

# Install skills from the script directory
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
else
  warn "Skills folder not found at ${SCRIPT_DIR}/skills — run from the claude-setup directory"
fi

# CLAUDE.md (global)
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  skip "~/.claude/CLAUDE.md (already exists)"
else
  if [ -f "${SCRIPT_DIR}/CLAUDE.md" ]; then
    cp "${SCRIPT_DIR}/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    ok "~/.claude/CLAUDE.md created"
  fi
fi

# ═══════════════════════════════════════════════════════════════
h1 "16. Flutter Doctor"
# ═══════════════════════════════════════════════════════════════
if command -v flutter &>/dev/null; then
  info "Running flutter doctor..."
  flutter doctor 2>/dev/null || warn "flutter doctor had issues — check output above"
else
  warn "Flutter not installed yet — skip flutter doctor"
fi

# ════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   ✅  Setup Complete!                        ║${NC}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Next steps:${NC}"

if ! command -v claude &>/dev/null; then
  echo -e "  ${YELLOW}1. Open a new terminal tab (to reload PATH), then run: claude auth login${NC}"
else
  echo -e "  ${GREEN}1. Claude is installed → run: claude  (to start)${NC}"
fi

if ! command -v flutter &>/dev/null; then
  echo -e "  ${YELLOW}2. Flutter not found in PATH → open a new terminal and run: flutter doctor${NC}"
fi

if ! command -v docker &>/dev/null || ! docker info &>/dev/null 2>&1; then
  echo -e "  ${YELLOW}3. Open Docker Desktop app to complete Docker setup${NC}"
fi

if command -v aws &>/dev/null; then
  echo -e "  ${CYAN}4. Configure AWS: aws configure${NC}"
fi

if command -v gh &>/dev/null && ! gh auth status &>/dev/null 2>&1; then
  echo -e "  ${CYAN}5. Login to GitHub CLI: gh auth login${NC}"
fi

echo ""
echo -e "  ${BOLD}Re-run this script anytime — it will skip already-installed items.${NC}"
echo ""
