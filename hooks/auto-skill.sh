#!/usr/bin/env bash
# ─── Auto Skill Hint Hook ──────────────────────────────────────────────────
# Type: PreToolUse hook — runs before tool execution
# Purpose: Detect task context and suggest the most relevant skill
#
# Install: Register in ~/.claude/settings.json under hooks.PreToolUse
# ──────────────────────────────────────────────────────────────────────────

# Hook receives tool input via stdin as JSON
INPUT=$(cat)
TOOL_NAME="${CLAUDE_TOOL_NAME:-}"

# ── Parse file path from tool input ───────────────────────────────────────
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('file_path', d.get('path', d.get('command', ''))))
except:
    print('')
" 2>/dev/null || echo "")

HINT_FILE="${HOME}/.claude/.last_skill_hint"
LAST_HINT=$(cat "$HINT_FILE" 2>/dev/null || echo "")

suggest_skill() {
  local skill="$1"
  local reason="$2"
  # Only show once per skill per session to avoid noise
  if [[ "$LAST_HINT" != "$skill" ]]; then
    echo ""
    echo "  💡 Skill tip: Use /$(echo "$skill") for $reason"
    echo "     Run: /$(echo "$skill")"
    echo "$skill" > "$HINT_FILE"
  fi
}

# ── Detect context from file path ─────────────────────────────────────────
if [[ -n "$FILE_PATH" ]]; then
  case "$FILE_PATH" in
    # Flutter / Dart
    *.dart|*pubspec.yaml|*pubspec.yml|*/flutter/*|*/lib/src/*)
      suggest_skill "flutter-expert" "Flutter/Dart tasks" ;;
    # React Native / Expo
    *.tsx|*.jsx|*/components/*|*/screens/*|*app.json|*expo*)
      if echo "$FILE_PATH" | grep -qiE "screen|native|expo|rn/|react-native"; then
        suggest_skill "react-native-expo" "React Native/Expo tasks"
      fi ;;
    # Next.js
    */app/*|*/pages/*|*next.config*)
      suggest_skill "nextjs-frontend" "Next.js tasks" ;;
    # NestJS / Node backend
    *.service.ts|*.controller.ts|*.module.ts|*.guard.ts|*.interceptor.ts)
      suggest_skill "nestjs-expert" "NestJS backend tasks" ;;
    # Docker / CI
    Dockerfile|docker-compose*|*.yml|*.yaml|*/.github/*)
      if echo "$FILE_PATH" | grep -qiE "docker|compose|workflow|github/actions|ci"; then
        suggest_skill "devops-cicd" "DevOps/CI-CD tasks"
      fi ;;
    # Database / SQL
    *.sql|*migration*|*prisma*|*schema.prisma)
      suggest_skill "database-patterns" "database/migration tasks" ;;
    # Python
    *.py|*requirements.txt|*pyproject.toml)
      suggest_skill "python-pro" "Python tasks" ;;
    # Go
    *.go|*go.mod|*go.sum)
      suggest_skill "golang-patterns" "Go tasks" ;;
    # Security-sensitive files
    *auth*|*middleware*|*guard*|*token*|*password*|*secret*|*crypto*)
      suggest_skill "security-review" "auth/security tasks" ;;
  esac
fi

exit 0
