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

## [Unreleased]

### Planned
- Linux (Ubuntu/Debian) support for `setup.sh`
- Windows WSL2 support
- `supabase-expert` skill
- `stripe-expert` skill
- `prisma-expert` skill
- `ai-integration` skill
- `react-query-expert` skill
- Auto-update command (`./setup.sh --update`)

---

[1.0.0]: https://github.com/thesaifalitai/claude-setup/releases/tag/v1.0.0
