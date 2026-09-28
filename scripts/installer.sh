#!/usr/bin/env bash
set -Eeuo pipefail

# ------------------------------------------------------------------------------
# INPUTS (passed from GitHub Actions)
# ------------------------------------------------------------------------------
BASE_REPO="$1"
PROJECT_NAME="$2"
APP_NAME="$3"
BUNDLE_ID="$4"
TARGET_REPO="$5"   # format: username/repo
FVM_VERSION="$6"

GH_TOKEN="${GH_TOKEN:-}"

# ------------------------------------------------------------------------------
# LOG HELPERS
# ------------------------------------------------------------------------------
log() { echo "👉 $*"; }
ok()  { echo "✅ $*"; }
warn(){ echo "⚠️ $*"; }
err() { echo "❌ $*"; }

trap 'err "Error at line $LINENO → $BASH_COMMAND"' ERR

# ------------------------------------------------------------------------------
# VALIDATION
# ------------------------------------------------------------------------------
validate_project_name() {
  [[ "$1" =~ ^[a-z][a-z0-9_]*$ ]] || {
    err "Invalid project name (use snake_case)"
    exit 1
  }
}

# ------------------------------------------------------------------------------
# REPLACE HELPER (cross-platform safe)
# ------------------------------------------------------------------------------
replace_all() {
  local search="$1"
  local replace="$2"

  grep -rl "$search" . | while read -r file; do
    sed -i.bak "s|$search|$replace|g" "$file" || true
    rm -f "${file}.bak"
  done
}

# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------
main() {
  echo "🚀 Bootstrap started"
  echo "Project: $PROJECT_NAME"

  validate_project_name "$PROJECT_NAME"

  WORK_DIR="$(pwd)/temp_${PROJECT_NAME}"
  rm -rf "$WORK_DIR"

  # ------------------------------------------------------------------------------
  # STEP 1: CLONE BASE TEMPLATE
  # ------------------------------------------------------------------------------
  log "Cloning base repo..."
  git clone --depth=1 "$BASE_REPO" "$WORK_DIR"
  cd "$WORK_DIR"
  ok "Cloned"

  # ------------------------------------------------------------------------------
  # STEP 2: RESET GIT
  # ------------------------------------------------------------------------------
  log "Resetting git..."
  rm -rf .git

  # ------------------------------------------------------------------------------
  # STEP 3: RENAME PROJECT
  # ------------------------------------------------------------------------------
  log "Updating project..."

  # pubspec (Flutter)
  if [[ -f pubspec.yaml ]]; then
    sed -i.bak "s/^name:.*/name: ${PROJECT_NAME}/" pubspec.yaml || true
    rm -f pubspec.yaml.bak
    ok "Updated pubspec.yaml"
  fi

  # replace placeholders (you should define these in your template)
  replace_all "APP_NAME_PLACEHOLDER" "$APP_NAME"
  replace_all "BUNDLE_ID_PLACEHOLDER" "$BUNDLE_ID"
  replace_all "PROJECT_NAME_PLACEHOLDER" "$PROJECT_NAME"

  ok "Replaced placeholders"

  # ------------------------------------------------------------------------------
  # STEP 4: FVM SETUP (optional)
  # ------------------------------------------------------------------------------
  log "Setting Flutter version..."

  if command -v fvm &>/dev/null; then
    fvm install "$FVM_VERSION" || warn "FVM install failed"
    fvm use "$FVM_VERSION" --force || warn "FVM use failed"
    ok "FVM configured"
  else
    warn "FVM not installed → skipping"
  fi

  # ------------------------------------------------------------------------------
  # STEP 5: INIT + PUSH
  # ------------------------------------------------------------------------------
  log "Pushing to GitHub..."

  git init
  git add .
  git commit -m "Initial commit (${PROJECT_NAME})"
  git branch -M main

  git remote add origin "https://${GH_TOKEN}@github.com/${TARGET_REPO}.git"

  git push -u origin main || {
    err "Push failed (check repo + token)"
    exit 1
  }

  ok "🎉 Project created successfully!"
}

main "$@"