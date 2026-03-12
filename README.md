<div align="center">

# 🚀 Claude Fullstack Freelancer Setup

**One script. Zero duplicates. Every tool your freelance stack needs.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Skills-purple?style=flat-square)](https://claude.ai/claude-code)
[![macOS](https://img.shields.io/badge/macOS-Apple_Silicon_%26_Intel-black?style=flat-square&logo=apple)](setup.sh)
[![Linux](https://img.shields.io/badge/Linux-Ubuntu_%26_Debian-orange?style=flat-square&logo=linux)](setup-linux.sh)
[![Windows](https://img.shields.io/badge/Windows-10_%26_11-blue?style=flat-square&logo=windows)](setup-windows.ps1)
[![Skills](https://img.shields.io/badge/Skills-42_Installed-green?style=flat-square)](#-skills-reference)
[![Universal](https://img.shields.io/badge/Universal-Claude_|_Cursor_|_Aider_|_Windsurf-blue?style=flat-square)](#-universal-ai-tool-support)
[![Web & Desktop](https://img.shields.io/badge/Web_%26_Desktop-claude.ai_%7C_Desktop_App-indigo?style=flat-square)](#-web--desktop-support)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](CONTRIBUTING.md)

A complete, automated setup for full-stack freelancers using **Claude Code**, **Cursor**, **Aider**, **Windsurf**, **claude.ai Web**, and **Claude Desktop**.
Installs every tool, framework, and AI skill you need — skips what you already have.

[Quick Start](#-quick-start) · [Skills](#-skills-reference) · [Web & Desktop](#-web--desktop-support) · [Doctor](#-health-check) · [Scaffold](#-project-scaffolding) · [Token Tracking](#-token--cost-tracking) · [Universal AI](#-universal-ai-tool-support) · [Contributing](CONTRIBUTING.md)

</div>

---

## ✨ Why This Repo?

Setting up a new Mac for full-stack freelance work takes hours — installing Flutter, Node, Docker, configuring VS Code, setting up Claude skills. This repo automates **everything** in one script:

- ✅ **Smart install** — checks before installing, never duplicates
- ✅ **Safe to re-run** — run anytime to add new tools or catch missing ones
- ✅ **42 Claude AI skills** — auto-trigger the right expert for every task
- ✅ **Interactive skill selector** — choose exactly what you need by category
- ✅ **Health check (`./doctor.sh`)** — verify your entire dev environment like `flutter doctor`
- ✅ **Project scaffolding** — generate Next.js, NestJS, Expo, Flutter, or fullstack monorepo projects
- ✅ **Token & cost tracking** — see input/output tokens and cost per request
- ✅ **Token optimizer** — built-in model selection, context management, and prompt efficiency to maximise every token
- ✅ **Universal AI support** — works with Claude Code, Cursor, Aider, and Windsurf
- ✅ **Web & Desktop support** — export skills as system prompts for claude.ai Projects and Claude Desktop
- ✅ **Linux support** — Ubuntu, Debian, and derivatives
- ✅ **Auto-update** — pull latest skills and configs with `./update.sh`
- ✅ **.env generator** — generate environment templates for any stack
- ✅ **GitHub Actions templates** — CI/CD pipelines ready to copy
- ✅ **VS Code fully configured** — settings, keybindings, 21 extensions
- ✅ **Freelancer-ready** — Upwork proposals, client replies, project scoping built in

---

## 🏃 Quick Start

> **Requires:** macOS, Linux, or Windows · Internet connection · ~15 min

```bash
# Clone the repo
git clone https://github.com/thesaifalitai/claude-setup.git
cd claude-setup

# macOS (Apple Silicon & Intel)
chmod +x setup.sh && ./setup.sh

# Linux (Ubuntu/Debian)
chmod +x setup-linux.sh && ./setup-linux.sh

# Windows (PowerShell — Run as Administrator)
.\setup-windows.ps1

# Verify your environment
./doctor.sh
```

That's it. The script handles everything else — including skipping tools you already have.

### Windows Setup Options

```powershell
.\setup-windows.ps1                    # Interactive — choose what to install
.\setup-windows.ps1 --all              # Install everything (no prompts)
.\setup-windows.ps1 --skills-only      # Only install Claude skills (no dev tools)
.\setup-windows.ps1 --only node,git    # Install specific tools only
.\setup-windows.ps1 --list             # Show available tools & install status
```

> **Note:** Windows script uses `winget` (built-in on Windows 10 1709+). For tools not in winget, it falls back to `npm` or `Chocolatey`.

### One-line install (no clone needed — macOS/Linux only)

```bash
curl -fsSL https://raw.githubusercontent.com/thesaifalitai/claude-setup/main/setup.sh | bash
```

> ⚠️ The one-liner won't copy skills locally. Use the `git clone` method to get all 43 skills installed.

### Efficiency hooks (auto-installed by setup.sh)

The setup script automatically installs two hooks + optimal settings:

| Hook | What it does |
|------|-------------|
| `compact-reminder.sh` | Reminds you to `/compact` at turns 20, 40, 60+ — prevents context overflow |
| `auto-skill.sh` | Detects the file type you're editing and suggests the right skill automatically |

**Settings applied:**

| Setting | Value | Benefit |
|---------|-------|---------|
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | `50` | Auto-compacts at 50% context usage |
| `CLAUDE_CODE_SUBAGENT_MODEL` | `haiku` | Subagents use Haiku (3× cheaper) |
| `MAX_THINKING_TOKENS` | `10000` | Caps internal reasoning (faster + focused) |

To install hooks separately:

```bash
./install_hooks.sh
```

---

## 📦 What Gets Installed

Each item is **checked before installing** — already installed = skipped with `⏭` in the output.

| # | Tool | Version | Purpose |
|---|------|---------|---------|
| 1 | Xcode CLI Tools | latest | macOS build tools |
| 2 | Homebrew | latest | macOS package manager |
| 3 | Git | latest | Version control |
| 4 | GitHub CLI (`gh`) | latest | GitHub from terminal |
| 5 | NVM | latest | Node version manager |
| 6 | Node.js | 20 LTS | JavaScript runtime |
| 7 | Claude CLI | latest | AI coding assistant |
| 8 | TypeScript | latest | Type-safe JavaScript |
| 9 | tsx | latest | Run TS files directly |
| 10 | NestJS CLI | latest | Backend scaffolding |
| 11 | EAS CLI | latest | Expo app builds |
| 12 | Expo CLI | latest | React Native tooling |
| 13 | Flutter + Dart | latest stable | Cross-platform mobile |
| 14 | Docker Desktop | latest | Containerization |
| 15 | PostgreSQL 16 | 16.x | Relational database |
| 16 | Redis | 7.x | Cache & queue |
| 17 | Nginx | latest | Web server / proxy |
| 18 | AWS CLI | latest | Cloud infrastructure |
| 19 | VS Code | latest | Code editor |

---

## 🧠 Skills Reference

Claude AI **automatically uses the right skill** based on what you type. No manual activation needed.

### 📱 Mobile Development

<details>
<summary><strong>react-native-expo</strong> — React Native + Expo (click to expand)</summary>

**Triggers on:** React Native, Expo, Expo Router, EAS Build, iOS/Android app, mobile dev, Reanimated, FlashList

**What it knows:**
- Expo SDK 50+ and bare CLI workflows
- Expo Router (file-based navigation)
- EAS Build + EAS Submit + OTA updates
- Performance: FlashList, Reanimated 3, Skia
- State: Zustand + React Query
- GitHub Actions → EAS Build CI/CD
- Sentry crash reporting

```bash
# Example triggers
"Build a React Native login screen with biometric auth"
"Set up Expo Router with tabs and auth flow"
"Write an EAS Build GitHub Actions workflow"
```

</details>

<details>
<summary><strong>flutter-dev</strong> — Flutter + Dart (click to expand)</summary>

**Triggers on:** Flutter, Dart, Riverpod, GoRouter, Freezed, Material 3, Flutter test

**What it knows:**
- Clean architecture (data / domain / presentation)
- Riverpod 2.x state management with code generation
- GoRouter file-based navigation
- Freezed data models + JSON serialization
- Dio HTTP client with interceptors & retry
- Fastlane + Codemagic CI/CD

```bash
# Example triggers
"Create a Flutter app with Riverpod authentication"
"Set up GoRouter with auth guards in Flutter"
"Write a Dio interceptor with refresh token logic"
```

</details>

<details>
<summary><strong>flutter-expert / react-native-expert</strong> — Community skills from Jeffallan</summary>

Additional expert-level mobile skills sourced from [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) — focused on architecture patterns and production best practices.

</details>

---

### ⚙️ Backend Development

<details>
<summary><strong>nodejs-backend</strong> — Node.js / NestJS / Express</summary>

**Triggers on:** Node.js, NestJS, Express, REST API, GraphQL, JWT, Prisma, Redis, BullMQ

**What it knows:**
- NestJS module architecture (controllers, services, guards)
- Prisma ORM with PostgreSQL/MySQL schemas
- JWT authentication with refresh token rotation
- Redis caching (ioredis)
- BullMQ job queues
- Global exception filters + interceptors
- Rate limiting + Helmet security

```bash
"Build a NestJS CRUD API for products with JWT auth"
"Create a Prisma schema for a multi-tenant SaaS"
"Set up BullMQ email queue with retry logic"
```

</details>

<details>
<summary><strong>nestjs-expert</strong> — NestJS deep expertise (community)</summary>

Enterprise-grade NestJS patterns including dependency injection, custom decorators, microservices, and testing strategies.

</details>

<details>
<summary><strong>django-expert</strong> — Django + DRF</summary>

**Triggers on:** Django, DRF, Python web app, Django REST framework, Django ORM

Production Django apps with Django REST Framework, Celery, PostgreSQL, and deployment patterns.

</details>

<details>
<summary><strong>fastapi-expert</strong> — FastAPI async Python</summary>

**Triggers on:** FastAPI, async Python API, Pydantic, Python REST API

Async Python APIs with FastAPI, Pydantic V2, SQLAlchemy async, and Alembic migrations.

</details>

<details>
<summary><strong>laravel-specialist</strong> — Laravel PHP</summary>

**Triggers on:** Laravel, PHP, Eloquent, Artisan, Blade

Modern Laravel with Eloquent ORM, Livewire, Sanctum auth, and Forge deployment.

</details>

---

### 🌐 Frontend Development

<details>
<summary><strong>nextjs-frontend</strong> — Next.js + React + Vue</summary>

**Triggers on:** Next.js, App Router, React, Vue, SSR, SSG, Vercel, shadcn/ui, React Query

**What it knows:**
- Next.js 14 App Router (Server vs Client components)
- React Hook Form + Zod validation
- TanStack Query (React Query) data fetching
- Next.js Metadata API (SEO)
- Middleware (auth protection)
- Core Web Vitals optimization

```bash
"Build a Next.js dashboard with server components and Prisma"
"Create a login form with React Hook Form and Zod"
"Optimize my Next.js app for Core Web Vitals"
```

</details>

<details>
<summary><strong>nextjs-developer / vue-expert</strong> — Community skills</summary>

Deep-dive Next.js Server Actions, Server Components, and Vue 3 Composition API with Pinia.

</details>

<details>
<summary><strong>typescript-pro</strong> — Advanced TypeScript</summary>

**Triggers on:** TypeScript generics, utility types, type guards, conditional types, mapped types

Expert TypeScript: advanced generics, template literal types, discriminated unions, branded types.

</details>

---

### 🎨 UI / UX Design

<details>
<summary><strong>uiux-design</strong> — Tailwind + Component Design Systems</summary>

**Triggers on:** UI design, Tailwind CSS, shadcn/ui, dark mode, accessibility, responsive, animations

**What it knows:**
- Design tokens with CSS variables (light/dark)
- CVA (class-variance-authority) component variants
- Framer Motion page transitions + staggered lists
- WCAG 2.1 AA accessibility patterns
- Skeleton loaders + empty states
- Mobile-first responsive layouts

```bash
"Design a responsive dashboard sidebar with dark mode"
"Create an accessible modal with focus management"
"Build a design system with Tailwind and shadcn/ui"
```

</details>

<details>
<summary><strong>ui-ux-pro-max</strong> — Design Intelligence (67 styles · 96 palettes · 57 fonts · 100 reasoning rules)</summary>

**Triggers on:** design, build, create, implement, review, fix, improve UI/UX for websites, landing pages, dashboards, SaaS, mobile apps, e-commerce, portfolios

**What it knows:**
- 67 UI styles — glassmorphism, claymorphism, brutalism, bento grid, neumorphism and more
- 96 industry-specific color palettes with hex values and mood context
- 57 Google Font pairings with CSS imports
- 100 reasoning rules mapping product type → optimal style/color/typography
- 99 UX best practices (accessibility, animations, touch targets)
- 25 chart types with library recommendations
- Stack-specific guidelines: React, Next.js, Vue, Flutter, React Native, SwiftUI, shadcn/ui, Jetpack Compose

**How it works:** Runs a Python BM25 search engine over local CSV databases to generate a complete design system — then uses that as a blueprint for code generation.

```bash
# Claude automatically runs:
python3 ~/.claude/skills/ui-ux-pro-max/scripts/search.py "beauty spa wellness" --design-system -p "Serenity Spa"

# Then generates pixel-perfect code using the design system output
```

> **Requires Python 3** — install with `brew install python3` (macOS) or `apt install python3` (Linux)

</details>

---

### 🔧 DevOps & Infrastructure

<details>
<summary><strong>devops-cicd</strong> — Docker / GitHub Actions / AWS / Nginx</summary>

**Triggers on:** Docker, Nginx, GitHub Actions, AWS, CI/CD, deployment, containers

**What it knows:**
- Multi-stage Dockerfiles (Node, Python)
- Docker Compose (dev + prod)
- GitHub Actions: test → build → push → deploy
- Nginx: SSL, reverse proxy, gzip, security headers
- AWS Lambda (Serverless Framework)
- Blue/green zero-downtime deployments
- Winston structured logging + Sentry

```bash
"Write a multi-stage Dockerfile for my NestJS app"
"Create a GitHub Actions workflow that deploys to EC2"
"Configure Nginx as a reverse proxy with SSL"
```

</details>

<details>
<summary><strong>kubernetes-specialist / cloud-architect</strong> — K8s + Multi-cloud</summary>

Kubernetes deployments, Helm charts, Horizontal Pod Autoscaling, AWS/GCP/Azure architecture patterns.

</details>

<details>
<summary><strong>devops-engineer</strong> — Community DevOps skill</summary>

Platform engineering, advanced CI/CD pipelines, and production incident response patterns.

</details>

---

### 🏗️ Architecture

<details>
<summary><strong>fullstack-architecture</strong> — System Design + Monorepo</summary>

**Triggers on:** Architecture, monorepo, Turborepo, system design, DB schema, multi-tenant SaaS

**What it knows:**
- Turborepo monorepo (web + api + mobile in one repo)
- Multi-tenant SaaS schema patterns
- REST API design standards (pagination, errors)
- JWT + refresh token rotation architecture
- S3 presigned URL upload flow
- Stripe payment integration pattern
- WebSocket + SSE real-time patterns
- Redis caching strategy (TTLs, invalidation)

</details>

<details>
<summary><strong>graphql-architect / microservices-architect / api-designer</strong></summary>

GraphQL schema design + federation, microservices with service mesh, REST API OpenAPI standards.

</details>

---

### 💼 Freelancing (Upwork)

<details>
<summary><strong>upwork-freelancer</strong> — Proposals + Client Communication</summary>

**Triggers on:** Upwork proposal, bid, client message, project scope, quote, client reply, freelance

**Templates included:**
- 3 winning proposal templates (React Native, Node.js, Full Stack)
- Discovery call message
- Project kickoff message
- Scope change request
- Asking for a review
- Handling vague requirements
- Rate negotiation scripts
- Project scoping document template
- Red flags checklist

```bash
"Write an Upwork proposal for this React Native job: [paste JD]"
"Reply to this client who wants to change scope mid-project"
"Write a project kickoff message for my new client"
```

</details>

---

### 🛠️ Utilities

<details>
<summary><strong>token-tracker</strong> — Token Usage & Cost Monitoring</summary>

**Triggers on:** token usage, API cost, token count, input/output tokens, billing, cost tracking, cost estimate

**What it knows:**
- Per-request token estimation (input + output + context %)
- Cost calculation for Claude Opus/Sonnet/Haiku with cache pricing
- Cross-provider cost comparison (GPT-4o, Gemini 2.0, DeepSeek)
- Session summaries with cumulative stats
- Context window usage tracker with /compact warnings
- Daily / monthly budget estimator by use case

```bash
"Enable token tracking"
"How much did this request cost?"
"Compare costs across Claude models"
"Show me my session token usage summary"
"Estimate my monthly cost if I use Claude 2 hours/day"
```

</details>

<details>
<summary><strong>token-optimizer</strong> — Active Token Saving & Context Efficiency</summary>

**Triggers on:** save tokens, reduce cost, context window full, which model should I use, Haiku vs Sonnet vs Opus, when to compact, prompt is too long, Claude is getting slow

**What it knows:**
- Model selection guide — exact task → model mapping (Haiku / Sonnet / Opus)
- When and how to use `/compact`, `/clear`, and subagents
- Prompt engineering templates that eliminate wasted tokens
- Context inclusion strategy (what to include vs exclude)
- Subagent strategy to keep main context clean
- Prompt caching patterns (90% input cost reduction)
- Session efficiency checklist
- Emergency context-full recovery procedure

```bash
"Which model should I use for code generation?"
"How do I save tokens when working with large files?"
"My context is almost full, what do I do?"
"Show me the proactive compaction schedule"
"How do I write prompts that use fewer tokens?"
```

</details>

---

### 📋 Project & Leadership

<details>
<summary><strong>technical-writer</strong> — README · ADR · Runbook · OpenAPI · Changelog · Postmortem</summary>

**Triggers on:** README, API docs, ADR, runbook, changelog, postmortem, onboarding guide, technical blog, JSDoc, TSDoc

**What it knows:**
- README templates (Quick Start, API Reference, Configuration, Contributing)
- Architecture Decision Records (ADR) — captures *why*, not just *what*
- Runbooks designed for incident response (fast to scan under pressure)
- OpenAPI / Swagger documentation
- Changelogs in Keep a Changelog format
- Postmortem templates (timeline, root cause, action items)
- JSDoc / TSDoc annotation patterns

```bash
"Write a README for my Next.js SaaS starter"
"Create an ADR for switching from Mongoose to Prisma"
"Write a runbook for database connection failures"
"Generate a changelog for this release"
"Write a postmortem for last night's outage"
```

</details>

<details>
<summary><strong>cto-advisor</strong> — Tech Strategy · Team Scaling · Build vs Buy · DORA Metrics · Engineering Culture</summary>

**Triggers on:** technology strategy, engineering roadmap, build vs buy, technical debt, DORA metrics, team structure, engineering OKRs, hiring engineers, vendor evaluation, first 90 days as CTO

**What it knows:**
- Tech Radar (Adopt / Trial / Assess / Hold)
- Build vs Buy decision framework
- OKR templates for engineering teams
- Technical debt classification matrix (2×2: impact vs effort)
- DORA metrics benchmarks (elite, high, medium, low)
- Team Topologies (stream-aligned, platform, enabling, complicated-subsystem)
- Engineering hiring scorecard
- First 90 days as CTO / tech lead playbook
- Blameless postmortem culture
- Vendor / platform evaluation template

```bash
"Should we build our own auth or use Auth0?"
"Help me write engineering OKRs for next quarter"
"How should I structure my engineering team as we go from 5 to 20 engineers?"
"What are the DORA metrics and how do I measure them?"
"Write a vendor evaluation for choosing between Supabase and PlanetScale"
```

</details>

<details>
<summary><strong>project-manager</strong> — Agile · Sprint Planning · Stakeholder Reports · Scope Management · Release Planning</summary>

**Triggers on:** sprint planning, backlog grooming, user stories, retrospective, stakeholder update, scope creep, milestone planning, status report, release checklist, project kick-off

**What it knows:**
- Agile frameworks comparison (Scrum, Kanban, Shape Up, Dual-track)
- User story format (As a / I want / So that + Acceptance Criteria + DoD)
- Sprint planning template (capacity, velocity, backlog)
- Sprint retrospective (Start / Stop / Continue)
- Project kick-off document (RACI, milestones, risks, communication plan)
- Weekly status report template
- Scope change management (impact assessment + client templates)
- Release planning checklist (engineering + product + process)

```bash
"Write a project kick-off document for our payments feature"
"Help me structure this sprint retrospective"
"A client wants to add a feature mid-sprint — how do I handle it?"
"Write a weekly status report for our mobile app project"
"Create a release checklist for our v2.0 launch"
```

</details>

<details>
<summary><strong>task-estimator</strong> — Story Points · Epic Breakdown · Sprint Capacity · Timeline Forecasting · Spike Templates</summary>

**Triggers on:** estimation, story points, task breakdown, how long, timeline, sprint capacity, epic decomposition, T-shirt sizing, three-point estimation, Monte Carlo, spike

**What it knows:**
- Three-point estimation (Optimistic / Most Likely / Pessimistic)
- Epic decomposition: vertical slicing (not horizontal)
- Hidden work checklist (error states, tests, migrations, reviews)
- Story point reference card (1–13, with wall-clock guidance)
- Sprint capacity formula (70% effective capacity rule)
- Timeline forecasting: velocity-based + Monte Carlo
- Estimation bias detection (optimism bias, planning fallacy, novelty tax)
- Stakeholder communication templates for estimates and bad news
- Spike templates for de-risking unknowns

```bash
"Break down this 'user authentication' epic into stories and estimate it"
"How long will it take to build a Stripe subscription billing system?"
"We have 4 engineers for a 2-week sprint — what's our capacity?"
"A stakeholder is asking when the feature will be done — help me answer"
"This is too uncertain to estimate — write a spike for it"
```

</details>

---

### 🔍 Code Quality

<details>
<summary><strong>debugging-wizard / code-reviewer / test-master / secure-code-guardian</strong></summary>

| Skill | Purpose |
|-------|---------|
| `debugging-wizard` | Systematic debugging across all languages |
| `code-reviewer` | Thorough code reviews with actionable feedback |
| `test-master` | Unit, integration, E2E, and performance testing |
| `secure-code-guardian` | Security vulnerabilities, OWASP, secure patterns |
| `feature-forge` | Requirements gathering → technical spec |

</details>

---

## 💻 VS Code Setup

The script automatically configures VS Code with:

### Extensions Installed (21 total)

| Category | Extensions |
|----------|-----------|
| Core | Prettier, ESLint, GitLens, Error Lens |
| React Native | React Native Tools, Expo Tools |
| Flutter | Dart, Flutter |
| Backend | Path IntelliSense, DotENV, Thunder Client |
| Database | Prisma |
| DevOps | Docker |
| UI | Tailwind CSS IntelliSense |
| Themes | Material Theme, Material Icons |
| Testing | Jest |
| Productivity | Todo Tree, Better Comments |

### Settings Applied

- Format on save (Prettier)
- ESLint auto-fix on save
- TypeScript strict mode
- JetBrains Mono font with ligatures
- Tab size: 2 spaces
- Dark mode ready
- Language-specific formatters (Dart uses its own)

---

## 📁 Repository Structure

```
claude-setup/
├── 📄 README.md                   ← You are here
├── 📄 CONTRIBUTING.md             ← How to add skills or report issues
├── 📄 CHANGELOG.md                ← Version history
├── 📄 RECOMMENDED_SKILLS.md       ← Voted skills roadmap
├── 📄 LICENSE                     ← MIT License
├── 📄 .gitignore
├── 📄 CLAUDE.md                   ← Global Claude coding rules
├── 📄 .cursorrules                ← Cursor AI config
├── 📄 .aider.conf.yml             ← Aider AI config
├── 📄 .windsurfrules              ← Windsurf AI config
├── ⚙️  setup.sh                    ← Main install script (macOS)
├── ⚙️  setup-linux.sh              ← Linux install script (Ubuntu/Debian)
├── ⚙️  setup-windows.ps1           ← Windows install script (Win 10/11, PowerShell)
├── ⚙️  install_skills.sh           ← Interactive skill selector
├── ⚙️  install_hooks.sh            ← Efficiency hooks installer
├── ⚙️  doctor.sh                   ← Health check (like flutter doctor)
├── ⚙️  scaffold.sh                 ← Project scaffolding generator
├── ⚙️  update.sh                   ← Auto-update skills and configs
├── ⚙️  generate-env.sh             ← .env.example generator
├── ⚙️  universal-setup.sh          ← Multi-tool config copier
├── ⚙️  token-tracker.sh            ← Token & cost tracking utility
├── ⚙️  export-for-web.sh          ← Export skills for claude.ai Web & Desktop
├── 📄 WEB_DESKTOP_GUIDE.md        ← Guide for Web & Desktop skill setup
│
├── 🪝 hooks/                      ← Auto-run hooks for efficiency
│   ├── compact-reminder.sh        ← /compact reminder at turns 20/40/60+
│   └── auto-skill.sh              ← Suggest the right skill per file type
│
├── ⚙️  settings/
│   └── efficiency.json            ← Optimal settings template
│
├── 🧠 skills/                     ← 42 Claude Code skills
│   ├── react-native-expo/
│   ├── flutter-dev/
│   ├── nodejs-backend/
│   ├── nextjs-frontend/
│   ├── uiux-design/
│   ├── ui-ux-pro-max/             ← Design intelligence (67 styles, 96 palettes, BM25 search)
│   ├── devops-cicd/
│   ├── upwork-freelancer/
│   ├── fullstack-architecture/
│   ├── supabase-expert/           ← NEW: Supabase (RLS, Edge Functions, Auth)
│   ├── stripe-expert/             ← NEW: Payments (Checkout, Subscriptions, Webhooks)
│   ├── prisma-expert/             ← NEW: ORM (Schema, Queries, Migrations)
│   ├── ai-integration/            ← NEW: LLM integration (RAG, Streaming, Claude API)
│   ├── auth-patterns/             ← NEW: Auth (NextAuth, JWT, RBAC, OAuth)
│   ├── token-tracker/             ← Token & cost tracking skill
│   ├── token-optimizer/           ← Model selection, context mgmt, prompt efficiency
│   ├── technical-writer/          ← README, ADR, runbook, postmortem, changelog
│   ├── cto-advisor/               ← Tech strategy, team scaling, DORA metrics
│   ├── project-manager/           ← Agile, sprint planning, stakeholder reports
│   ├── task-estimator/            ← Story points, epic breakdown, timeline forecasting
│   └── ... (22 more from community)
│
├── 📁 web-prompts/                ← Pre-exported skill prompts (run export-for-web.sh)
│
├── 📁 templates/
│   ├── github-actions/            ← CI/CD pipeline templates
│   │   ├── ci-nextjs.yml
│   │   ├── ci-nestjs.yml
│   │   ├── deploy-vercel.yml
│   │   └── docker-build.yml
│   └── env-examples/              ← .env templates
│
├── 💻 vscode/
│   ├── settings.json              ← VS Code settings
│   ├── keybindings.json           ← Keyboard shortcuts
│   └── extensions.txt             ← Extension list
│
└── 📋 .github/
    ├── workflows/
    │   └── ci.yml                 ← Validates skills on push
    └── ISSUE_TEMPLATE/
        ├── bug_report.md
        └── feature_request.md
```

---

## 🔄 Keeping Up to Date

```bash
# Pull latest skills and tools list
cd claude-setup
git pull origin main

# Re-run setup — only installs what's new/missing
./setup.sh
```

---

## 🤝 Contributing

We welcome new skills, tool updates, and improvements!

See **[CONTRIBUTING.md](CONTRIBUTING.md)** for full guidelines.

**Quick contribution:**
1. Fork this repo
2. Add your skill to `skills/your-skill-name/SKILL.md`
3. Submit a Pull Request

**Skill ideas welcome:**
- `python-pro` improvements
- `stripe-integration` skill
- `supabase` skill
- `prisma-expert` skill
- Windows/Linux support for `setup.sh`

---

## 🛠️ Tech Stack Covered

```
Frontend:   React Native · Flutter · Next.js · React.js · Vue.js · TypeScript · Tailwind CSS
Backend:    Node.js · Python · Django · Laravel · NestJS · Express.js · FastAPI · GraphQL
Databases:  MySQL · MongoDB · PostgreSQL · Pinecone
Cloud:      AWS (Lambda, EC2, S3) · Docker · Kubernetes · Nginx · Firebase
Freelance:  Upwork · LinkedIn · Fiverr · Proposals · Cover Letters · Client Communication
```

---

## 🎯 Interactive Skill Selection

Don't need all 42 skills? Pick only what you want:

```bash
# Interactive menu — choose by category
./install_skills.sh

# Install everything (no prompts)
./install_skills.sh --all

# Install by category
./install_skills.sh --category mobile     # React Native + Flutter
./install_skills.sh --category backend    # Node.js, NestJS, Django, Supabase, Stripe, Prisma, Auth
./install_skills.sh --category frontend   # Next.js, Vue, TypeScript
./install_skills.sh --category devops     # Docker, K8s, AWS, CI/CD
./install_skills.sh --category quality    # Testing, reviews, security
./install_skills.sh --category freelance  # Upwork proposals + cover letters

# Install a single skill
./install_skills.sh --skill proposal-writer  # Just the proposal writer
./install_skills.sh --skill supabase-expert

# Search for skills by keyword
./install_skills.sh --search payment      # Find payment-related skills
./install_skills.sh --search auth         # Find auth-related skills

# Remove a skill
./install_skills.sh --remove flutter-expert

# See what's available
./install_skills.sh --list
```

**Categories available:** mobile, backend, frontend, uiux, devops, architecture, quality, languages, freelance, utilities, management

---

## 📦 Install Any Skill — Any OS

Don't want the full repo? Grab **only the skills you need** with a single command.

### Install a single skill (curl)

Replace `SKILL_NAME` with any skill from the [skills list](#-skills-reference):

**macOS / Linux / WSL / Git Bash:**
```bash
SKILL_NAME="proposal-writer"  # change to any skill name
mkdir -p ~/.claude/skills/$SKILL_NAME
curl -fsSL "https://raw.githubusercontent.com/thesaifalitai/claude-setup/main/skills/$SKILL_NAME/SKILL.md" \
  -o ~/.claude/skills/$SKILL_NAME/SKILL.md
```

**Windows (PowerShell):**
```powershell
$skill = "proposal-writer"  # change to any skill name
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\$skill"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/thesaifalitai/claude-setup/main/skills/$skill/SKILL.md" `
  -OutFile "$env:USERPROFILE\.claude\skills\$skill\SKILL.md"
```

### Install multiple skills at once

**macOS / Linux / WSL:**
```bash
for skill in proposal-writer upwork-freelancer supabase-expert; do
  mkdir -p ~/.claude/skills/$skill
  curl -fsSL "https://raw.githubusercontent.com/thesaifalitai/claude-setup/main/skills/$skill/SKILL.md" \
    -o ~/.claude/skills/$skill/SKILL.md
  echo "installed: $skill"
done
```

**Windows (PowerShell):**
```powershell
foreach ($skill in @("proposal-writer", "upwork-freelancer", "supabase-expert")) {
  New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\$skill"
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/thesaifalitai/claude-setup/main/skills/$skill/SKILL.md" `
    -OutFile "$env:USERPROFILE\.claude\skills\$skill\SKILL.md"
  Write-Host "installed: $skill"
}
```

### Manual install (any OS)
1. Browse [skills/](skills/) folder on GitHub
2. Open the skill folder you want
3. Download `SKILL.md`
4. Place it at `~/.claude/skills/<skill-name>/SKILL.md`

> **No scripts, no dependencies** — each skill is a single `SKILL.md` file that works independently.

### Where skills work

| Platform | How |
|----------|-----|
| **Claude Code (CLI)** | Auto-detected from `~/.claude/skills/` |
| **VS Code extension** | Auto-detected from `~/.claude/skills/` |
| **Claude.ai Web** | Copy skill content into Settings > Custom Instructions |
| **Claude Desktop App** | Copy skill content into Settings > Custom Instructions |

---

## 🩺 Health Check

Verify your entire development environment with a single command — like `flutter doctor` for your whole stack:

```bash
./doctor.sh
```

```
━━━ System ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [✓] macOS 14.2 (arm64)
  [✓] Disk space: 85GB available

━━━ Core Tools ━━━━━━━━━━━━━━━━━━━━━━━━
  [✓] Git 2.43.0
  [✓] GitHub CLI 2.42.0 — authenticated

━━━ Node.js Ecosystem ━━━━━━━━━━━━━━━━━
  [✓] Node.js v20.11.0
  [✓] npm 10.2.4

━━━ Claude Code ━━━━━━━━━━━━━━━━━━━━━━━
  [✓] Claude CLI 1.0.3
  [✓] Claude skills: 36 installed

━━━ Infrastructure ━━━━━━━━━━━━━━━━━━━━
  [✓] Docker 24.0.7 — daemon running
  [✓] PostgreSQL 16.1 — accepting connections
  [✓] Redis 7.2.3 — responding

  Summary: 22 passed  3 warnings  0 failed
```

Checks: OS, disk space, Git, GitHub CLI, Node.js, npm, NVM, Claude CLI, skills, Flutter, Docker, PostgreSQL, Redis, Nginx, AWS CLI, VS Code, and all AI tool configs.

---

## 🏗️ Project Scaffolding

Generate a fully configured project in seconds — all configs, env files, and AI tools pre-wired:

```bash
# Interactive menu
./scaffold.sh

# Direct command
./scaffold.sh nextjs my-saas-app       # Next.js + Tailwind + Prisma + NextAuth
./scaffold.sh nestjs my-api             # NestJS + Prisma + JWT + Swagger
./scaffold.sh expo my-mobile-app        # React Native + Expo Router + NativeWind
./scaffold.sh flutter my_app            # Flutter + Riverpod + GoRouter
./scaffold.sh fullstack my-platform     # Monorepo: Next.js + NestJS + shared types
```

Every scaffolded project includes:
- All AI tool configs (CLAUDE.md, .cursorrules, .aider.conf.yml, .windsurfrules)
- `.env.example` with all required variables
- Git initialized with first commit
- Docker Compose for local services (fullstack)

---

## 🔄 Auto-Update

Keep your skills and configs up to date:

```bash
# Update everything (repo + skills + configs)
./update.sh

# Update skills only
./update.sh --skills

# Update CLAUDE.md only
./update.sh --configs

# Check installed version
./update.sh --version
```

---

## 📋 .env Generator

Generate `.env.example` templates for any stack:

```bash
# Interactive menu
./generate-env.sh

# Direct command
./generate-env.sh nextjs ./my-project    # Next.js env template
./generate-env.sh nestjs ./my-api        # NestJS env template
./generate-env.sh supabase .             # Supabase env template
./generate-env.sh fullstack .            # Fullstack monorepo
./generate-env.sh expo .                 # React Native / Expo
```

---

## 🐧 Linux Support

Full Linux support via `setup-linux.sh` — works on Ubuntu 22.04+, Debian 12+, and derivatives:

```bash
# Linux install
chmod +x setup-linux.sh && ./setup-linux.sh

# Then verify
./doctor.sh
```

Installs the same 19 tools using `apt` instead of Homebrew, with proper systemd service management.

---

## 📦 GitHub Actions Templates

Ready-to-copy CI/CD pipelines in `templates/github-actions/`:

| Template | File | What It Does |
|----------|------|-------------|
| Next.js CI | `ci-nextjs.yml` | Lint, type check, test, build with PostgreSQL |
| NestJS CI | `ci-nestjs.yml` | Lint, test, e2e test with PostgreSQL + Redis |
| Vercel Deploy | `deploy-vercel.yml` | Auto-deploy to Vercel on push to main |
| Docker Build | `docker-build.yml` | Build and push to GitHub Container Registry |

```bash
# Copy a template to your project
cp templates/github-actions/ci-nextjs.yml your-project/.github/workflows/ci.yml
```

---

## 📊 Token & Cost Tracking

Track how many tokens each AI request uses and what it costs — and actively reduce them.

Two complementary skills:

| Skill | Purpose |
|-------|---------|
| `token-tracker` | **Measure** — per-request cost, session totals, budget estimates |
| `token-optimizer` | **Reduce** — model selection, context management, prompt efficiency |

### Install both

```bash
./install_skills.sh --skill token-tracker
./install_skills.sh --skill token-optimizer
```

### Option 1: Claude Skill (Automatic)

```bash
# Tracking — in any Claude Code session:
"Enable token tracking"
"How much did this request cost?"
"Show me a session summary"
"Estimate my monthly cost for heavy use"

# Optimization:
"Which model should I use for this task?"
"My context is almost full — what do I do?"
"How do I write prompts that use fewer tokens?"
"Show me the model selection guide"
```

Claude will append token usage after every response and proactively suggest `/compact` when context gets long.

### Built-in optimization (CLAUDE.md)

The included `CLAUDE.md` encodes token-saving behaviors that are **always active** — no skill needed:
- No preamble or filler phrases
- Code over prose (show the diff, not the explanation)
- Suggest `/compact` after major phases, `/clear` between tasks
- Use subagents for file exploration (keeps main context clean)
- Read files with line ranges, not entire files

### Option 2: Shell Utility (Manual tracking)

```bash
# Load the tracker in your terminal
source token-tracker.sh

# Start tracking
tt_enable

# After each AI interaction, log character counts
tt_log 2000 5000 "code review request"

# See session totals
tt_summary

# Compare costs across providers
tt_compare

# Set your model for accurate pricing
tt_set_model opus    # or: sonnet, haiku

# View past sessions
tt_history
```

**Cost comparison** across providers:
```
💰 Cost Comparison (~1,000 in / ~2,000 out tokens)
  Claude Opus 4:    $0.165000
  Claude Sonnet 4:  $0.033000
  Claude Haiku 3.5: $0.008800
  GPT-4o:           $0.022500
  Gemini 1.5 Pro:   $0.011250
  DeepSeek V3:      $0.002470
```

---

## 🔀 Universal AI Tool Support

This repo works with **all major AI coding tools**, not just Claude Code. One set of coding standards, multiple tools.

```bash
# Copy configs to your project for ALL tools at once
./universal-setup.sh /path/to/your/project

# Or manually copy what you need:
cp CLAUDE.md /your/project/          # Claude Code
cp .cursorrules /your/project/       # Cursor
cp .aider.conf.yml /your/project/    # Aider
cp .windsurfrules /your/project/     # Windsurf
```

| AI Tool | Config File | Status |
|---------|------------|--------|
| **Claude Code** (priority) | `CLAUDE.md` + `~/.claude/skills/` | Full support (skills + config) |
| **claude.ai Web** | Project Instructions | Full support (export-for-web.sh) |
| **Claude Desktop** | Project Instructions | Full support (export-for-web.sh) |
| **Cursor** | `.cursorrules` | Full support (coding standards) |
| **Aider** | `.aider.conf.yml` | Full support (model + settings) |
| **Windsurf** (Codeium) | `.windsurfrules` | Full support (coding standards) |

> Claude Code is our **primary focus** — it gets the full skill system with auto-triggering. Other tools get the shared coding standards. claude.ai Web and Desktop get the full skill knowledge via Project Instructions (see below).

---

## 🌐 Web & Desktop Support

Skills work on **claude.ai** and **Claude Desktop** via Project Instructions. Export any skill (or a combination) as a ready-to-paste system prompt:

```bash
# Interactive picker — select skills by number
./export-for-web.sh

# Export a single skill (auto-copies to clipboard)
./export-for-web.sh --skill flutter-dev

# Export multiple skills into one combined prompt
./export-for-web.sh --skill nextjs-developer --skill uiux-design --skill secure-code-guardian

# Export all skills at once
./export-for-web.sh --all

# See what's available
./export-for-web.sh --list
```

**Then paste into a Project:**

1. **claude.ai** → Projects → ⚙ Settings → **Project Instructions** → paste → Save
2. **Claude Desktop** → Projects → Edit → **Custom Instructions** → paste → Save

Every conversation inside that Project will have the skill expertise active — no manual invocation needed.

**Recommended Projects:**

| Project | Skills |
|---------|--------|
| Mobile Dev | `react-native-expo` + `flutter-dev` |
| Full-Stack Web | `nextjs-developer` + `nextjs-frontend` + `nodejs-backend` |
| UI/UX | `uiux-design` + `ui-ux-pro-max` |
| DevOps | `devops-cicd` + `devops-engineer` |
| Code Quality | `code-reviewer` + `test-master` + `secure-code-guardian` |

> **Note:** The `ui-ux-pro-max` skill uses a Python BM25 search engine that only runs in Claude Code CLI. On Web/Desktop, Claude uses the embedded knowledge instead — design planning still works, just without the live database search.

See [WEB_DESKTOP_GUIDE.md](WEB_DESKTOP_GUIDE.md) for the full setup walkthrough.

---

## ❓ FAQ

**Q: Is it safe to re-run `setup.sh`?**
A: Yes. Every install is guarded by a check. Already-installed items print `⏭ already installed` and are skipped.

**Q: Does this work on Intel Macs?**
A: Yes. The script detects `arm64` vs `x86_64` and adjusts Homebrew paths accordingly.

**Q: Can I use this on Linux / Windows?**
A: Full setup script is macOS + Linux. **Skills work on any OS** (Windows, macOS, Linux) — just copy the skill folder to `~/.claude/skills/`. Windows users can use PowerShell, WSL, or Git Bash (see install instructions above).

**Q: What if a tool fails to install?**
A: The script prints a warning and continues. Failed installs are logged so you can fix them manually.

**Q: Where are the skills stored?**
A: `~/.claude/skills/` — global to your user, active in every Claude Code session.

**Q: Can I use the skills on claude.ai or the Claude Desktop app?**
A: Yes. Run `./export-for-web.sh --skill <name>` to export a skill as a plain system prompt, then paste it into a Project's Instructions on claude.ai or Claude Desktop. See [WEB_DESKTOP_GUIDE.md](WEB_DESKTOP_GUIDE.md).

**Q: How do I add my own skill?**
A: Create `skills/my-skill/SKILL.md`, add a YAML frontmatter with `name` and `description`, then re-run `setup.sh`.

---

## 📜 License

MIT — free to use, modify, and share. See [LICENSE](LICENSE).

---

## 🙏 Credits

Skills sourced from:
- [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) — 66 community skills
- [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) — Claude Code configs
- [callstackincubator/agent-skills](https://github.com/callstackincubator/agent-skills) — React Native patterns
- [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) — Design intelligence skill (67 styles, 96 palettes, BM25 search engine)
- [Anthropic Claude Code Docs](https://docs.claude.ai/claude-code) — Official skill format

---

<div align="center">

**Made for freelancers who want to move fast without breaking things.**

**Works with:** Claude Code · Cursor · Aider · Windsurf

⭐ Star this repo if it saved you setup time!

</div>
