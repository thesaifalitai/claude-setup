# 🚀 Full Stack Freelancer — Claude + VS Code Setup Guide

**For:** React Native • Flutter • Node.js • Next.js Developer on Upwork  
**Date:** February 2026

---

## What Was Set Up

### ✅ Claude Skills (installed to `~/.claude/skills/`)

| Skill | Triggers On |
|-------|------------|
| `react-native-expo` | React Native, Expo, iOS/Android app, mobile dev |
| `flutter-dev` | Flutter, Dart, Riverpod, GoRouter, Material 3 |
| `nodejs-backend` | Node.js, NestJS, Express, REST API, GraphQL, JWT |
| `nextjs-frontend` | Next.js, React, Vue, App Router, SSR/SSG, Vercel |
| `uiux-design` | UI design, Tailwind, shadcn/ui, accessibility, dark mode |
| `devops-cicd` | Docker, AWS, Nginx, GitHub Actions, CI/CD, deployment |
| `upwork-freelancer` | Proposals, client messages, scoping, reviews |
| `fullstack-architecture` | System design, monorepo, DB schema, API design |

### ✅ Global CLAUDE.md (`~/.claude/CLAUDE.md`)
Sets your coding standards, tech preferences, and freelance context globally.

---

## Step 1: Install Claude Code CLI

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version

# Login with your Anthropic account
claude auth login

# Test it works
claude "Hello! List my installed skills"
```

---

## Step 2: Set Up VS Code

### Install VS Code (if not installed)
Download from: https://code.visualstudio.com

### Copy VS Code Settings

```bash
# macOS path
mkdir -p "$HOME/Library/Application Support/Code/User"

# Copy settings
cp settings.json "$HOME/Library/Application Support/Code/User/settings.json"
cp keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
```

### Install All Extensions (one command)

```bash
# Install all extensions at once
cat extensions.txt | grep -v "^#" | grep -v "^$" | xargs -L 1 code --install-extension
```

Or install individually in VS Code (`Cmd+Shift+X`):
- **Prettier** - Code formatter
- **ESLint** - Linting
- **GitLens** - Git superpowers
- **Tailwind CSS IntelliSense** - Tailwind autocomplete
- **Thunder Client** - API testing (like Postman)
- **Flutter + Dart** - Flutter development
- **React Native Tools** - RN debugging
- **Prisma** - Database schema highlighting
- **Docker** - Container management

### Install Claude Code VS Code Extension

1. Open VS Code
2. Press `Cmd+Shift+X`
3. Search: **"Claude"** or **"Anthropic"**
4. Install **Claude** (by Anthropic)

Or via terminal:
```bash
code --install-extension anthropic.claude-code
```

---

## Step 3: Configure Claude in VS Code

After installing the extension:

1. Open **Command Palette** (`Cmd+Shift+P`)
2. Type: `Claude: Sign In`
3. Complete auth

**Use Claude in VS Code:**
- `Cmd+Shift+A` → Open new terminal, run `claude`
- Select code → Right-click → "Ask Claude"
- `Cmd+Shift+P` → "Claude: Explain Code"
- `Cmd+Shift+P` → "Claude: Fix Issues"

---

## Step 4: Add Project CLAUDE.md

For each project, add a `CLAUDE.md` at the root:

```bash
# In your project folder
cat > CLAUDE.md << 'PROJECTEOF'
# Project: [App Name]

## Stack
- Frontend: Next.js 14 App Router + TypeScript + Tailwind
- Backend: NestJS + Prisma + PostgreSQL
- Mobile: React Native + Expo Router

## Architecture Notes
- API base: http://localhost:3000/api/v1
- Auth: JWT (access 15min, refresh 30 days)
- Feature-based folder structure under src/modules/

## Run Commands
- `npm run dev` - Start all services
- `npm run db:migrate` - Run migrations
- `npm test` - Run tests

## Key Conventions
- All API responses use { data, meta } format
- Errors use { statusCode, error, message } format
- Dates are ISO 8601 strings
PROJECTEOF
```

---

## Step 5: Verify Skills Are Working

```bash
# In any terminal with claude
claude

# Test skill triggering
> "Write me a React Native screen with a FlatList"
# → Should trigger react-native-expo skill

> "Create a NestJS controller for a products API"
# → Should trigger nodejs-backend skill

> "Write an Upwork proposal for a React Native job"
# → Should trigger upwork-freelancer skill

> "Set up a Docker Compose for Node + Postgres + Redis"
# → Should trigger devops-cicd skill
```

---

## Step 6: Mac Setup for Full Stack Dev

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install essentials
brew install node@20 git gh postgresql@16 redis docker

# Install Flutter
brew install --cask flutter

# Verify Flutter
flutter doctor

# Install Xcode CLI tools (for iOS)
xcode-select --install

# Install Android Studio (for Android/React Native)
brew install --cask android-studio

# Node version manager
brew install nvm
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"' >> ~/.zshrc
source ~/.zshrc
nvm install 20
nvm use 20

# Global npm tools
npm install -g @anthropic-ai/claude-code
npm install -g typescript tsx
npm install -g @nestjs/cli
npm install -g create-expo-app eas-cli
```

---

## Daily Workflow

### Starting a New Upwork Project

```bash
# 1. Create project from template
npx create-next-app@latest client-project --typescript --tailwind --app --eslint

# 2. Add CLAUDE.md with project context
# 3. Open in VS Code
code client-project

# 4. Open terminal, start Claude
claude

# 5. Ask Claude to scaffold
> "Set up this Next.js project with shadcn/ui, NextAuth, and Prisma with PostgreSQL"
```

### Writing Upwork Proposals

```bash
claude
> "Write an Upwork proposal for this job: [paste job description]"
# → upwork-freelancer skill kicks in automatically
```

### Code Review Before Delivery

```bash
claude
> "Review my code for production readiness and security issues"
```

---

## Skill Locations

```
~/.claude/
├── CLAUDE.md                          ← Global coding rules
└── skills/
    ├── react-native-expo/SKILL.md     ← React Native & Expo
    ├── flutter-dev/SKILL.md           ← Flutter & Dart
    ├── nodejs-backend/SKILL.md        ← Node.js backends
    ├── nextjs-frontend/SKILL.md       ← Next.js frontends
    ├── uiux-design/SKILL.md           ← UI/UX design
    ├── devops-cicd/SKILL.md           ← Docker/AWS/CI-CD
    ├── upwork-freelancer/SKILL.md     ← Proposals & client comms
    └── fullstack-architecture/SKILL.md ← System architecture
```

---

## Troubleshooting

**Skills not triggering?**
```bash
# Check skills are installed
ls ~/.claude/skills/

# List skills in Claude
claude
> /skills
```

**VS Code extension not working?**
```bash
# Re-install
code --uninstall-extension anthropic.claude-code
code --install-extension anthropic.claude-code
```

**Flutter doctor issues?**
```bash
flutter doctor -v
# Follow each recommendation shown
```

---

*Setup complete. All skills are active globally — they'll trigger automatically in any Claude Code session.*
