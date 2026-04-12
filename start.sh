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
if [ ! -f "${HERMES_HOME}/config.yaml" ]; then
  echo "[entrypoint] seeding default hermes config into ${HERMES_HOME}"
  cp /etc/hermes/config.yaml "${HERMES_HOME}/config.yaml"
  cp /etc/hermes/.env        "${HERMES_HOME}/.env"
  chown node:node "${HERMES_HOME}/config.yaml" "${HERMES_HOME}/.env"
fi

# Run paperclipai onboard non-interactively if not yet initialized
if [ ! -d "${PAPERCLIP_HOME}/instances" ]; then
  echo "[entrypoint] first boot — running non-interactive onboard"
  su -s /bin/bash node -c "
    export HOME=${PAPERCLIP_HOME}
    export PAPERCLIP_HOME=${PAPERCLIP_HOME}
    export HERMES_HOME=${HERMES_HOME}
    export HOST=0.0.0.0
    paperclipai onboard --yes
  " || echo "[entrypoint] WARNING: onboard returned non-zero (may already be initialized)"
fi

echo "[entrypoint] handing off to node user"
exec su -s /bin/bash node -c "
  export HOME=${PAPERCLIP_HOME}
  export PAPERCLIP_HOME=${PAPERCLIP_HOME}
  export HERMES_HOME=${HERMES_HOME}
  export HOST=0.0.0.0
  export IP_ADDRESS=${IP_ADDRESS:-}
  exec /start-worker.sh
"
