#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-app}"

export OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"
export OLLAMA_MODELS="${OLLAMA_MODELS:-/root/.ollama}"
export STREAMLIT_PORT="${STREAMLIT_PORT:-8501}"
export STREAMLIT_ADDRESS="${STREAMLIT_ADDRESS:-0.0.0.0}"
export MODEL_NAME="${MODEL_NAME:-phi4-mini}"
export SSH_PORT="${SSH_PORT:-2222}"

mkdir -p "${OLLAMA_MODELS}" /run/sshd /var/run/sshd /app/output

/usr/sbin/sshd -p "${SSH_PORT}"

echo "Starting Ollama on ${OLLAMA_HOST}"
ollama serve > /app/ollama.log 2>&1 &
sleep 5

if [ "${PULL_MODEL:-1}" = "1" ]; then
  if ! ollama list | awk 'NR>1 {print $1}' | grep -qx "${MODEL_NAME}"; then
    echo "Pulling model ${MODEL_NAME}"
    ollama pull "${MODEL_NAME}"
  fi
fi

case "${MODE}" in
  app)
    exec launch-extractinator --port "${STREAMLIT_PORT}"
    ;;
  shell)
    exec /bin/bash
    ;;
  *)
    echo "Unknown mode: ${MODE}"
    exit 1
    ;;
esac