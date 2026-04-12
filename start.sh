#!/usr/bin/env bash
set -euo pipefail

echo "[entrypoint] pid=$$ starting as $(id)"

export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/data/hermes}"

# Ensure data directories exist and are owned by node
# (TrueNAS volume mounts may create them as root)
mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
chown node:node "${PAPERCLIP_HOME}" "${HERMES_HOME}"

# Seed Hermes config into HERMES_HOME if not already present.
# The baked-in /etc/hermes/ files act as defaults; a persistent volume
# at HERMES_HOME will keep the user's runtime config across restarts.
if [ ! -f "${HERMES_HOME}/config.yaml" ]; then
  echo "[entrypoint] seeding default hermes config into ${HERMES_HOME}"
  cp /etc/hermes/config.yaml "${HERMES_HOME}/config.yaml"
  cp /etc/hermes/.env        "${HERMES_HOME}/.env"
  chown node:node "${HERMES_HOME}/config.yaml" "${HERMES_HOME}/.env"
fi

echo "[entrypoint] handing off to node user"
exec su -s /bin/bash node -- /start-worker.sh
