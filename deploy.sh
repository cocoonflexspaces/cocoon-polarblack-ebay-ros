#!/usr/bin/env bash
# Cocoon × Polar Black — eBay Activation, Casa Panorama — Combined ROS
# Deploy to GitHub Pages
# Run from this folder: bash deploy.sh

set -e

REPO_NAME="cocoon-polarblack-ebay-ros"
ORG="cocoonflexspaces"

cd "$(dirname "$0")"

if ! command -v gh >/dev/null 2>&1; then
  echo "✗ gh CLI not installed."
  echo "  Install:  brew install gh"
  echo "  Then:     gh auth login   (pick 'Login with a web browser')"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "✗ gh CLI is not authenticated."
  echo "  Run:  gh auth login"
  exit 1
fi

if [ ! -d .git ]; then
  echo "→ Initialising git..."
  git init -q
  git checkout -b main -q 2>/dev/null || git checkout main -q
fi

echo "→ Staging files..."
git add -A
if ! git diff --cached --quiet; then
  git commit -q -m "eBay × Polar Black — Combined Run of Show, Casa Panorama"
fi

if gh repo view "${ORG}/${REPO_NAME}" >/dev/null 2>&1; then
  echo "→ Repo ${ORG}/${REPO_NAME} already exists — pushing to it."
  if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "https://github.com/${ORG}/${REPO_NAME}.git"
  fi
  git push -u origin main -q
else
  echo "→ Creating GitHub repo ${ORG}/${REPO_NAME}..."
  gh repo create "${ORG}/${REPO_NAME}" \
    --public \
    --source=. \
    --remote=origin \
    --push \
    --description "Run of Show — eBay Brand Activation × Polar Black Events, Casa Panorama"
fi

echo "→ Enabling GitHub Pages (main branch / root)..."
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/${ORG}/${REPO_NAME}/pages" \
  -f source='{"branch":"main","path":"/"}' >/dev/null 2>&1 || true

echo ""
echo "✓ Done! Live in ~60 seconds at:"
echo "  https://${ORG}.github.io/${REPO_NAME}/"
