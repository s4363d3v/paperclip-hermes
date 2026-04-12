#!/usr/bin/env bash
set -euo pipefail

export PATH="/root/.local/bin:${PATH}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/data/hermes}"
export START_DELAY="${START_DELAY:-0}"

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
chown -R node:node "${PAPERCLIP_HOME}" "${HERMES_HOME}"

if [ "${START_DELAY}" != "0" ]; then
  echo "Waiting ${START_DELAY}s before starting Paperclip..."
  sleep "${START_DELAY}"
fi

exec su -s /bin/bash node -c "
  export HOME='${PAPERCLIP_HOME}'
  export PAPERCLIP_HOME='${PAPERCLIP_HOME}'
  export HERMES_HOME='${HERMES_HOME}'
  exec paperclipai run
"
