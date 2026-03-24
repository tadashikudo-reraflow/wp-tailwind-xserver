#!/bin/bash
# =============================================================================
# setup-deploy.sh — Xserver SSH + GitHub SSH + GitHub Actions auto-deploy setup
# Usage: ./setup-deploy.sh <ssh-user> <server> <domain> [theme-name] [github-user/repo]
#
# Example:
#   ./setup-deploy.sh reraflow sv16843 reraflow.com reraflow-theme tadashikudo-reraflow/reraflow-com
# =============================================================================

set -e

SSH_USER="${1}"
SERVER="${2}"
DOMAIN="${3}"
THEME_NAME="${4:-$(basename "$PWD")}"
GITHUB_SLUG="${5:-}"   # "user/repo" or "user" format
GITHUB_USER="${GITHUB_SLUG%%/*}"
GITHUB_REPO="${GITHUB_SLUG##*/}"
[[ "$GITHUB_USER" == "$GITHUB_REPO" ]] && GITHUB_REPO=""

KEY_NAME="xserver_${SSH_USER}"
KEY_PATH="$HOME/.ssh/${KEY_NAME}"
CI_KEY_PATH="$HOME/.ssh/${KEY_NAME}_ci"
GITHUB_KEY_PATH="$HOME/.ssh/github_${SSH_USER}"
FULL_SERVER="${SERVER}.xserver.jp"

# Validate args
if [[ -z "$SSH_USER" || -z "$SERVER" || -z "$DOMAIN" ]]; then
  echo "Usage: ./setup-deploy.sh <ssh-user> <server> <domain> [theme-name] [github-user/repo]"
  echo "Example: ./setup-deploy.sh reraflow sv16843 reraflow.com my-theme tadashikudo-reraflow/my-site"
  exit 1
fi

echo ""
echo "=== WP Tailwind Deploy Setup ==="
echo "  Xserver User : $SSH_USER @ $FULL_SERVER"
echo "  Domain       : $DOMAIN"
echo "  Theme        : $THEME_NAME"
[[ -n "$GITHUB_SLUG" ]] && echo "  GitHub       : $GITHUB_SLUG"
echo ""

# ── Step 1: Xserver SSH key (local, with passphrase ok) ──────────────────────

if [[ -f "$KEY_PATH" ]]; then
  echo "✓ Xserver SSH key already exists: $KEY_PATH"
else
  echo "→ Generating Xserver SSH key (local)..."
  ssh-keygen -t ed25519 -C "${SSH_USER}-deploy" -f "$KEY_PATH" -N ""
  echo "✓ Xserver SSH key generated"
fi

# Step 2: Add to macOS Keychain
ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null && echo "✓ Xserver key added to macOS Keychain" || true

# Step 3: SSH config for Xserver
if grep -q "Host xserver-${SSH_USER}" "$HOME/.ssh/config" 2>/dev/null; then
  echo "✓ SSH config entry already exists: xserver-${SSH_USER}"
else
  echo "→ Adding Xserver SSH config..."
  cat >> "$HOME/.ssh/config" << EOF

Host xserver-${SSH_USER}
  HostName ${FULL_SERVER}
  Port 10022
  User ${SSH_USER}
  IdentityFile ${KEY_PATH}
  UseKeychain yes
  AddKeysToAgent yes
EOF
  chmod 600 "$HOME/.ssh/config"
  echo "✓ Xserver SSH config added"
fi

# ── Step 4: CI key (no passphrase, for GitHub Actions) ───────────────────────

if [[ -f "$CI_KEY_PATH" ]]; then
  echo "✓ CI deploy key already exists: $CI_KEY_PATH"
else
  echo "→ Generating CI deploy key (no passphrase)..."
  ssh-keygen -t ed25519 -C "${SSH_USER}-ci-deploy" -f "$CI_KEY_PATH" -N ""
  echo "✓ CI deploy key generated"
fi

# ── MANUAL STEP 1: Register keys in Xserver panel ────────────────────────────

echo ""
echo "=========================================="
echo "⚠️  MANUAL STEP 1 of 2: Xserver パネルに公開鍵を登録"
echo "   Xserver パネル → SSH公開鍵登録 → 以下を2つとも追加"
echo ""
echo "── ローカル用 (${KEY_NAME}) ──"
cat "${KEY_PATH}.pub"
echo ""
echo "── GitHub Actions 用 (${KEY_NAME}_ci) ──"
cat "${CI_KEY_PATH}.pub"
echo ""
echo "登録完了したら Enter を押してください..."
read -r

# Test Xserver connection
echo "→ Xserver 接続テスト..."
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "xserver-${SSH_USER}" exit 2>/dev/null; then
  echo "✓ Xserver SSH 接続成功"
else
  echo "⚠️  接続失敗。公開鍵の登録を確認してから再試行してください。"
  echo "   確認後に Enter で継続..."
  read -r
fi

# ── MANUAL STEP 2: Xserver 国外アクセス制限 OFF ──────────────────────────────

echo ""
echo "=========================================="
echo "⚠️  MANUAL STEP 2 of 2: Xserver SSH 国外アクセス制限を OFF"
echo "   Xserver パネル → SSH設定 → 国外アクセス制限 → OFF"
echo "   ※ GitHub Actions は海外IPのためデプロイに必要です"
echo "   ※ 鍵認証のみ有効なので安全です"
echo ""
echo "変更完了したら Enter を押してください..."
read -r

# ── GitHub SSH key (for pushing from local) ──────────────────────────────────

if [[ -n "$GITHUB_USER" ]]; then
  if [[ -f "$GITHUB_KEY_PATH" ]]; then
    echo "✓ GitHub SSH key already exists: $GITHUB_KEY_PATH"
  else
    echo "→ Generating GitHub SSH key..."
    ssh-keygen -t ed25519 -C "${GITHUB_USER}@github" -f "$GITHUB_KEY_PATH" -N ""
    echo "✓ GitHub SSH key generated"
  fi

  ssh-add --apple-use-keychain "$GITHUB_KEY_PATH" 2>/dev/null && echo "✓ GitHub key added to macOS Keychain" || true

  if ! grep -q "Host github.com" "$HOME/.ssh/config" 2>/dev/null; then
    cat >> "$HOME/.ssh/config" << EOF

Host github.com
  HostName github.com
  User git
  IdentityFile ${GITHUB_KEY_PATH}
  UseKeychain yes
  AddKeysToAgent yes
EOF
    chmod 600 "$HOME/.ssh/config"
    echo "✓ GitHub SSH config added"
  fi

  # Register GitHub SSH key
  if command -v gh &>/dev/null; then
    echo "→ GitHub SSH 鍵を登録中..."
    gh ssh-key add "${GITHUB_KEY_PATH}.pub" --title "${SSH_USER}-local" 2>/dev/null && echo "✓ GitHub SSH key registered" || echo "⚠️  GitHub SSH key 登録失敗（手動で登録: https://github.com/settings/ssh/new）"
  fi

  # Switch git remote to SSH
  if git remote get-url origin 2>/dev/null | grep -q "https://github.com"; then
    CURRENT_REMOTE=$(git remote get-url origin)
    SSH_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|https://github.com/|git@github.com:|')
    git remote set-url origin "$SSH_REMOTE"
    echo "✓ Git remote → SSH: $SSH_REMOTE"
  fi
fi

# ── GitHub repository + Actions setup ────────────────────────────────────────

if [[ -n "$GITHUB_USER" ]] && command -v gh &>/dev/null; then

  # Create GitHub repo if not exists
  if [[ -n "$GITHUB_REPO" ]]; then
    if gh repo view "${GITHUB_USER}/${GITHUB_REPO}" &>/dev/null; then
      echo "✓ GitHub repo already exists: ${GITHUB_USER}/${GITHUB_REPO}"
    else
      echo "→ GitHub プライベートリポジトリ作成中: ${GITHUB_USER}/${GITHUB_REPO}..."
      gh repo create "${GITHUB_USER}/${GITHUB_REPO}" --private --source=. --remote=origin 2>/dev/null && echo "✓ GitHub repo created" || true
    fi
  fi

  # Set GitHub Secret for CI deploy key
  echo "→ GitHub Secret XSERVER_SSH_KEY を登録中..."
  if [[ -n "$GITHUB_REPO" ]]; then
    gh secret set XSERVER_SSH_KEY < "$CI_KEY_PATH" --repo "${GITHUB_USER}/${GITHUB_REPO}" && echo "✓ GitHub Secret XSERVER_SSH_KEY 登録完了"
  else
    echo "⚠️  リポジトリ名が指定されていないため Secret は手動登録してください"
    echo "   gh secret set XSERVER_SSH_KEY < ${CI_KEY_PATH}"
  fi

  # Create GitHub Actions workflow
  mkdir -p .github/workflows
  cat > .github/workflows/deploy.yml << EOF
name: Deploy to Xserver

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build Tailwind CSS
        run: npm run build

      - name: Setup SSH agent
        uses: webfactory/ssh-agent@v0.9.0
        with:
          ssh-private-key: \${{ secrets.XSERVER_SSH_KEY }}

      - name: Add Xserver to known_hosts
        run: ssh-keyscan -p 10022 ${FULL_SERVER} >> ~/.ssh/known_hosts

      - name: Deploy via rsync
        run: |
          rsync -avz --delete \\
            -e 'ssh -p 10022' \\
            --exclude='.git' \\
            --exclude='.github' \\
            --exclude='.claude' \\
            --exclude='node_modules' \\
            --exclude='src' \\
            --exclude='package*.json' \\
            --exclude='DESIGN.md' \\
            --exclude='CLAUDE.md' \\
            --exclude='README.md' \\
            --exclude='setup-deploy.sh' \\
            --exclude='preview.html' \\
            --exclude='.gitignore' \\
            ./ ${SSH_USER}@${FULL_SERVER}:~/${DOMAIN}/public_html/wp-content/themes/${THEME_NAME}/

      - name: Done
        run: echo "✓ Deploy complete → ${DOMAIN}"
EOF
  echo "✓ .github/workflows/deploy.yml 生成完了"
fi

# ── package.json deploy script ───────────────────────────────────────────────

if [[ -f "package.json" ]]; then
  DEPLOY_CMD="npm run build && rsync -avz --delete -e 'ssh -p 10022' --exclude='.git' --exclude='.github' --exclude='.claude' --exclude='node_modules' --exclude='src' --exclude='package*.json' --exclude='DESIGN.md' --exclude='CLAUDE.md' --exclude='README.md' --exclude='setup-deploy.sh' --exclude='preview.html' --exclude='.gitignore' ./ xserver-${SSH_USER}:~/${DOMAIN}/public_html/wp-content/themes/${THEME_NAME}/ && echo '✓ Deploy complete → ${DOMAIN}'"
  node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.scripts.deploy = $(echo "$DEPLOY_CMD" | node -e "process.stdout.write(JSON.stringify(require('fs').readFileSync('/dev/stdin','utf8').trim()))");
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, '\t') + '\n');
  "
  echo "✓ package.json deploy script updated"
fi

# ── Initial push ──────────────────────────────────────────────────────────────

if [[ -n "$GITHUB_REPO" ]] && command -v git &>/dev/null; then
  if ! git rev-parse HEAD &>/dev/null; then
    git init && git branch -M main
  fi
  git add -A
  git diff --cached --quiet || git commit -m "Initial commit: WP Tailwind Xserver theme"
  git push -u origin main 2>/dev/null && echo "✓ GitHub へ push 完了" || true
fi

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "=========================================="
echo "✅ セットアップ完了！"
echo ""
echo "今後のワークフロー:"
echo "  コード編集 → git push → 自動デプロイ（約30秒）→ ${DOMAIN} 反映"
echo ""
echo "手動デプロイ:"
echo "  npm run deploy"
echo ""
[[ -n "$GITHUB_REPO" ]] && echo "Actions ログ:"
[[ -n "$GITHUB_REPO" ]] && echo "  https://github.com/${GITHUB_USER}/${GITHUB_REPO}/actions"
echo "=========================================="
echo ""
