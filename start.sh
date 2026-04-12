#!/usr/bin/env bash
set -euo pipefail

export PATH="/root/.local/bin:${PATH}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/data/hermes}"

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
chown -R node:node "${PAPERCLIP_HOME}" "${HERMES_HOME}"

# Build inner script for `node`: allowed-hostname must run before exec paperclipai run
# (exec replaces the shell, so "exec cmd1 && cmd2" never runs cmd2).
q() { printf '%q' "$1"; }

run_node=""
run_node+="export PATH=$(q "${PATH}"); "
run_node+="export HOME=$(q "${PAPERCLIP_HOME}"); "
run_node+="export PAPERCLIP_HOME=$(q "${PAPERCLIP_HOME}"); "
run_node+="export HERMES_HOME=$(q "${HERMES_HOME}"); "
run_node+="export HOST='0.0.0.0'; "
if [ -n "${IP_ADDRESS:-}" ]; then
  run_node+="paperclipai allowed-hostname $(q "${IP_ADDRESS}") && "
fi
run_node+="exec paperclipai run"

exec su -s /bin/bash node -c "${run_node}"
