#!/bin/bash
# =============================================================================
# setup-deploy.sh — Xserver SSH + GitHub SSH + rsync deploy setup
# Usage: ./setup-deploy.sh <ssh-user> <server> <domain> [theme-name] [github-user]
#
# Example:
#   ./setup-deploy.sh reraflow sv16843 reraflow.com reraflow-theme tadashikudo-reraflow
# =============================================================================

set -e

SSH_USER="${1}"
SERVER="${2}"
DOMAIN="${3}"
THEME_NAME="${4:-$(basename "$PWD")}"
GITHUB_USER="${5:-}"
KEY_NAME="xserver_${SSH_USER}"
KEY_PATH="$HOME/.ssh/${KEY_NAME}"
GITHUB_KEY_PATH="$HOME/.ssh/github_${SSH_USER}"
FULL_SERVER="${SERVER}.xserver.jp"

# Validate args
if [[ -z "$SSH_USER" || -z "$SERVER" || -z "$DOMAIN" ]]; then
  echo "Usage: ./setup-deploy.sh <ssh-user> <server> <domain> [theme-name] [github-user]"
  echo "Example: ./setup-deploy.sh reraflow sv16843 reraflow.com my-theme tadashikudo-reraflow"
  exit 1
fi

echo ""
echo "=== WP Tailwind Deploy Setup ==="
echo "  Xserver User: $SSH_USER @ $FULL_SERVER"
echo "  Domain:       $DOMAIN"
echo "  Theme:        $THEME_NAME"
[[ -n "$GITHUB_USER" ]] && echo "  GitHub:       $GITHUB_USER"
echo ""

# ── Xserver SSH ──────────────────────────────────────────────────────────────

# Step 1: Generate Xserver SSH key
if [[ -f "$KEY_PATH" ]]; then
  echo "✓ Xserver SSH key already exists"
else
  echo "→ Generating Xserver SSH key..."
  ssh-keygen -t ed25519 -C "${SSH_USER}-deploy" -f "$KEY_PATH" -N ""
  echo "✓ Xserver SSH key generated"
fi

# Step 2: Add to macOS Keychain (no passphrase prompts ever again)
ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null && echo "✓ Xserver key added to macOS Keychain" || true

# Step 3: SSH config for Xserver
if grep -q "Host xserver-${SSH_USER}" "$HOME/.ssh/config" 2>/dev/null; then
  echo "✓ SSH config entry already exists for xserver-${SSH_USER}"
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

# ── GitHub SSH ───────────────────────────────────────────────────────────────

if [[ -n "$GITHUB_USER" ]]; then
  # Step 4: Generate GitHub SSH key
  if [[ -f "$GITHUB_KEY_PATH" ]]; then
    echo "✓ GitHub SSH key already exists"
  else
    echo "→ Generating GitHub SSH key..."
    ssh-keygen -t ed25519 -C "${GITHUB_USER}@github" -f "$GITHUB_KEY_PATH" -N ""
    echo "✓ GitHub SSH key generated"
  fi

  # Step 5: Add GitHub key to macOS Keychain
  ssh-add --apple-use-keychain "$GITHUB_KEY_PATH" 2>/dev/null && echo "✓ GitHub key added to macOS Keychain" || true

  # Step 6: SSH config for GitHub
  if grep -q "Host github.com" "$HOME/.ssh/config" 2>/dev/null; then
    echo "✓ GitHub SSH config already exists"
  else
    echo "→ Adding GitHub SSH config..."
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

  # Step 7: Switch git remote from HTTPS to SSH
  if git remote get-url origin 2>/dev/null | grep -q "https://github.com"; then
    CURRENT_REMOTE=$(git remote get-url origin)
    SSH_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|https://github.com/|git@github.com:|')
    git remote set-url origin "$SSH_REMOTE"
    echo "✓ Git remote switched to SSH: $SSH_REMOTE"
  fi
fi

# ── package.json deploy script ───────────────────────────────────────────────

if [[ -f "package.json" ]]; then
  DEPLOY_CMD="npm run build && rsync -avz --delete -e 'ssh -p 10022' --exclude='.git' --exclude='.claude' --exclude='node_modules' --exclude='src' --exclude='package*.json' --exclude='DESIGN.md' --exclude='CLAUDE.md' --exclude='README.md' --exclude='setup-deploy.sh' --exclude='preview.html' ./ xserver-${SSH_USER}:~/${DOMAIN}/public_html/wp-content/themes/${THEME_NAME}/ && echo '✓ Deploy complete → ${DOMAIN}'"
  node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.scripts.deploy = $(echo "$DEPLOY_CMD" | node -e "process.stdout.write(JSON.stringify(require('fs').readFileSync('/dev/stdin','utf8').trim()))");
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, '\t') + '\n');
  "
  echo "✓ package.json deploy script updated"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "=========================================="
echo "MANUAL STEPS REQUIRED:"
echo ""
echo "1. Register Xserver public key:"
echo "   Xserver Panel → SSH公開鍵登録"
echo ""
cat "${KEY_PATH}.pub"
echo ""

if [[ -n "$GITHUB_USER" ]]; then
  echo "------------------------------------------"
  echo "2. Register GitHub public key:"
  echo "   https://github.com/settings/ssh/new"
  echo ""
  cat "${GITHUB_KEY_PATH}.pub"
  echo ""
fi

echo "=========================================="
echo ""
echo "After registering keys:"
echo "  ssh xserver-${SSH_USER}   # test Xserver"
[[ -n "$GITHUB_USER" ]] && echo "  ssh -T git@github.com      # test GitHub"
echo "  npm run deploy             # deploy to ${DOMAIN}"
echo ""
