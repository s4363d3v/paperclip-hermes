#!/usr/bin/env bash
set -euo pipefail

export HOME=/root
export PATH="/root/.local/bin:${PATH}"
export PAPERCLIP_HOME="${PAPERCLIP_HOME:-/data/paperclip}"
export HERMES_HOME="${HERMES_HOME:-/root/.hermes}"

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"

exec paperclipai run
