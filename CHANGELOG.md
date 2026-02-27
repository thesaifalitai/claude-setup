# Changelog

All notable changes to this project will be documented here.

Format: [Semantic Versioning](https://semver.org/) — `MAJOR.MINOR.PATCH`

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

## [Unreleased]

### Planned
- Linux (Ubuntu/Debian) support for `setup.sh`
- Windows WSL2 support
- `supabase` skill
- `stripe-expert` skill
- `prisma-expert` skill
- `react-query-expert` skill
- Auto-update command (`./setup.sh --update`)

---

[1.0.0]: https://github.com/thesaifalitai/claude-setup/releases/tag/v1.0.0
