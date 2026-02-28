#!/usr/bin/env bash
# ============================================================
#  Interactive Skill Installer — Select exactly what you need
#  Supports: --all (install everything), --list (show skills),
#            --category <name> (install by category)
# ============================================================
set -e

# ─── Colors ──────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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
mkdir -p "$SKILLS_DIR" "$HOME/.claude"

# ─── Skill Categories ────────────────────────────────────────
# Maps skill names to categories for organized selection
declare -A SKILL_CATEGORIES
SKILL_CATEGORIES=(
  # Mobile
  ["react-native-expo"]="mobile"
  ["react-native-expert"]="mobile"
  ["flutter-dev"]="mobile"
  ["flutter-expert"]="mobile"
  # Backend
  ["nodejs-backend"]="backend"
  ["nestjs-expert"]="backend"
  ["django-expert"]="backend"
  ["fastapi-expert"]="backend"
  ["laravel-specialist"]="backend"
  ["graphql-architect"]="backend"
  # Frontend
  ["nextjs-frontend"]="frontend"
  ["nextjs-developer"]="frontend"
  ["vue-expert"]="frontend"
  ["typescript-pro"]="frontend"
  # UI/UX
  ["uiux-design"]="uiux"
  # DevOps
  ["devops-cicd"]="devops"
  ["devops-engineer"]="devops"
  ["kubernetes-specialist"]="devops"
  ["cloud-architect"]="devops"
  # Architecture
  ["fullstack-architecture"]="architecture"
  ["api-designer"]="architecture"
  ["microservices-architect"]="architecture"
  # Code Quality
  ["code-reviewer"]="quality"
  ["test-master"]="quality"
  ["debugging-wizard"]="quality"
  ["secure-code-guardian"]="quality"
  ["feature-forge"]="quality"
  # Languages
  ["python-pro"]="languages"
  # Freelance
  ["upwork-freelancer"]="freelance"
  # Token Tracking
  ["token-tracker"]="utilities"
)

CATEGORY_LABELS=(
  "mobile:📱 Mobile Development"
  "backend:⚙️  Backend Development"
  "frontend:🌐 Frontend Development"
  "uiux:🎨 UI / UX Design"
  "devops:🔧 DevOps & Infrastructure"
  "architecture:🏗️  Architecture"
  "quality:🔍 Code Quality"
  "languages:📝 Languages"
  "freelance:💼 Freelancing"
  "utilities:🛠️  Utilities"
)

# ─── Functions ────────────────────────────────────────────────

get_category_label() {
  local cat_id="$1"
  for entry in "${CATEGORY_LABELS[@]}"; do
    local id="${entry%%:*}"
    local label="${entry#*:}"
    if [[ "$id" == "$cat_id" ]]; then
      echo "$label"
      return
    fi
  done
  echo "$cat_id"
}

get_skill_description() {
  local skill_dir="$1"
  if [ -f "$skill_dir/SKILL.md" ]; then
    # Extract description from YAML frontmatter
    sed -n '/^---$/,/^---$/p' "$skill_dir/SKILL.md" | grep -E "^description:" | sed 's/^description:\s*//' | head -c 80
  fi
}

list_skills() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║   Available Skills                            ║${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
  echo ""

  local current_cat=""
  local idx=1

  for entry in "${CATEGORY_LABELS[@]}"; do
    local cat_id="${entry%%:*}"
    local cat_label="${entry#*:}"

    local has_skills=false
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
      local skill_name=$(basename "$skill_dir")
      [ -f "$skill_dir/SKILL.md" ] || continue
      local skill_cat="${SKILL_CATEGORIES[$skill_name]:-uncategorized}"
      if [[ "$skill_cat" == "$cat_id" ]]; then
        has_skills=true
        break
      fi
    done

    if $has_skills; then
      echo -e "\n  ${BOLD}${cat_label}${NC}"
      for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        local skill_name=$(basename "$skill_dir")
        [ -f "$skill_dir/SKILL.md" ] || continue
        local skill_cat="${SKILL_CATEGORIES[$skill_name]:-uncategorized}"
        if [[ "$skill_cat" == "$cat_id" ]]; then
          local installed=""
          if [ -f "$SKILLS_DIR/$skill_name/SKILL.md" ]; then
            installed="${GREEN}[installed]${NC}"
          fi
          printf "    ${CYAN}%2d${NC}) %-30s %s\n" "$idx" "$skill_name" "$installed"
          idx=$((idx + 1))
        fi
      done
    fi
  done

  echo ""
  echo -e "  ${DIM}Total: $((idx - 1)) skills available${NC}"
  echo ""
}

install_skill() {
  local skill_name="$1"
  local skill_dir="$SCRIPT_DIR/skills/$skill_name"

  if [ ! -f "$skill_dir/SKILL.md" ]; then
    err "Skill not found: $skill_name"
    return 1
  fi

  if [ -f "$SKILLS_DIR/$skill_name/SKILL.md" ]; then
    skip "Skill: $skill_name (already installed)"
    return 0
  fi

  mkdir -p "$SKILLS_DIR/$skill_name"
  cp "$skill_dir/SKILL.md" "$SKILLS_DIR/$skill_name/SKILL.md"
  ok "Skill installed: $skill_name"
}

install_category() {
  local target_cat="$1"
  local count=0

  echo -e "\n  ${BOLD}Installing $(get_category_label "$target_cat") skills...${NC}"

  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    local skill_name=$(basename "$skill_dir")
    [ -f "$skill_dir/SKILL.md" ] || continue
    local skill_cat="${SKILL_CATEGORIES[$skill_name]:-uncategorized}"
    if [[ "$skill_cat" == "$target_cat" ]]; then
      install_skill "$skill_name"
      count=$((count + 1))
    fi
  done

  echo -e "  ${DIM}→ $count skills processed${NC}"
}

install_all() {
  echo -e "\n  ${BOLD}Installing ALL skills...${NC}\n"
  local installed=0
  local skipped=0

  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    local skill_name=$(basename "$skill_dir")
    [ -f "$skill_dir/SKILL.md" ] || continue
    if [ -f "$SKILLS_DIR/$skill_name/SKILL.md" ]; then
      skip "Skill: $skill_name"
      skipped=$((skipped + 1))
    else
      install_skill "$skill_name"
      installed=$((installed + 1))
    fi
  done

  echo ""
  echo -e "  ✅ Done! ${GREEN}$installed installed${NC}, ${YELLOW}$skipped already existed${NC}"
}

interactive_menu() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║   🧠 Claude Skill Installer                  ║${NC}"
  echo -e "${BOLD}${CYAN}║   Select what you need                       ║${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${BOLD}Choose an installation option:${NC}"
  echo ""
  echo -e "    ${CYAN}1${NC}) 📦 Install ALL skills (recommended for new setups)"
  echo -e "    ${CYAN}2${NC}) 📱 Mobile only (React Native + Flutter)"
  echo -e "    ${CYAN}3${NC}) ⚙️  Backend only (Node.js, NestJS, Django, FastAPI, Laravel)"
  echo -e "    ${CYAN}4${NC}) 🌐 Frontend only (Next.js, Vue, TypeScript)"
  echo -e "    ${CYAN}5${NC}) 🔧 DevOps only (Docker, K8s, AWS, CI/CD)"
  echo -e "    ${CYAN}6${NC}) 🏗️  Architecture only (System design, APIs, Microservices)"
  echo -e "    ${CYAN}7${NC}) 🔍 Code Quality only (Testing, Reviews, Security, Debugging)"
  echo -e "    ${CYAN}8${NC}) 💼 Freelance only (Upwork proposals + client comms)"
  echo -e "    ${CYAN}9${NC}) 🛠️  Utilities (Token tracker + cost monitor)"
  echo -e "    ${CYAN}10${NC}) 🎯 Custom — pick individual skills"
  echo -e "    ${CYAN}0${NC}) ❌ Exit"
  echo ""

  read -rp "  Enter your choice [0-10]: " choice
  echo ""

  case $choice in
    1) install_all ;;
    2) install_category "mobile" ;;
    3) install_category "backend" ;;
    4) install_category "frontend" ;;
    5) install_category "devops" ;;
    6) install_category "architecture" ;;
    7) install_category "quality" ;;
    8) install_category "freelance" ;;
    9) install_category "utilities" ;;
    10) interactive_pick_skills ;;
    0) echo "  Bye!" ; exit 0 ;;
    *) err "Invalid choice. Run again." ; exit 1 ;;
  esac
}

interactive_pick_skills() {
  echo -e "  ${BOLD}Available skills (enter numbers separated by spaces):${NC}\n"

  local skill_names=()
  local idx=1

  for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    local skill_name=$(basename "$skill_dir")
    [ -f "$skill_dir/SKILL.md" ] || continue
    skill_names+=("$skill_name")
    local installed=""
    if [ -f "$SKILLS_DIR/$skill_name/SKILL.md" ]; then
      installed=" ${GREEN}[installed]${NC}"
    fi
    local cat="${SKILL_CATEGORIES[$skill_name]:-other}"
    printf "    ${CYAN}%2d${NC}) %-30s ${DIM}(%s)${NC}%b\n" "$idx" "$skill_name" "$cat" "$installed"
    idx=$((idx + 1))
  done

  echo ""
  read -rp "  Enter skill numbers (e.g., 1 3 5 7): " -a selections
  echo ""

  if [ ${#selections[@]} -eq 0 ]; then
    warn "No skills selected"
    return
  fi

  local count=0
  for num in "${selections[@]}"; do
    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#skill_names[@]}" ]; then
      install_skill "${skill_names[$((num - 1))]}"
      count=$((count + 1))
    else
      warn "Skipping invalid number: $num"
    fi
  done

  echo ""
  echo -e "  ✅ $count skills installed"
}

install_claude_md() {
  if [ -f "$HOME/.claude/CLAUDE.md" ]; then
    skip "~/.claude/CLAUDE.md already exists"
  else
    cp "$SCRIPT_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    ok "~/.claude/CLAUDE.md installed"
  fi
}

# ─── CLI Argument Handling ────────────────────────────────────

show_help() {
  echo ""
  echo -e "${BOLD}Usage:${NC} ./install_skills.sh [OPTIONS]"
  echo ""
  echo -e "${BOLD}Options:${NC}"
  echo "  (no args)          Interactive skill selection menu"
  echo "  --all              Install all skills (no prompts)"
  echo "  --list             Show available skills and status"
  echo "  --category <name>  Install skills by category"
  echo "                     Categories: mobile, backend, frontend, uiux,"
  echo "                     devops, architecture, quality, languages,"
  echo "                     freelance, utilities"
  echo "  --skill <name>     Install a single skill by name"
  echo "  --help             Show this help message"
  echo ""
  echo -e "${BOLD}Examples:${NC}"
  echo "  ./install_skills.sh                     # Interactive menu"
  echo "  ./install_skills.sh --all               # Install everything"
  echo "  ./install_skills.sh --category mobile    # Mobile skills only"
  echo "  ./install_skills.sh --skill token-tracker # Single skill"
  echo "  ./install_skills.sh --list               # See what's available"
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────

install_claude_md

case "${1:-}" in
  --all)
    install_all
    ;;
  --list)
    list_skills
    ;;
  --category)
    if [ -z "${2:-}" ]; then
      err "Please specify a category. Use --help to see options."
      exit 1
    fi
    install_category "$2"
    ;;
  --skill)
    if [ -z "${2:-}" ]; then
      err "Please specify a skill name."
      exit 1
    fi
    install_skill "$2"
    ;;
  --help|-h)
    show_help
    ;;
  "")
    interactive_menu
    ;;
  *)
    err "Unknown option: $1"
    show_help
    exit 1
    ;;
esac

echo ""
echo -e "  ${BOLD}Total skills in ~/.claude/skills/:${NC} $(ls "$SKILLS_DIR" 2>/dev/null | wc -l | tr -d ' ')"
echo ""
