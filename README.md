<div align="center">

# 🚀 Claude Fullstack Freelancer Setup

**One script. Zero duplicates. Every tool your freelance stack needs.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Skills-purple?style=flat-square)](https://claude.ai/claude-code)
[![macOS](https://img.shields.io/badge/macOS-Apple_Silicon_%26_Intel-black?style=flat-square&logo=apple)](setup.sh)
[![Skills](https://img.shields.io/badge/Skills-30_Installed-green?style=flat-square)](#-skills-reference)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](CONTRIBUTING.md)

A complete, automated setup for full-stack freelancers using **Claude Code**.
Installs every tool, framework, and AI skill you need — skips what you already have.

[Quick Start](#-quick-start) · [Skills List](#-skills-reference) · [What Gets Installed](#-what-gets-installed) · [VS Code Setup](#-vs-code-setup) · [Contributing](CONTRIBUTING.md)

</div>

---

## ✨ Why This Repo?

Setting up a new Mac for full-stack freelance work takes hours — installing Flutter, Node, Docker, configuring VS Code, setting up Claude skills. This repo automates **everything** in one script:

- ✅ **Smart install** — checks before installing, never duplicates
- ✅ **Safe to re-run** — run anytime to add new tools or catch missing ones
- ✅ **30 Claude AI skills** — auto-trigger the right expert for every task
- ✅ **VS Code fully configured** — settings, keybindings, 21 extensions
- ✅ **Freelancer-ready** — Upwork proposals, client replies, project scoping built in

---

## 🏃 Quick Start

> **Requires:** macOS (Apple Silicon or Intel) · Internet connection · ~15 min

```bash
# Clone the repo
git clone https://github.com/thesaifalitai/claude-setup.git
cd claude-setup

# Make executable and run
chmod +x setup.sh
./setup.sh
```

That's it. The script handles everything else — including skipping tools you already have.

### One-line install (no clone needed)

```bash
curl -fsSL https://raw.githubusercontent.com/thesaifalitai/claude-setup/main/setup.sh | bash
```

> ⚠️ The one-liner won't copy skills locally. Use the `git clone` method to get all 30 skills installed.

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
├── 📄 LICENSE                     ← MIT License
├── 📄 .gitignore
├── 📄 CLAUDE.md                   ← Global Claude coding rules
├── ⚙️  setup.sh                    ← Main auto-install script
│
├── 🧠 skills/                     ← 30 Claude Code skills
│   ├── react-native-expo/
│   │   └── SKILL.md
│   ├── flutter-dev/
│   │   └── SKILL.md
│   ├── nodejs-backend/
│   │   └── SKILL.md
│   ├── nextjs-frontend/
│   │   └── SKILL.md
│   ├── uiux-design/
│   │   └── SKILL.md
│   ├── devops-cicd/
│   │   └── SKILL.md
│   ├── upwork-freelancer/
│   │   └── SKILL.md
│   ├── fullstack-architecture/
│   │   └── SKILL.md
│   └── ... (22 more from community)
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
Freelance:  Upwork · Project Management · Client Communication
```

---

## ❓ FAQ

**Q: Is it safe to re-run `setup.sh`?**
A: Yes. Every install is guarded by a check. Already-installed items print `⏭ already installed` and are skipped.

**Q: Does this work on Intel Macs?**
A: Yes. The script detects `arm64` vs `x86_64` and adjusts Homebrew paths accordingly.

**Q: Can I use this on Linux / Windows?**
A: Currently macOS only. Linux support is planned — PRs welcome!

**Q: What if a tool fails to install?**
A: The script prints a warning and continues. Failed installs are logged so you can fix them manually.

**Q: Where are the skills stored?**
A: `~/.claude/skills/` — global to your user, active in every Claude Code session.

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
- [Anthropic Claude Code Docs](https://docs.claude.ai/claude-code) — Official skill format

---

<div align="center">

**Made for freelancers who want to move fast without breaking things.**

⭐ Star this repo if it saved you setup time!

</div>
