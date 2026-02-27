# Contributing to Claude Fullstack Freelancer Setup

Thank you for helping make this better for the freelance community! 🙌

---

## Ways to Contribute

- 🧠 **Add a new skill** — The most impactful contribution
- 🐛 **Fix a bug** — Script errors, wrong paths, broken installs
- 📝 **Improve docs** — Clarify instructions, add examples
- 🖥️ **Add Linux/Windows support** — Port `setup.sh` to other OSes
- 💡 **Suggest ideas** — Open an issue with your idea

---

## Adding a New Skill

### 1. Understand the Skill Format

Every skill is a folder with a single `SKILL.md` file:

```
skills/
└── your-skill-name/
    └── SKILL.md
```

### 2. SKILL.md Structure

```markdown
---
name: your-skill-name
description: >
  One paragraph that explains WHAT the skill does AND WHEN to trigger it.
  Be specific about trigger phrases. Make it slightly "pushy" — Claude
  should use it whenever relevant, not just when explicitly asked.
  Include phrases like: "ALWAYS trigger for ANY task involving X, Y, Z".
  Also triggers for: "casual phrase 1", "casual phrase 2".
---

# Skill Title

You are a [role] specializing in [domain].

## Section 1: Core Concepts
...

## Section 2: Code Examples
...

## Section 3: Checklist
- [ ] Item 1
- [ ] Item 2
```

### 3. Skill Writing Rules

| Rule | Detail |
|------|--------|
| **Description triggers Claude** | The `description` field is the #1 thing Claude reads to decide when to use your skill. Make it detailed and include natural language phrases users might type. |
| **Be imperative** | Write "Do X" not "You could do X" |
| **Include code** | Real, runnable code examples > prose |
| **Include a checklist** | End with a quality checklist Claude can verify against |
| **Keep it under 400 lines** | If longer, split into `references/` sub-files |
| **No secrets** | Never hardcode API keys, tokens, or passwords |

### 4. Test Your Skill

Before submitting, test it locally:

```bash
# Copy your skill to ~/.claude/skills/
cp -r skills/your-skill-name ~/.claude/skills/

# Open Claude Code and trigger it
claude
> "Write a [your skill topic] example"
```

Verify:
- [ ] Skill triggers on expected phrases
- [ ] Code examples are correct and runnable
- [ ] No typos or broken markdown
- [ ] Frontmatter YAML is valid

### 5. Submit a Pull Request

```bash
# Fork and clone
git clone https://github.com/thesaifalitai/claude-setup.git
cd claude-setup

# Create a branch
git checkout -b skill/your-skill-name

# Add your skill
mkdir -p skills/your-skill-name
# ... write your SKILL.md

# Commit
git add skills/your-skill-name/SKILL.md
git commit -m "feat(skill): add your-skill-name skill"

# Push and open PR
git push origin skill/your-skill-name
```

**PR title format:** `feat(skill): add <skill-name>`

**PR description should include:**
- What the skill does
- Example trigger phrases
- Any tools/frameworks it covers
- Where you sourced any reference content

---

## Improving setup.sh

If you're adding a new tool to the install script:

1. Always wrap installs in a check:
```bash
if command -v mytool &>/dev/null; then
  skip "MyTool ($(mytool --version 2>/dev/null | head -1))"
else
  install_brew_formula "my-formula" "MyTool"
fi
```

2. Use the helper functions: `install_brew_formula`, `install_brew_cask`, `install_npm_global`
3. Test the script with `bash -n setup.sh` (syntax check) before submitting
4. Test on a clean machine or a VM if possible

---

## Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(skill): add stripe-integration skill
fix(setup): correct nvm path on Apple Silicon
docs(readme): add FAQ for Linux users
chore: update extensions list
```

| Prefix | When to use |
|--------|------------|
| `feat` | New skill or new install step |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `chore` | Maintenance (versions, formatting) |
| `refactor` | Code restructure, no behavior change |

---

## Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md).

Please include:
- macOS version (`sw_vers`)
- Chip type (Apple Silicon / Intel)
- Full error output
- What you expected vs what happened

---

## Code of Conduct

- Be respectful and constructive
- No spam, self-promotion, or off-topic issues
- Keep discussions focused on improving the repo

---

Thank you for contributing! 🚀
