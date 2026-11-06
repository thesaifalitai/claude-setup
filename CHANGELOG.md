# Changelog

All notable changes to this project will be documented here.

Format: [Semantic Versioning](https://semver.org/) — `MAJOR.MINOR.PATCH`

---

## [Unreleased] - 2026-11-06

### Changed
- Skill count corrected to 41 everywhere (README badge, feature list, install note, repo tree, skills index)
- Skills index now lists all 41 skills with their source
- CI counts skill directories only, so `skills/README.md` no longer inflates the total

### Added
- `metadata.author` and `license` frontmatter on the 14 skills that were missing them
- Skill Authorship table in the README: 19 original, 22 adapted
- `THIRD_PARTY_NOTICES.md` with upstream MIT license texts

### Fixed
- Company name in `LICENSE`

### Removed
- `GITHUB_PUSH.md` and `INSTALL_STATUS.md` (one-off setup notes)

---

## [1.0.0] — 2026-02-27

### 🎉 Initial Release

#### Added
- `setup.sh` — fully automated macOS install script (Apple Silicon + Intel)
- Smart install detection — skips already-installed tools, never duplicates
- 19 tools installed: Homebrew, Node.js (NVM), Claude CLI, TypeScript, tsx, NestJS CLI, EAS CLI, Expo CLI, Flutter, Docker, PostgreSQL 16, Redis, Nginx, AWS CLI, VS Code, Git, GitHub CLI, jq, wget
- 30 Claude Code skills installed to `~/.claude/skills/`
- VS Code settings, keybindings, and 21 extensions auto-configured
- Global `CLAUDE.md` with coding standards and freelance context

#### Skills Included (30 total)

**Custom Built (8):**
- `react-native-expo` — Expo Router, EAS Build, Reanimated 3, FlashList
- `flutter-dev` — Riverpod 2, GoRouter, Freezed, Dio, Material 3
- `nodejs-backend` — NestJS, Prisma, JWT, Redis, BullMQ
- `nextjs-frontend` — App Router, React Query, shadcn/ui, SEO
- `uiux-design` — Tailwind, CVA, Framer Motion, WCAG accessibility
- `devops-cicd` — Docker, Nginx, GitHub Actions, AWS, zero-downtime deploy
- `upwork-freelancer` — Proposals, client replies, scoping, rate negotiation
- `fullstack-architecture` — Monorepo, Stripe, S3, WebSockets, multi-tenant

**Community (22, from Jeffallan/claude-skills):**
- `react-native-expert`, `flutter-expert`, `nestjs-expert`, `nextjs-developer`
- `devops-engineer`, `django-expert`, `fastapi-expert`, `graphql-architect`
- `typescript-pro`, `python-pro`, `laravel-specialist`, `vue-expert`
- `api-designer`, `microservices-architect`, `secure-code-guardian`
- `test-master`, `kubernetes-specialist`, `cloud-architect`
- `debugging-wizard`, `code-reviewer`, `feature-forge`, `python-pro`

---

## [1.1.0] — 2026-02-28

### Added
- **Interactive Skill Selector** — `install_skills.sh` now shows a menu to pick skills by category or individually
  - `--all` flag for headless install of everything
  - `--category <name>` to install by category (mobile, backend, frontend, devops, etc.)
  - `--skill <name>` to install a single skill
  - `--list` to see all available skills and their install status
- **Token & Cost Tracking** — new `token-tracker` skill + `token-tracker.sh` shell utility
  - Per-request token estimation (input/output)
  - Cost calculation for Claude Opus/Sonnet/Haiku
  - Cross-provider cost comparison (GPT-4o, Gemini, DeepSeek)
  - Session summaries with cumulative stats
  - Usage history logging to `~/.claude/usage-logs/`
- **Universal AI Tool Support** — configs for multiple AI coding tools
  - `.cursorrules` — Cursor IDE support
  - `.aider.conf.yml` — Aider CLI support
  - `.windsurfrules` — Windsurf (Codeium) support
  - `universal-setup.sh` — interactive script to copy configs to any project
- **Recommended Skills Roadmap** — `RECOMMENDED_SKILLS.md` with community-voted skill priorities
  - Top 5: Supabase, Stripe, Prisma, AI Integration, Auth Patterns
  - Medium priority: Tailwind, React Query, Testing, Database Design, Monorepo
  - Community voting via GitHub Issues

### Changed
- `install_skills.sh` rewritten from flat installer to interactive category-based selector
- README updated with new sections: Skill Selection, Token Tracking, Universal AI Support
- Total skills: 30 → 31 (added `token-tracker`)

---

## [1.2.0] — 2026-03-03

### Added

**Tier 1 — Major Features:**
- **Health Check (`doctor.sh`)** — Verify your entire dev environment like `flutter doctor`
  - Checks 20+ tools: OS, Git, Node.js, Claude CLI, Docker, PostgreSQL, Redis, etc.
  - Pass/warning/fail summary with fix hints for every issue
  - Works on both macOS and Linux
- **Top 5 Expert Skills** — Most requested skills implemented:
  - `supabase-expert` — RLS, Edge Functions, Realtime, Storage, migrations
  - `stripe-expert` — Checkout, subscriptions, webhooks, Connect, billing portal
  - `prisma-expert` — Schema design, queries, migrations, seeding, connection pooling
  - `ai-integration` — Claude/OpenAI API, RAG, embeddings, Vercel AI SDK, streaming
  - `auth-patterns` — NextAuth v5, JWT, RBAC, OAuth, MFA, password security
- **Project Scaffolding (`scaffold.sh`)** — Generate ready-to-go projects:
  - `nextjs` — Next.js + Tailwind + Prisma + NextAuth
  - `nestjs` — NestJS + Prisma + JWT + Swagger
  - `expo` — React Native + Expo Router + NativeWind
  - `flutter` — Flutter + Riverpod + GoRouter + Freezed
  - `fullstack` — Monorepo: Next.js + NestJS + shared types + Docker Compose
  - All projects include AI configs and `.env.example`
- **Linux Support (`setup-linux.sh`)** — Full Ubuntu/Debian/derivatives support
  - Same 19 tools via `apt` instead of Homebrew
  - Proper systemd service management
  - Docker, NVM, Flutter via snap

**Tier 2 — Developer Experience:**
- **Auto-Update (`update.sh`)** — Keep skills and configs current
  - `--skills` — update skills only (with checksum comparison)
  - `--configs` — update CLAUDE.md only
  - `--repo` — pull latest from GitHub
  - Automatic backup of existing configs before updating
- **Skill Search** — `install_skills.sh --search <keyword>`
  - Searches skill names and descriptions (YAML frontmatter + content)
  - Shows install status for each result
- **Skill Remove** — `install_skills.sh --remove <name>`
- **.env Generator (`generate-env.sh`)** — Generate env templates:
  - Templates: nextjs, nestjs, expo, supabase, fullstack
  - Includes all common variables with helpful comments
- **GitHub Actions Templates** — Ready-to-copy CI/CD pipelines:
  - `ci-nextjs.yml` — Lint, test, build with PostgreSQL
  - `ci-nestjs.yml` — Unit + e2e tests with PostgreSQL + Redis
  - `deploy-vercel.yml` — Auto-deploy to Vercel
  - `docker-build.yml` — Build and push to GHCR

### Changed
- Total skills: 31 → 36 (+5 expert skills)
- `install_skills.sh` now supports `--search` and `--remove` flags
- README expanded with 7 new documentation sections
- Added Linux badge to project header

---

## [Unreleased]

### Planned
- Windows WSL2 support
- `react-query-expert` skill
- `tailwind-expert` skill
- `testing-patterns` skill
- `database-design` skill
- `monorepo-expert` skill
- Skill dependency resolution (auto-install related skills)

---

[1.0.0]: https://github.com/thesaifalitai/claude-setup/releases/tag/v1.0.0
