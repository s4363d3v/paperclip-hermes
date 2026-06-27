#!/usr/bin/env bash
set -euo pipefail

echo "[entrypoint] pid=$$ starting as $(id)"

# Non-interactive onboard on first boot
if [ ! -d "${PAPERCLIP_HOME}/instances" ]; then
  echo "[entrypoint] first boot — running paperclipai onboard --yes"
  paperclipai onboard --yes || echo "[entrypoint] WARNING: onboard exited non-zero"
fi

# Register allowed hostname if IP_ADDRESS is set
if [ -n "${IP_ADDRESS:-}" ]; then
  echo "[entrypoint] registering allowed-hostname ${IP_ADDRESS}"
  paperclipai allowed-hostname "${IP_ADDRESS}" || echo "[entrypoint] WARNING: allowed-hostname failed (will retry after start)"
fi

echo "[entrypoint] starting paperclipai run as node (postgres refuses root)"
exec su -s /bin/bash node -c "HOME=${PAPERCLIP_HOME} PAPERCLIP_HOME=${PAPERCLIP_HOME} HERMES_HOME=${HERMES_HOME} HOST=0.0.0.0 exec paperclipai run"
