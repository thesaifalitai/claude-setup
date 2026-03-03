#!/usr/bin/env bash
# ============================================================
#  .env.example Generator — Create env templates for your stack
#  Usage: ./generate-env.sh [template] [output-dir]
#  Templates: nextjs, nestjs, expo, flutter, fullstack, supabase
# ============================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✅ $1${NC}"; }
info() { echo -e "  ${CYAN}ℹ  $1${NC}"; }
warn() { echo -e "  ${YELLOW}⚠  $1${NC}"; }
err()  { echo -e "  ${RED}❌ $1${NC}"; }

OUTPUT_DIR="${2:-.}"

gen_nextjs() {
  cat > "$OUTPUT_DIR/.env.example" << 'EOF'
# ═══════════════════════════════════════════════
# Next.js Environment Variables
# Copy this file: cp .env.example .env.local
# ═══════════════════════════════════════════════

# ─── Database ──────────────────────────────────
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"

# ─── NextAuth ──────────────────────────────────
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET=""  # Generate: openssl rand -base64 32

# ─── OAuth Providers ──────────────────────────
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
GITHUB_CLIENT_ID=""
GITHUB_CLIENT_SECRET=""

# ─── Stripe (optional) ────────────────────────
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=""

# ─── Supabase (optional) ──────────────────────
NEXT_PUBLIC_SUPABASE_URL=""
NEXT_PUBLIC_SUPABASE_ANON_KEY=""
SUPABASE_SERVICE_ROLE_KEY=""

# ─── AI / LLM (optional) ─────────────────────
ANTHROPIC_API_KEY=""
OPENAI_API_KEY=""

# ─── Email (optional) ─────────────────────────
RESEND_API_KEY=""

# ─── Storage (optional) ──────────────────────
AWS_REGION=""
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_S3_BUCKET=""

# ─── App ──────────────────────────────────────
NEXT_PUBLIC_APP_URL="http://localhost:3000"
NODE_ENV="development"
EOF
  ok "Generated .env.example for Next.js → $OUTPUT_DIR/.env.example"
}

gen_nestjs() {
  cat > "$OUTPUT_DIR/.env.example" << 'EOF'
# ═══════════════════════════════════════════════
# NestJS API Environment Variables
# Copy this file: cp .env.example .env
# ═══════════════════════════════════════════════

# ─── Database ──────────────────────────────────
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"

# ─── JWT ──────────────────────────────────────
JWT_SECRET=""           # Generate: openssl rand -base64 64
JWT_EXPIRATION="15m"
JWT_REFRESH_SECRET=""   # Generate: openssl rand -base64 64
JWT_REFRESH_EXPIRATION="7d"

# ─── App ──────────────────────────────────────
PORT=3001
NODE_ENV="development"
CORS_ORIGIN="http://localhost:3000"

# ─── Redis ────────────────────────────────────
REDIS_URL="redis://localhost:6379"

# ─── Email (optional) ─────────────────────────
SMTP_HOST=""
SMTP_PORT=587
SMTP_USER=""
SMTP_PASS=""
EMAIL_FROM="noreply@example.com"

# ─── Storage (optional) ──────────────────────
AWS_REGION=""
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_S3_BUCKET=""

# ─── Stripe (optional) ────────────────────────
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""

# ─── Logging ──────────────────────────────────
LOG_LEVEL="debug"
EOF
  ok "Generated .env.example for NestJS → $OUTPUT_DIR/.env.example"
}

gen_expo() {
  cat > "$OUTPUT_DIR/.env.example" << 'EOF'
# ═══════════════════════════════════════════════
# Expo / React Native Environment Variables
# Copy this file: cp .env.example .env
# ═══════════════════════════════════════════════

# ─── API ──────────────────────────────────────
EXPO_PUBLIC_API_URL="http://localhost:3001"

# ─── Supabase (optional) ──────────────────────
EXPO_PUBLIC_SUPABASE_URL=""
EXPO_PUBLIC_SUPABASE_ANON_KEY=""

# ─── Analytics (optional) ────────────────────
SENTRY_DSN=""
EXPO_PUBLIC_POSTHOG_KEY=""

# ─── Push Notifications (optional) ───────────
EXPO_PUBLIC_ONE_SIGNAL_APP_ID=""

# ─── EAS Build ────────────────────────────────
EAS_PROJECT_ID=""

# ─── Maps (optional) ─────────────────────────
EXPO_PUBLIC_GOOGLE_MAPS_KEY=""
EOF
  ok "Generated .env.example for Expo → $OUTPUT_DIR/.env.example"
}

gen_supabase() {
  cat > "$OUTPUT_DIR/.env.example" << 'EOF'
# ═══════════════════════════════════════════════
# Supabase Environment Variables
# Copy this file: cp .env.example .env.local
# ═══════════════════════════════════════════════

# ─── Supabase ─────────────────────────────────
NEXT_PUBLIC_SUPABASE_URL=""      # From: Supabase Dashboard → Settings → API
NEXT_PUBLIC_SUPABASE_ANON_KEY="" # From: Supabase Dashboard → Settings → API
SUPABASE_SERVICE_ROLE_KEY=""     # Server-side only — NEVER expose to client

# ─── Database (Direct) ───────────────────────
DATABASE_URL=""                  # From: Supabase Dashboard → Settings → Database

# ─── Auth ─────────────────────────────────────
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
GITHUB_CLIENT_ID=""
GITHUB_CLIENT_SECRET=""

# ─── Storage ──────────────────────────────────
# Storage is built into Supabase, no extra config needed

# ─── Edge Functions ──────────────────────────
# Secrets are set via: supabase secrets set KEY=value
RESEND_API_KEY=""
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""
EOF
  ok "Generated .env.example for Supabase → $OUTPUT_DIR/.env.example"
}

gen_fullstack() {
  cat > "$OUTPUT_DIR/.env.example" << 'EOF'
# ═══════════════════════════════════════════════
# Fullstack Monorepo Environment Variables
# Copy this file: cp .env.example .env
# ═══════════════════════════════════════════════

# ─── Database ──────────────────────────────────
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"

# ─── Frontend (Next.js) ──────────────────────
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET=""
NEXT_PUBLIC_API_URL="http://localhost:3001"
NEXT_PUBLIC_APP_URL="http://localhost:3000"

# ─── Backend (NestJS) ────────────────────────
PORT=3001
JWT_SECRET=""
JWT_REFRESH_SECRET=""
REDIS_URL="redis://localhost:6379"
CORS_ORIGIN="http://localhost:3000"

# ─── OAuth ────────────────────────────────────
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""

# ─── Stripe ───────────────────────────────────
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=""

# ─── AI (optional) ───────────────────────────
ANTHROPIC_API_KEY=""

# ─── Storage (optional) ──────────────────────
AWS_REGION=""
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_S3_BUCKET=""
EOF
  ok "Generated .env.example for Fullstack → $OUTPUT_DIR/.env.example"
}

interactive_menu() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║   📋 .env.example Generator                  ║${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${BOLD}Choose a template:${NC}"
  echo ""
  echo -e "    ${CYAN}1${NC}) 🌐 Next.js (Prisma + NextAuth + Stripe + Supabase + AI)"
  echo -e "    ${CYAN}2${NC}) ⚙️  NestJS (Prisma + JWT + Redis + Stripe + S3)"
  echo -e "    ${CYAN}3${NC}) 📱 Expo / React Native (API + Supabase + Analytics)"
  echo -e "    ${CYAN}4${NC}) 🟢 Supabase (Auth + Storage + Edge Functions)"
  echo -e "    ${CYAN}5${NC}) 🏗️  Fullstack Monorepo (Next.js + NestJS + all services)"
  echo -e "    ${CYAN}0${NC}) ❌ Exit"
  echo ""
  read -rp "  Choose template [0-5]: " choice
  echo ""

  case $choice in
    1) gen_nextjs ;;
    2) gen_nestjs ;;
    3) gen_expo ;;
    4) gen_supabase ;;
    5) gen_fullstack ;;
    0) echo "  Bye!"; exit 0 ;;
    *) err "Invalid choice"; exit 1 ;;
  esac
}

show_help() {
  echo ""
  echo -e "${BOLD}Usage:${NC} ./generate-env.sh [template] [output-dir]"
  echo ""
  echo -e "${BOLD}Templates:${NC}"
  echo "  nextjs      Next.js + Prisma + NextAuth + Stripe + AI"
  echo "  nestjs      NestJS + Prisma + JWT + Redis + S3"
  echo "  expo        Expo / React Native"
  echo "  supabase    Supabase project"
  echo "  fullstack   Monorepo (frontend + API)"
  echo ""
  echo -e "${BOLD}Examples:${NC}"
  echo "  ./generate-env.sh                          # Interactive menu"
  echo "  ./generate-env.sh nextjs ./my-project      # Generate for Next.js"
  echo "  ./generate-env.sh fullstack .              # Fullstack in current dir"
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────
case "${1:-}" in
  nextjs)    gen_nextjs ;;
  nestjs)    gen_nestjs ;;
  expo)      gen_expo ;;
  supabase)  gen_supabase ;;
  fullstack) gen_fullstack ;;
  --help|-h) show_help ;;
  "")        interactive_menu ;;
  *)         err "Unknown template: $1"; show_help; exit 1 ;;
esac

echo ""
echo -e "  ${DIM}Remember: cp .env.example .env.local (Next.js) or .env (others)${NC}"
echo -e "  ${DIM}Never commit .env files with real values!${NC}"
echo ""
