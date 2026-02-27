#!/usr/bin/env bash
# Run this once in Terminal on your Mac to apply VS Code settings
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭  $1${NC}"; }

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Applying VS Code settings..."

if [ ! -d "$VSCODE_DIR" ]; then
  echo "VS Code not installed yet. Install it first, then re-run this."
  exit 1
fi

if [ -f "$VSCODE_DIR/settings.json" ]; then
  skip "settings.json already exists — backing up to settings.backup.json"
  cp "$VSCODE_DIR/settings.json" "$VSCODE_DIR/settings.backup.json"
fi

cp "$SCRIPT_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"
ok "settings.json applied"

if [ -f "$VSCODE_DIR/keybindings.json" ]; then
  skip "keybindings.json already exists — backing up"
  cp "$VSCODE_DIR/keybindings.json" "$VSCODE_DIR/keybindings.backup.json"
fi

cp "$SCRIPT_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
ok "keybindings.json applied"

echo ""
echo "Installing VS Code extensions..."
EXTENSIONS=(
  "esbenp.prettier-vscode" "dbaeumer.vscode-eslint" "eamodio.gitlens"
  "usernamehw.errorlens" "pkief.material-icon-theme" "zhuangtongfa.material-theme"
  "dsznajder.es7-react-js-snippets" "msjsdiag.vscode-react-native"
  "expo.vscode-expo-tools" "Dart-Code.flutter" "Dart-Code.dart-code"
  "christian-kohler.path-intellisense" "mikestead.dotenv"
  "rangav.vscode-thunder-client" "prisma.prisma"
  "ms-azuretools.vscode-docker" "bradlc.vscode-tailwindcss"
  "donjayamanne.githistory" "Orta.vscode-jest"
  "gruntfuggly.todo-tree" "aaron-bond.better-comments"
)

INSTALLED=$(code --list-extensions 2>/dev/null || echo "")
for ext in "${EXTENSIONS[@]}"; do
  if echo "$INSTALLED" | grep -qi "^${ext}$"; then
    skip "Extension: $ext"
  else
    code --install-extension "$ext" --force &>/dev/null && ok "Extension: $ext"
  fi
done

echo ""
echo "✅ VS Code fully configured!"
