#!/usr/bin/env bash
set -euo pipefail

echo "[entrypoint] pid=$$ starting as $(id)"

export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/data/hermes}"

# Ensure data directories exist and are owned by node
# (TrueNAS volume mounts may create them as root)
mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
chown node:node "${PAPERCLIP_HOME}" "${HERMES_HOME}"

echo "[entrypoint] handing off to node user"
exec su -s /bin/bash node -- /start-worker.sh
