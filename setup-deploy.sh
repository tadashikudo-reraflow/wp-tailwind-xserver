#!/bin/bash
# =============================================================================
# setup-deploy.sh — Xserver SSH + rsync deploy setup
# Usage: ./setup-deploy.sh <ssh-user> <server> <domain> [theme-name]
#
# Example:
#   ./setup-deploy.sh reraflow sv16843 reraflow.com reraflow-theme
# =============================================================================

set -e

SSH_USER="${1}"
SERVER="${2}"
DOMAIN="${3}"
THEME_NAME="${4:-$(basename "$PWD")}"
KEY_NAME="xserver_${SSH_USER}"
KEY_PATH="$HOME/.ssh/${KEY_NAME}"
FULL_SERVER="${SERVER}.xserver.jp"

# Validate args
if [[ -z "$SSH_USER" || -z "$SERVER" || -z "$DOMAIN" ]]; then
  echo "Usage: ./setup-deploy.sh <ssh-user> <server> <domain> [theme-name]"
  echo "Example: ./setup-deploy.sh reraflow sv16843 reraflow.com my-theme"
  exit 1
fi

echo ""
echo "=== WP Tailwind Xserver Deploy Setup ==="
echo "  User:   $SSH_USER"
echo "  Server: $FULL_SERVER"
echo "  Domain: $DOMAIN"
echo "  Theme:  $THEME_NAME"
echo "  Key:    $KEY_PATH"
echo ""

# Step 1: Generate SSH key (skip if exists)
if [[ -f "$KEY_PATH" ]]; then
  echo "✓ SSH key already exists: $KEY_PATH"
else
  echo "→ Generating SSH key..."
  ssh-keygen -t ed25519 -C "${SSH_USER}-deploy" -f "$KEY_PATH" -N ""
  echo "✓ SSH key generated"
fi

# Step 2: Add to SSH config
if grep -q "Host xserver-${SSH_USER}" "$HOME/.ssh/config" 2>/dev/null; then
  echo "✓ SSH config already has entry for xserver-${SSH_USER}"
else
  echo "→ Adding SSH config entry..."
  cat >> "$HOME/.ssh/config" << EOF

Host xserver-${SSH_USER}
  HostName ${FULL_SERVER}
  Port 10022
  User ${SSH_USER}
  IdentityFile ${KEY_PATH}
EOF
  chmod 600 "$HOME/.ssh/config"
  echo "✓ SSH config updated"
fi

# Step 3: Update package.json deploy script
if [[ -f "package.json" ]]; then
  DEPLOY_CMD="npm run build && rsync -avz --delete -e 'ssh -p 10022 -i ${KEY_PATH}' --exclude='.git' --exclude='.claude' --exclude='node_modules' --exclude='src' --exclude='package*.json' --exclude='DESIGN.md' --exclude='CLAUDE.md' --exclude='README.md' --exclude='setup-deploy.sh' --exclude='preview.html' ./ ${SSH_USER}@${FULL_SERVER}:~/${DOMAIN}/public_html/wp-content/themes/${THEME_NAME}/ && echo '✓ Deploy complete → ${DOMAIN}'"

  # Use node to update package.json safely
  node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.scripts.deploy = $(echo "$DEPLOY_CMD" | node -e "process.stdout.write(JSON.stringify(require('fs').readFileSync('/dev/stdin','utf8').trim()))");
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, '\t') + '\n');
  "
  echo "✓ package.json deploy script updated"
fi

# Step 4: Show public key
echo ""
echo "=========================================="
echo "NEXT STEP — Register this public key in Xserver:"
echo "  Panel → SSH公開鍵登録"
echo ""
cat "${KEY_PATH}.pub"
echo ""
echo "=========================================="
echo ""
echo "After registering the key, run:"
echo "  ssh-add ${KEY_PATH}   # (skip passphrase prompts)"
echo "  ssh xserver-${SSH_USER}   # (test connection)"
echo "  npm run deploy             # (deploy to ${DOMAIN})"
echo ""
