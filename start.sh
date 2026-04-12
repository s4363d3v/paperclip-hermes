#!/usr/bin/env bash
set -euo pipefail

mkdir -p /root/.hermes
mkdir -p "${PAPERCLIP_HOME:-/data/paperclip}"

# Write Hermes env file from container env if provided
touch /root/.hermes/.env

if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  if ! grep -q '^OPENROUTER_API_KEY=' /root/.hermes/.env 2>/dev/null; then
    echo "OPENROUTER_API_KEY=${OPENROUTER_API_KEY}" >> /root/.hermes/.env
  else
    sed -i "s|^OPENROUTER_API_KEY=.*|OPENROUTER_API_KEY=${OPENROUTER_API_KEY}|" /root/.hermes/.env
  fi
fi

# Optional: set model/provider defaults if Hermes CLI is available
if command -v hermes >/dev/null 2>&1; then
  hermes config set OPENROUTER_API_KEY "${OPENROUTER_API_KEY:-}" || true
fi

# Start your app here
exec npx paperclipai run
