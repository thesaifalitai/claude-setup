#!/usr/bin/env bash
# Run this once on your Mac to set up your local GitHub folder
# Then use it anytime to push updates

GITHUB_DIR="$HOME/Documents/GitHub"
REPO_NAME="claude-setup"
REMOTE="https://github.com/thesaifalitai/claude-setup.git"

mkdir -p "$GITHUB_DIR"

if [ -d "$GITHUB_DIR/$REPO_NAME/.git" ]; then
  echo "📦 Repo already exists locally — pulling latest..."
  cd "$GITHUB_DIR/$REPO_NAME"
  git pull origin main
  echo "✅ Up to date!"
else
  echo "📥 Cloning repo to $GITHUB_DIR/$REPO_NAME ..."
  git clone "$REMOTE" "$GITHUB_DIR/$REPO_NAME"
  echo "✅ Cloned! Repo is at: $GITHUB_DIR/$REPO_NAME"
fi

echo ""
echo "To push an update later:"
echo "  cd $GITHUB_DIR/$REPO_NAME"
echo "  git add ."
echo "  git commit -m 'your message'"
echo "  git push"
