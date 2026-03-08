# Using Skills on claude.ai Web & Claude Desktop

Claude Code skills auto-trigger inside the CLI. On **claude.ai** and **Claude Desktop** there is no CLI hook system — but you can get identical expertise by pasting a skill as a **Project Instructions** system prompt. This guide shows exactly how.

---

## How Skills Work on Each Platform

| Feature | Claude Code CLI | claude.ai Web | Claude Desktop |
|---------|---------------|--------------|----------------|
| Auto-trigger by keyword | ✅ | ❌ | ❌ |
| Project Instructions (system prompt) | ✅ | ✅ | ✅ |
| Persistent across conversations | ✅ `~/.claude/skills/` | ✅ via Project | ✅ via Project |
| Python-powered skills (ui-ux-pro-max) | ✅ | ❌ | ❌ |
| Multi-skill loading | ✅ | ✅ (paste multiple) | ✅ (paste multiple) |

**Bottom line:** Paste the skill content into a Project's Instructions and Claude will behave as that expert for every conversation inside that Project — no manual invocation needed.

---

## Step 1 — Export a Skill

Run the export script from the repo directory:

```bash
# Interactive menu — pick skills by number
./export-for-web.sh

# Export a specific skill
./export-for-web.sh --skill flutter-dev

# Export multiple skills into one combined prompt
./export-for-web.sh --skill nextjs-developer --skill uiux-design --skill secure-code-guardian

# Export all skills (large — best split by domain)
./export-for-web.sh --all --output ~/Desktop/all-skills.md

# List all available skills
./export-for-web.sh --list
```

The script:
- Strips the YAML frontmatter (not needed on web/desktop)
- Saves the file to `web-prompts/<skill-name>.md`
- Automatically copies to clipboard (macOS / Linux with xclip/xsel)

Pre-exported prompts for all skills are already in the `web-prompts/` directory after you run `./export-for-web.sh --all`.

---

## Step 2 — Set Up a Project on claude.ai

1. Go to [claude.ai](https://claude.ai)
2. Click **Projects** in the left sidebar
3. Click **New Project** (or open an existing one)
4. Click the **⚙ Settings** icon (top right of the project)
5. Find **"Project Instructions"** (or "Custom Instructions")
6. Paste the exported skill content
7. Click **Save**

Every new conversation inside that Project will now have the skill active.

**Recommended project layout:**

| Project Name | Skills to include |
|-------------|------------------|
| Mobile Dev | `react-native-expo` + `flutter-dev` |
| Full-Stack Web | `nextjs-developer` + `nextjs-frontend` + `nodejs-backend` |
| UI/UX Work | `uiux-design` + `ui-ux-pro-max` |
| DevOps | `devops-cicd` + `devops-engineer` |
| Code Quality | `code-reviewer` + `test-master` + `secure-code-guardian` |
| Freelance | `upwork-freelancer` |
| All-in-one | Combine any set with `./export-for-web.sh --skill a --skill b` |

---

## Step 3 — Set Up a Project on Claude Desktop

Claude Desktop syncs Projects with your claude.ai account:

1. Open Claude Desktop
2. Click **Projects** in the sidebar (or Cmd+Shift+P / Ctrl+Shift+P)
3. Select or create a Project
4. Click **Edit** (pencil icon) next to the project name
5. Paste the exported skill content in the **"Custom Instructions"** field
6. Press **Enter** / click **Save**

Changes sync automatically with claude.ai — set up once, works on both.

---

## Step 4 — Using Skills in a New Chat (no Project)

If you do not want to use Projects, paste the skill content at the start of a new conversation:

```
[paste skill content here]

---

Now: [your question]
```

Claude will apply the skill expertise for the rest of the conversation.

---

## Platform-Specific Notes

### claude.ai Web

- **Project Instructions limit:** ~6,000 tokens per project. For a single skill this is plenty; for combined prompts, prioritise the most-used sections.
- **Syncs to Desktop:** Any Project you create on the web is available in the Desktop app.
- **Shared Projects:** Teams can share a Project — everyone gets the same skill expertise.

### Claude Desktop

- Requires a claude.ai account (Pro or Team plan for Projects)
- Download: [claude.ai/download](https://claude.ai/download)
- Projects sync automatically when online
- Works offline with the last-synced instructions

### Skill Limitations on Web/Desktop

| Skill | CLI | Web/Desktop | Notes |
|-------|-----|------------|-------|
| `ui-ux-pro-max` | ✅ Full (BM25 search engine) | ⚠️ Partial | Python scripts can't run; Claude uses embedded knowledge instead |
| All other skills | ✅ | ✅ | No difference — pure prompt-based knowledge |

---

## Quick Reference

```bash
# 1. Export and copy to clipboard
./export-for-web.sh --skill flutter-dev
# → web-prompts/flutter-dev.md (auto-copied to clipboard)

# 2. On claude.ai: Projects → ⚙ Settings → Project Instructions → Cmd+V → Save

# 3. Start any conversation in that project — skill is active
```

---

## Generating All Web Prompts at Once

```bash
# Generates web-prompts/<skill>.md for every skill
./export-for-web.sh --all
```

This creates the `web-prompts/` directory with one ready-to-paste `.md` file per skill, pre-stripped of YAML frontmatter and formatted for Project Instructions.
