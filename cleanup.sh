#!/bin/sh
set -e

REPO="atwarevn/claude-code-bedrock-setup"
CLEANUP_URL="https://raw.githubusercontent.com/${REPO}/main/src/cleanup.js"

echo ""
echo "Claude Code × API Gateway — Cleanup"
echo ""

# Check Node.js
if ! command -v node >/dev/null 2>&1; then
  echo "[error]  Node.js is required but not found."
  echo "         Install it from https://nodejs.org and re-run this script."
  exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//')
NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 18 ]; then
  echo "[error]  Node.js >= 18 is required (found v${NODE_VERSION})."
  echo "         Upgrade at https://nodejs.org"
  exit 1
fi

# Download and run cleanup
BASE=$(mktemp /tmp/claude-bedrock-cleanup.XXXXXX)
TMP="${BASE}.mjs"
mv "$BASE" "$TMP"
curl -fsSL "$CLEANUP_URL" -o "$TMP"
node "$TMP" </dev/tty
rm -f "$TMP"
