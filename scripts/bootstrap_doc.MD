# Flutter Project Setup Script — Complete Documentation

## What Is This Script?

This is a **Bash automation script** that takes a Flutter project template and:

1. Copies and customises it with your app name, bundle ID, and screen size
2. Fixes the Android package folder structure automatically
3. Creates a new **private GitHub repository** (or pushes into an existing one)
4. Commits and pushes all the code in one shot

Think of it as a **one-command project launcher** — instead of manually renaming files, fixing package names, and wiring up a repo, this script does it all for you.

---

## Prerequisites

| Tool | Why It's Needed |
|------|----------------|
| Bash (Linux/macOS or GitHub Actions runner) | To execute the script |
| `git` installed | To commit and push code |
| `curl` installed | To call the GitHub API |
| A GitHub account | To host your repository |
| Two GitHub repo secrets configured | For secure token and username access |

---

## Setting Up GitHub Secrets (Do This Once)

The script reads your GitHub credentials from **repository secrets** — never from hardcoded values in the script or workflow file.

### Step 1 — Create a GitHub Personal Access Token

1. Go to **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. Click **"Generate new token (classic)"**
3. Give it a name like `flutter-setup-bot`
4. Set **Expiration** to **90 days** — GitHub now enforces a maximum of 90 days on classic tokens; no-expiry tokens are no longer recommended
5. Under **Scopes**, tick **`repo`** (gives full access to create and push private repos)
6. Click **Generate token** — **copy it immediately**, you will not see it again

> ⏰ **Token expiry reminder:** Because the token expires in 90 days, you will need to regenerate it and update the `TOKEN` secret in your repository settings before it expires — otherwise the script will fail with a `403` or `401` error. Put a calendar reminder for day 85 so you are never caught off guard.

#### When the token expires — how to fix it

If the script fails with an error like `Error at line X → git push`, `403 Forbidden`, or `Bad credentials`, your token has most likely expired. Here is how to fix it:

1. Go to **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. Click **"Generate new token (classic)"** (you cannot reuse an expired token — you must create a fresh one)
3. Give it the same name (`flutter-setup-bot`) and set expiration to **90 days** again
4. Tick the **`repo`** scope
5. Click **Generate token** and copy the new value
6. Go to **your repository → Settings → Secrets and variables → Actions**
7. Find the `TOKEN` secret, click **"Update"**, paste the new token, and save

That's it — no changes needed to the script or workflow file. The new token is picked up automatically on the next run.

### Step 2 — Add Secrets to Your Repository

1. Open the repository where this script lives
2. Go to **Settings → Secrets and variables → Actions**
3. Click **"New repository secret"** and add both of these:

| Secret Name | Value |
|-------------|-------|
| `TOKEN` | Your Personal Access Token from Step 1 |
| `USER_NAME` | Your GitHub username (e.g. `johndoe`) |

> GitHub automatically masks these values in all logs — even if something accidentally prints them, they appear as `***`.

### Step 3 — Reference Secrets in Your Workflow

In your GitHub Actions `.yml` file, pass the secrets as environment variables:

```yaml
- name: Run Flutter Setup Script
  env:
    TOKEN: ${{ secrets.TOKEN }}
    USER_NAME: ${{ secrets.USER_NAME }}
  run: |
    bash setup.sh \
      ""                              \
      "${{ inputs.project_name }}"   \
      "${{ inputs.app_name }}"       \
      "${{ inputs.bundle_id }}"      \
      "${{ inputs.width }}"          \
      "${{ inputs.height }}"         \
      ""                             \
      ""                             \
      "${{ inputs.repo_url }}"
```

The script picks up `TOKEN` and `USER_NAME` directly from the environment — no need to pass them as positional arguments.

---

## Input Parameters Explained

### Positional Arguments (passed on the command line)

| Argument | Variable | Example | Description |
|----------|----------|---------|-------------|
| `$2` | `PROJECT_NAME` | `my_flutter_app` | Technical name used in `pubspec.yaml` and folder names. **No spaces — use underscores.** |
| `$3` | `APP_NAME` | `My Flutter App` | Human-readable display name shown on the device. Spaces are fine. |
| `$4` | `BUNDLE_ID` | `com.mycompany.myapp` | Unique app identifier in reverse-domain format. Used in Android and iOS configs. |
| `$5` | `WIDTH` | `390` | Screen width value substituted into your Flutter code. |
| `$6` | `HEIGHT` | `844` | Screen height value substituted into your Flutter code. |
| `$9` | `REPO_URL_INPUT` | `https://github.com/you/repo.git` | An **existing** repo to push into. Leave empty to auto-create a new private repo. |

> Arguments `$1`, `$7`, and `$8` are unused positional slots — always pass them as empty strings `""`.

### Environment Variables (from GitHub Secrets)

| Env Variable | Secret Name | Description |
|--------------|-------------|-------------|
| `TOKEN` | `secrets.TOKEN` | GitHub Personal Access Token with `repo` scope |
| `USER_NAME` | `secrets.USER_NAME` | Your GitHub username |

---

## Step-by-Step: What the Script Does Internally

### Step 1 — Safety Settings

```bash
set -Eeuo pipefail
```

Makes the script strict and safe:

- `-e` — Stop immediately if any command fails
- `-u` — Stop if an unset variable is referenced
- `-o pipefail` — A failure anywhere in a pipeline fails the whole pipeline
- `-E` — Error traps also fire inside functions

Without this, a script might silently skip failures and leave your project half-configured.

---

### Step 2 — Read Inputs

```bash
PROJECT_NAME="${2:-}"
GITHUB_USERNAME="${USER_NAME:-}"
GITHUB_TOKEN="${TOKEN:-}"
```

- Positional args (`$2`, `$3`, etc.) come from the command line call
- `USER_NAME` and `TOKEN` come from the environment (injected by GitHub Actions secrets)
- The `${VAR:-}` syntax means: *"use this variable, but default to empty string if it is not set"* — prevents an unbound variable crash under `-u`

---

### Step 3 — Logging Helpers

```bash
log() { echo "👉 $*"; }
ok()  { echo "✅ $*"; }
err() { echo "❌ $*"; }
```

Simple functions that make terminal and Actions log output easy to scan at a glance.

---

### Step 4 — Error Trap

```bash
trap 'err "Error at line $LINENO → $BASH_COMMAND"' ERR
```

If anything fails, this fires automatically and prints the **exact line number** and **command** that broke — invaluable for debugging CI failures without having to reproduce them locally.

---

### Step 5 — Validation

```bash
if [[ -z "$PROJECT_NAME" || -z "$APP_NAME" || -z "$BUNDLE_ID" ]]; then
  err "Missing required arguments"
  exit 1
fi

if [[ -z "$GITHUB_USERNAME" || -z "$GITHUB_TOKEN" ]]; then
  err "Missing GitHub credentials (USER_NAME / TOKEN)"
  exit 1
fi
```

Two separate checks run before any real work begins:
- First confirms the three core project fields are not empty
- Second confirms GitHub credentials were successfully injected from secrets

`-z` tests whether a string is empty. Failing fast here prevents the script from partially completing and leaving a broken or inconsistent state.

---

### Step 6 — Create a Temporary Workspace

```bash
WORK_DIR="${RUNNER_TEMP:-/tmp}/temp_${PROJECT_NAME}"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cp -r . "$WORK_DIR/"
cd "$WORK_DIR"
rm -rf .git
```

- Creates a clean temp folder (e.g. `/tmp/temp_my_flutter_app`)
- Copies your entire template project into it
- Deletes the template `.git` folder so the new project starts with a fresh Git history

> `RUNNER_TEMP` is automatically set by GitHub Actions. When running locally it falls back to `/tmp`.

---

### Step 7 — The `replace_all` Function

```bash
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
```

The core find-and-replace engine, broken down:

1. `grep -rl "$search" .` — Recursively finds every file containing the search string
2. `file "$file" | grep -q text` — Skips binary files (images, compiled assets); only processes plain text files
3. `sed -i.bak "s|$search|$replace|g"` — Replaces every occurrence in-place; `.bak` is a safety copy required by `sed` on macOS
4. `rm -f "${file}.bak"` — Cleans up the temporary backup file
5. `|| true` — Prevents a non-match from causing the script to exit under `set -e`

> The `|` separator in `sed` (instead of the usual `/`) prevents breakage when `$replace` contains forward slashes — as bundle IDs like `com/mycompany/myapp` do.

---

### Step 8 — Apply Template Substitutions

```bash
if [[ -f pubspec.yaml ]]; then
  sed -i.bak "s/^name:.*/name: ${PROJECT_NAME}/" pubspec.yaml || true
  rm -f pubspec.yaml.bak
fi

replace_all "PROJECT_NAME_PLACEHOLDER" "$PROJECT_NAME"
replace_all "APP_NAME_PLACEHOLDER"     "$APP_NAME"
replace_all "BUNDLE_ID_PLACEHOLDER"    "$BUNDLE_ID"
replace_all "WIDTH_PLACEHOLDER"        "$WIDTH"
replace_all "HEIGHT_PLACEHOLDER"       "$HEIGHT"

replace_all "com.example.base_project" "$BUNDLE_ID"
replace_all "Base Project"             "$APP_NAME"
```

Your Flutter template must contain these exact placeholder strings. The script replaces every occurrence across all text files in the project.

The `pubspec.yaml` name line gets its own targeted `sed` command using the regex `^name:.*` because it needs to match the whole line precisely, not just the placeholder string.

**Example:** `AndroidManifest.xml` containing `com.example.base_project` becomes `com.mycompany.myapp`.

---

### Step 9 — Fix Android Package Directory Structure

```bash
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
```

Android requires Kotlin source files to live in a folder path that **mirrors the bundle ID exactly**.

For `com.mycompany.myapp` the required path is:
```
android/app/src/main/kotlin/com/mycompany/myapp/
```

What the script does:
1. Finds the old template folder (3 levels deep under `kotlin/`)
2. Converts the bundle ID to a folder path by replacing dots with slashes (`tr '.' '/'`)
3. Creates the new directory, moves the files in, and removes the old folder
4. Updates the `package` declaration at the top of every `.kt` file

The outer `if [[ -d "$BASE" ]]` guard safely skips this entire block if the Android directory does not exist (e.g. for iOS-only or web-only projects).

---

### Step 10 — Repository Setup

#### Using an existing repo (`$9` is not empty):

```bash
REPO_URL=$(echo "$REPO_URL_INPUT" | sed "s|https://|https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@|")
```

Injects credentials into the URL so `git push` authenticates without a password prompt.

Before: `https://github.com/johndoe/my_flutter_app.git`
After:  `https://johndoe:ghp_token@github.com/johndoe/my_flutter_app.git`

#### Auto-creating a new repo (`$9` is empty):

```bash
curl -s -X POST https://api.github.com/user/repos \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -d "{\"name\":\"${PROJECT_NAME}\",\"private\":true}" > /dev/null

REPO_URL="https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${PROJECT_NAME}.git"
```

Calls the GitHub API to create a new **private** repository named after your project, then builds the authenticated URL for the push. Output is redirected to `/dev/null` to keep the logs clean.

---

### Step 11 — Commit and Push

```bash
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
```

- `git init` — Starts a brand new local repository
- `git config` — Sets a bot identity for the commit author line
- `git add .` — Stages every file in the temp workspace
- `git commit` — Creates the first snapshot with a descriptive message
- `git branch -M main` — Renames the default branch to `main`
- `git push --force` — Pushes to GitHub, overwriting any prior content

> The `echo "DEBUG → $REPO_URL"` line prints the full authenticated URL (including the token) to the Actions log. GitHub's secret masking does redact the token value as `***`, but this line should be **removed before going to production** — debug output has no place in a finished workflow.

> `--force` is intentional here — this script is for **fresh project creation only**. Never use it on a repo with ongoing development history.

---

## Template Placeholders Reference

Your base Flutter project must contain these exact strings:

| Placeholder | Replaced With | Typical Location |
|------------|--------------|-----------------|
| `PROJECT_NAME_PLACEHOLDER` | Your project name | `pubspec.yaml`, config files |
| `APP_NAME_PLACEHOLDER` | Your display app name | `AndroidManifest.xml`, `Info.plist` |
| `BUNDLE_ID_PLACEHOLDER` | Your bundle/package ID | Build configs, manifest files |
| `WIDTH_PLACEHOLDER` | Screen width value | Dart constants file |
| `HEIGHT_PLACEHOLDER` | Screen height value | Dart constants file |
| `com.example.base_project` | Your bundle ID | Android Manifest, Gradle files |
| `Base Project` | Your app display name | Any display name fields |

---

## Output

On success you will see:

```
✅ 🎉 DONE → https://johndoe:***@github.com/johndoe/my_flutter_app.git
```

Your new project is live at `https://github.com/johndoe/my_flutter_app`.

---

## Common Errors and Fixes

| Error | Likely Cause | Fix |
|-------|-------------|-----|
| `Missing required arguments` | `PROJECT_NAME`, `APP_NAME`, or `BUNDLE_ID` is empty | Check `$2`, `$3`, `$4` in your workflow `run:` block |
| `Missing GitHub credentials` | `TOKEN` or `USER_NAME` env vars not set | Confirm both secrets exist and are passed via `env:` in the workflow step |
| `Error at line X → git push` | Token expired (90-day limit) or wrong | Regenerate token → update `TOKEN` secret in repo Settings → Secrets |
| Push fails with `403` or `401 Bad credentials` | Token expired or missing `repo` scope | Create a new token with `repo` scope ticked; update the `TOKEN` secret |
| `mv: no such file or directory` | Template Android folder structure is wrong | Ensure your template has at least 3 nested folders under `kotlin/` |
| `curl` call silently fails | Repo name already exists on GitHub | Use a unique `PROJECT_NAME`, or pass an existing repo URL via `$9` |

---

## Security Notes

- **Secrets are never hardcoded** — `TOKEN` and `USER_NAME` are injected at runtime from GitHub repository secrets
- **GitHub masks secret values** — they appear as `***` in logs even if accidentally printed
- **All repos created are private** — `"private":true` is hardcoded in the API call
- **Credentials exist only in memory** — they are embedded in the Git remote URL at runtime and never written to disk or committed
- **Tokens expire every 90 days** — regenerate at GitHub Settings → Developer settings → Personal access tokens, then update the `TOKEN` secret under your repo's Settings → Secrets and variables → Actions
- **Remove the DEBUG line in production** — `echo "DEBUG → $REPO_URL"` should be deleted once the workflow is stable

---

## Quick Reference Card

```
GitHub Secrets (Settings → Secrets and variables → Actions):
  TOKEN       → GitHub Personal Access Token  (needs full "repo" scope)
  USER_NAME   → Your GitHub username

Workflow step (env block is required):
  env:
    TOKEN: ${{ secrets.TOKEN }}
    USER_NAME: ${{ secrets.USER_NAME }}

Script positional arguments:
  $1  — (unused, pass "")
  $2  — PROJECT_NAME        e.g. my_flutter_app
  $3  — APP_NAME            e.g. "My Flutter App"
  $4  — BUNDLE_ID           e.g. com.company.app
  $5  — WIDTH               e.g. 390
  $6  — HEIGHT              e.g. 844
  $7  — (unused, pass "")
  $8  — (unused, pass "")
  $9  — REPO_URL_INPUT      existing HTTPS repo URL, or "" to auto-create

What the script does:
  1. Validates project fields and GitHub credentials
  2. Copies template into a clean temp folder
  3. Replaces all placeholders with your real values
  4. Fixes the Android Kotlin package folder structure
  5. Creates a new private GitHub repo OR uses an existing one
  6. Commits everything and force-pushes to main
```