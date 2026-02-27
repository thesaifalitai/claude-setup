# How to Push to GitHub (Step by Step)

---

## STEP 1 — Create the Repo on GitHub

1. Open this link in your browser:
   👉 https://github.com/new

2. Fill in exactly this:
   - **Repository name:** `claude-setup`
   - **Description:** `🚀 Auto-setup for full-stack freelancers — 30 Claude AI skills, React Native, Flutter, Node.js, Next.js, Docker, VS Code configured in one script`
   - **Visibility:** ✅ Public
   - ❌ Do NOT check "Add README" (we already have one)
   - ❌ Do NOT check "Add .gitignore"
   - ❌ Do NOT check "Choose license"

3. Click **"Create repository"**

4. GitHub will show you an empty repo page — keep it open.

---

## STEP 2 — Open Terminal on Your Mac

Press `Cmd + Space`, type **Terminal**, press Enter.

---

## STEP 3 — Go to Your Setup Folder

The folder is in your Cowork outputs. Run:

```bash
cd ~/Downloads/claude-setup
```

> If it's not there, open Finder → look for the `claude-setup` folder → right-click it → "New Terminal at Folder"

---

## STEP 4 — Run These Commands (copy-paste all at once)

```bash
git init
git add .
git commit -m "feat: initial release v1.0.0 — 30 Claude skills, auto-install setup for full-stack freelancers"
git branch -M main
git remote add origin https://github.com/thesaifalitai/claude-setup.git
git push -u origin main
```

> GitHub will ask for your **username** and **password**.
> ⚠️  Use a **Personal Access Token** as the password (not your GitHub password).
> Get one here: https://github.com/settings/tokens/new
> → Select scope: `repo` → Generate → copy and paste as password.

---

## STEP 5 — Make It Look Good

After pushing, go to your repo page:
https://github.com/thesaifalitai/claude-setup

1. Click the **⚙️ gear icon** next to "About" (top right of repo)
2. Add **topics** (tags):
   ```
   claude-code  react-native  flutter  nodejs  nextjs  upwork  freelancer  ai-skills  macos-setup
   ```
3. Add **website** (optional): your portfolio URL

---

## STEP 6 — Share With Anyone

Anyone can now install everything with one command:

```bash
git clone https://github.com/thesaifalitai/claude-setup.git && cd claude-setup && ./setup.sh
```

---

## How to Update Later (when you add new skills)

```bash
cd ~/Downloads/claude-setup
git add .
git commit -m "feat(skill): add new-skill-name"
git push
```

Users re-run `./setup.sh` to get the update — it only installs what's new.
