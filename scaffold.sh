#!/usr/bin/env bash
# ============================================================
#  Project Scaffolding — Generate ready-to-go project templates
#  Usage: ./scaffold.sh <template> [project-name]
#  Templates: nextjs, nestjs, expo, flutter, fullstack
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
info() { echo -e "  ${CYAN}ℹ  $1${NC}"; }
warn() { echo -e "  ${YELLOW}⚠  $1${NC}"; }
err()  { echo -e "  ${RED}❌ $1${NC}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║   🏗️  Project Scaffolding                    ║${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${BOLD}Usage:${NC} ./scaffold.sh <template> [project-name]"
  echo ""
  echo -e "${BOLD}Templates:${NC}"
  echo -e "  ${CYAN}nextjs${NC}      Next.js 14+ with TypeScript, Tailwind, Prisma, NextAuth"
  echo -e "  ${CYAN}nestjs${NC}      NestJS with TypeScript, Prisma, JWT, Swagger"
  echo -e "  ${CYAN}expo${NC}        React Native (Expo Router) with TypeScript, NativeWind"
  echo -e "  ${CYAN}flutter${NC}     Flutter with Riverpod, GoRouter, clean architecture"
  echo -e "  ${CYAN}fullstack${NC}   Monorepo: Next.js frontend + NestJS API + shared types"
  echo ""
  echo -e "${BOLD}Examples:${NC}"
  echo "  ./scaffold.sh nextjs my-saas-app"
  echo "  ./scaffold.sh fullstack my-platform"
  echo "  ./scaffold.sh expo my-mobile-app"
  echo ""
  echo -e "${BOLD}What gets created:${NC}"
  echo "  - Project with all configs pre-wired"
  echo "  - CLAUDE.md for AI-assisted development"
  echo "  - .cursorrules / .aider.conf.yml for multi-AI support"
  echo "  - .env.example with all required variables"
  echo "  - .gitignore with proper exclusions"
  echo "  - Ready to run immediately"
  echo ""
}

copy_ai_configs() {
  local target="$1"
  # Copy AI tool configs
  [ -f "$SCRIPT_DIR/CLAUDE.md" ] && cp "$SCRIPT_DIR/CLAUDE.md" "$target/CLAUDE.md"
  [ -f "$SCRIPT_DIR/.cursorrules" ] && cp "$SCRIPT_DIR/.cursorrules" "$target/.cursorrules"
  [ -f "$SCRIPT_DIR/.aider.conf.yml" ] && cp "$SCRIPT_DIR/.aider.conf.yml" "$target/.aider.conf.yml"
  [ -f "$SCRIPT_DIR/.windsurfrules" ] && cp "$SCRIPT_DIR/.windsurfrules" "$target/.windsurfrules"
  ok "AI tool configs copied (CLAUDE.md, .cursorrules, .aider.conf.yml, .windsurfrules)"
}

scaffold_nextjs() {
  local name="${1:-my-nextjs-app}"
  info "Scaffolding Next.js project: $name"

  npx create-next-app@latest "$name" \
    --typescript \
    --tailwind \
    --eslint \
    --app \
    --src-dir \
    --import-alias "@/*" \
    --use-npm

  cd "$name"

  # Install additional deps
  info "Installing additional dependencies..."
  npm install prisma @prisma/client next-auth@beta @auth/prisma-adapter
  npm install zustand @tanstack/react-query axios
  npm install -D @types/bcryptjs

  # Init Prisma
  npx prisma init --datasource-provider postgresql

  # Create .env.example
  cat > .env.example << 'ENVEOF'
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="generate-with-openssl-rand-base64-32"

# OAuth
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
GITHUB_CLIENT_ID=""
GITHUB_CLIENT_SECRET=""

# Stripe (optional)
STRIPE_SECRET_KEY=""
STRIPE_PUBLISHABLE_KEY=""
STRIPE_WEBHOOK_SECRET=""
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=""

# Supabase (optional)
NEXT_PUBLIC_SUPABASE_URL=""
NEXT_PUBLIC_SUPABASE_ANON_KEY=""
ENVEOF

  copy_ai_configs "."

  # Init git
  git init
  git add -A
  git commit -m "Initial scaffold: Next.js + TypeScript + Tailwind + Prisma + NextAuth"

  cd ..
  ok "Next.js project created: $name"
  echo ""
  echo -e "  ${BOLD}Next steps:${NC}"
  echo -e "    cd $name"
  echo -e "    cp .env.example .env.local"
  echo -e "    npx prisma db push"
  echo -e "    npm run dev"
  echo ""
}

scaffold_nestjs() {
  local name="${1:-my-nestjs-api}"
  info "Scaffolding NestJS project: $name"

  npx @nestjs/cli@latest new "$name" --package-manager npm --strict

  cd "$name"

  # Install additional deps
  info "Installing additional dependencies..."
  npm install prisma @prisma/client
  npm install @nestjs/swagger @nestjs/passport passport passport-jwt
  npm install @nestjs/config class-validator class-transformer
  npm install bcryptjs
  npm install -D @types/passport-jwt @types/bcryptjs

  # Init Prisma
  npx prisma init --datasource-provider postgresql

  # Create .env.example
  cat > .env.example << 'ENVEOF'
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"

# JWT
JWT_SECRET="generate-with-openssl-rand-base64-64"
JWT_EXPIRATION="15m"
JWT_REFRESH_EXPIRATION="7d"

# App
PORT=3001
NODE_ENV=development

# Redis (optional)
REDIS_URL="redis://localhost:6379"

# AWS (optional)
AWS_REGION=""
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_S3_BUCKET=""
ENVEOF

  copy_ai_configs "."

  git add -A
  git commit -m "Initial scaffold: NestJS + TypeScript + Prisma + JWT + Swagger"

  cd ..
  ok "NestJS project created: $name"
  echo ""
  echo -e "  ${BOLD}Next steps:${NC}"
  echo -e "    cd $name"
  echo -e "    cp .env.example .env"
  echo -e "    npx prisma db push"
  echo -e "    npm run start:dev"
  echo ""
}

scaffold_expo() {
  local name="${1:-my-expo-app}"
  info "Scaffolding Expo project: $name"

  npx create-expo-app@latest "$name" --template tabs

  cd "$name"

  info "Installing additional dependencies..."
  npm install zustand axios
  npm install nativewind tailwindcss
  npm install @react-navigation/native

  # Create .env.example
  cat > .env.example << 'ENVEOF'
# API
EXPO_PUBLIC_API_URL="http://localhost:3001"

# Supabase (optional)
EXPO_PUBLIC_SUPABASE_URL=""
EXPO_PUBLIC_SUPABASE_ANON_KEY=""

# Sentry (optional)
SENTRY_DSN=""

# EAS
EAS_PROJECT_ID=""
ENVEOF

  copy_ai_configs "."

  git add -A
  git commit -m "Initial scaffold: Expo + TypeScript + NativeWind + Zustand"

  cd ..
  ok "Expo project created: $name"
  echo ""
  echo -e "  ${BOLD}Next steps:${NC}"
  echo -e "    cd $name"
  echo -e "    cp .env.example .env"
  echo -e "    npx expo start"
  echo ""
}

scaffold_flutter() {
  local name="${1:-my_flutter_app}"
  info "Scaffolding Flutter project: $name"

  flutter create --org com.example --platforms=android,ios,web "$name"

  cd "$name"

  # Add common dependencies to pubspec.yaml
  flutter pub add flutter_riverpod go_router dio freezed_annotation json_annotation
  flutter pub add --dev freezed build_runner json_serializable

  copy_ai_configs "."

  git add -A
  git commit -m "Initial scaffold: Flutter + Riverpod + GoRouter + Dio + Freezed"

  cd ..
  ok "Flutter project created: $name"
  echo ""
  echo -e "  ${BOLD}Next steps:${NC}"
  echo -e "    cd $name"
  echo -e "    flutter run"
  echo ""
}

scaffold_fullstack() {
  local name="${1:-my-fullstack-app}"
  info "Scaffolding fullstack monorepo: $name"

  mkdir -p "$name"
  cd "$name"

  # Initialize npm workspace
  cat > package.json << 'PKGEOF'
{
  "name": "my-fullstack-app",
  "private": true,
  "workspaces": ["apps/*", "packages/*"],
  "scripts": {
    "dev": "npm run dev --workspaces --if-present",
    "build": "npm run build --workspaces --if-present",
    "lint": "npm run lint --workspaces --if-present",
    "db:push": "cd apps/api && npx prisma db push",
    "db:studio": "cd apps/api && npx prisma studio",
    "db:migrate": "cd apps/api && npx prisma migrate dev"
  },
  "devDependencies": {
    "typescript": "^5.3.0"
  }
}
PKGEOF

  # Create web app
  mkdir -p apps
  info "Creating Next.js frontend..."
  cd apps
  npx create-next-app@latest web \
    --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-npm
  cd ..

  # Create API
  info "Creating NestJS API..."
  cd apps
  npx @nestjs/cli@latest new api --package-manager npm --strict
  cd api
  npm install prisma @prisma/client @nestjs/swagger @nestjs/config
  npx prisma init --datasource-provider postgresql
  cd ../..

  # Shared types package
  mkdir -p packages/shared/src
  cat > packages/shared/package.json << 'SHAREDEOF'
{
  "name": "@repo/shared",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "build": "tsc",
    "lint": "tsc --noEmit"
  }
}
SHAREDEOF

  cat > packages/shared/src/index.ts << 'TSEOF'
/** Shared types used across web and API */

export interface User {
  id: string;
  email: string;
  name: string | null;
  role: 'USER' | 'ADMIN';
  createdAt: string;
}

export interface ApiResponse<T> {
  data: T;
  message: string;
  success: boolean;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    perPage: number;
    total: number;
    totalPages: number;
  };
}
TSEOF

  cat > packages/shared/tsconfig.json << 'TSCEOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "strict": true,
    "esModuleInterop": true,
    "declaration": true,
    "outDir": "./dist"
  },
  "include": ["src"]
}
TSCEOF

  # Root .env.example
  cat > .env.example << 'ENVEOF'
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"

# Web (Next.js)
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET=""
NEXT_PUBLIC_API_URL="http://localhost:3001"

# API (NestJS)
PORT=3001
JWT_SECRET=""
REDIS_URL="redis://localhost:6379"

# OAuth
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""

# Stripe
STRIPE_SECRET_KEY=""
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=""
ENVEOF

  # Docker compose for local dev
  cat > docker-compose.yml << 'DOCKEREOF'
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  pgdata:
DOCKEREOF

  copy_ai_configs "."

  # Git init
  git init
  git add -A
  git commit -m "Initial scaffold: Fullstack monorepo (Next.js + NestJS + shared types)"

  cd ..
  ok "Fullstack monorepo created: $name"
  echo ""
  echo -e "  ${BOLD}Structure:${NC}"
  echo "    $name/"
  echo "    ├── apps/web/          (Next.js frontend)"
  echo "    ├── apps/api/          (NestJS backend)"
  echo "    ├── packages/shared/   (Shared TypeScript types)"
  echo "    ├── docker-compose.yml (PostgreSQL + Redis)"
  echo "    └── .env.example"
  echo ""
  echo -e "  ${BOLD}Next steps:${NC}"
  echo -e "    cd $name"
  echo -e "    cp .env.example .env"
  echo -e "    docker compose up -d"
  echo -e "    npm run db:push"
  echo -e "    npm run dev"
  echo ""
}

interactive_menu() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║   🏗️  Project Scaffolding                    ║${NC}"
  echo -e "${BOLD}${CYAN}║   Generate a ready-to-go project             ║${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${BOLD}Choose a template:${NC}"
  echo ""
  echo -e "    ${CYAN}1${NC}) 🌐 Next.js — App Router + Tailwind + Prisma + NextAuth"
  echo -e "    ${CYAN}2${NC}) ⚙️  NestJS — REST API + Prisma + JWT + Swagger"
  echo -e "    ${CYAN}3${NC}) 📱 Expo — React Native + TypeScript + NativeWind"
  echo -e "    ${CYAN}4${NC}) 🦋 Flutter — Riverpod + GoRouter + Dio + Freezed"
  echo -e "    ${CYAN}5${NC}) 🏗️  Fullstack Monorepo — Next.js + NestJS + Shared Types"
  echo -e "    ${CYAN}0${NC}) ❌ Exit"
  echo ""
  read -rp "  Choose template [0-5]: " choice
  echo ""

  if [ "$choice" = "0" ]; then
    echo "  Bye!"
    exit 0
  fi

  read -rp "  Project name: " project_name
  echo ""

  case $choice in
    1) scaffold_nextjs "$project_name" ;;
    2) scaffold_nestjs "$project_name" ;;
    3) scaffold_expo "$project_name" ;;
    4) scaffold_flutter "$project_name" ;;
    5) scaffold_fullstack "$project_name" ;;
    *) err "Invalid choice" ; exit 1 ;;
  esac
}

# ─── Main ─────────────────────────────────────────────────────
case "${1:-}" in
  nextjs)   scaffold_nextjs "${2:-}" ;;
  nestjs)   scaffold_nestjs "${2:-}" ;;
  expo)     scaffold_expo "${2:-}" ;;
  flutter)  scaffold_flutter "${2:-}" ;;
  fullstack) scaffold_fullstack "${2:-}" ;;
  --help|-h) show_help ;;
  "")       interactive_menu ;;
  *)        err "Unknown template: $1" ; show_help ; exit 1 ;;
esac
