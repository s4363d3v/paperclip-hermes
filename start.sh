#!/usr/bin/env bash
set -euo pipefail

echo "[entrypoint] pid=$$ starting as $(id)"

export PATH="/root/.local/bin:${PATH}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/data/hermes}"

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
chown -R node:node "${PAPERCLIP_HOME}" "${HERMES_HOME}"

q() { printf '%q' "$1"; }

run_node=""
run_node+="echo '[node] starting setup'; "
run_node+="export PATH=$(q "${PATH}"); "
run_node+="export HOME=$(q "${PAPERCLIP_HOME}"); "
run_node+="export PAPERCLIP_HOME=$(q "${PAPERCLIP_HOME}"); "
run_node+="export HERMES_HOME=$(q "${HERMES_HOME}"); "
run_node+="export HOST=$(q "0.0.0.0"); "

if [ -n "${IP_ADDRESS:-}" ]; then
  run_node+="echo '[node] applying allowed-hostname ${IP_ADDRESS}'; "
  run_node+="paperclipai allowed-hostname $(q "${IP_ADDRESS}") || true; "
fi

run_node+="echo '[node] running paperclipai run'; "
run_node+="exec paperclipai run"

echo "[entrypoint] handing off to su(node)"
exec su -s /bin/bash node -c "${run_node}"
