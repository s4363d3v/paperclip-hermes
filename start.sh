#!/usr/bin/env bash
set -euo pipefail

mkdir -p "${PAPERCLIP_HOME}" "${HERMES_HOME}"
export HOME=/root

mkdir -p /root/.hermes

if [ ! -e /root/.hermes/config.yaml ] && [ ! -L /root/.hermes ]; then
  rm -rf /root/.hermes
  ln -s "${HERMES_HOME}" /root/.hermes
fi

if [ ! -f "${PAPERCLIP_HOME}/.initialized" ]; then
  mkdir -p "${PAPERCLIP_HOME}"
  cd "${PAPERCLIP_HOME}"
  npx paperclipai onboard --yes
  touch "${PAPERCLIP_HOME}/.initialized"
fi

cd "${PAPERCLIP_HOME}"
exec npx paperclipai run
