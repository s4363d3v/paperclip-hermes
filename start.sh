#!/usr/bin/env bash
set -euo pipefail

export HOME=/root
export PATH="/root/.local/bin:${PATH}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/root/.hermes}"

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"

echo "Container is alive. Sleeping forever for debugging..."
tail -f /dev/null
