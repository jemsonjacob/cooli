#!/usr/bin/env bash
set -Eeuo pipefail

# ------------------------------------------------------------------------------
# INPUT PARAMETERS
# ------------------------------------------------------------------------------
PROJECT_NAME="${2:-}"
APP_NAME="${3:-}"
BUNDLE_ID="${4:-}"
WIDTH="${5:-}"
HEIGHT="${6:-}"
REPO_URL_INPUT="${9:-}"

# GitHub Secrets (from Actions env)
GITHUB_USERNAME="${USER_NAME:-}"
GITHUB_TOKEN="${TOKEN:-}"

# ------------------------------------------------------------------------------
# LOG
# ------------------------------------------------------------------------------
log() { echo "👉 $*"; }
ok()  { echo "✅ $*"; }
err() { echo "❌ $*"; }

trap 'err "Error at line $LINENO → $BASH_COMMAND"' ERR

# ------------------------------------------------------------------------------
# VALIDATION
# ------------------------------------------------------------------------------
if [[ -z "$PROJECT_NAME" || -z "$APP_NAME" || -z "$BUNDLE_ID" ]]; then
  err "Missing required arguments"
  exit 1
fi

if [[ -z "$GITHUB_USERNAME" || -z "$GITHUB_TOKEN" ]]; then
  err "Missing GitHub credentials (USER_NAME / TOKEN)"
  exit 1
fi

# ------------------------------------------------------------------------------
# WORKSPACE
# ------------------------------------------------------------------------------
WORK_DIR="${RUNNER_TEMP:-/tmp}/temp_${PROJECT_NAME}"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

log "Copying template..."
cp -r . "$WORK_DIR/"
cd "$WORK_DIR"
rm -rf .git

# ------------------------------------------------------------------------------
# REPLACE FUNCTION
# ------------------------------------------------------------------------------
replace_all() {
  local search="$1"
  local replace="$2"

  grep -rl "$search" . | while read -r file; do
    if file "$file" | grep -q text; then
      sed -i.bak "s|$search|$replace|g" "$file" || true
      rm -f "${file}.bak"
    fi
  done
}

# ------------------------------------------------------------------------------
# TEMPLATE
# ------------------------------------------------------------------------------
log "Applying template..."

if [[ -f pubspec.yaml ]]; then
  sed -i.bak "s/^name:.*/name: ${PROJECT_NAME}/" pubspec.yaml || true
  rm -f pubspec.yaml.bak
fi

replace_all "PROJECT_NAME_PLACEHOLDER" "$PROJECT_NAME"
replace_all "APP_NAME_PLACEHOLDER" "$APP_NAME"
replace_all "BUNDLE_ID_PLACEHOLDER" "$BUNDLE_ID"
replace_all "WIDTH_PLACEHOLDER" "$WIDTH"
replace_all "HEIGHT_PLACEHOLDER" "$HEIGHT"

replace_all "com.example.base_project" "$BUNDLE_ID"
replace_all "Base Project" "$APP_NAME"

# ------------------------------------------------------------------------------
# ANDROID PACKAGE FIX
# ------------------------------------------------------------------------------
log "Fixing Android package..."

BASE="android/app/src/main/kotlin"

if [[ -d "$BASE" ]]; then
  OLD_DIR=$(find "$BASE" -type d -mindepth 3 | head -n 1 || true)
  NEW_DIR="$BASE/$(echo "$BUNDLE_ID" | tr '.' '/')"

  if [[ -n "$OLD_DIR" ]]; then
    mkdir -p "$NEW_DIR"
    mv "$OLD_DIR"/* "$NEW_DIR/" || true
    rm -rf "$BASE/com" || true
  fi

  find "$BASE" -name "*.kt" | while read -r file; do
    sed -i.bak "s|package .*|package ${BUNDLE_ID}|g" "$file"
    rm -f "${file}.bak"
  done
fi

# ------------------------------------------------------------------------------
# REPO LOGIC (GitHub only)
# ------------------------------------------------------------------------------
if [[ -n "$REPO_URL_INPUT" ]]; then
  log "Using existing repo → $REPO_URL_INPUT"

  REPO_URL=$(echo "$REPO_URL_INPUT" | sed "s|https://|https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@|")

else
  log "Creating new GitHub repo..."

  curl -s -X POST https://api.github.com/user/repos \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -d "{\"name\":\"${PROJECT_NAME}\",\"private\":true}" > /dev/null

  REPO_URL="https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${PROJECT_NAME}.git"
fi

# ------------------------------------------------------------------------------
# GIT PUSH
# ------------------------------------------------------------------------------
log "Pushing project..."

git init
git config user.name "automation-bot"
git config user.email "bot@automation.com"

git add .
git commit -m "Initial commit: ${PROJECT_NAME}"
git branch -M main

git remote add origin "$REPO_URL"

echo "DEBUG → $REPO_URL"

git push -u origin main --force

ok "🎉 DONE → $REPO_URL"