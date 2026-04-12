#!/usr/bin/env bash
set -euo pipefail

export PATH="/root/.local/bin:${PATH}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/data/hermes}"

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
chown -R node:node "${PAPERCLIP_HOME}" "${HERMES_HOME}"

exec su -s /bin/bash node -c "
  export HOME='${PAPERCLIP_HOME}'
  export PAPERCLIP_HOME='${PAPERCLIP_HOME}'
  export HERMES_HOME='${HERMES_HOME}'
  export HOST='0.0.0.0'
  exec paperclipai run
"
