#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROMPT_FILE="$REPO_ROOT/prompts/rca.txt"
MODEL="llama3.1"
OLLAMA_HOST="http://localhost:11434"

if [ -z "$1" ]; then
  echo "Usage: rca.sh <error_log_file or error_string>"
  exit 1
fi

if [ -f "$1" ]; then
  ERROR=$(cat "$1")
else
  ERROR="$1"
fi

PROMPT=$(sed "s|{error}|$ERROR|g" "$PROMPT_FILE")

echo "=== Root Cause Analysis ==="
echo ""
curl -s "$OLLAMA_HOST/api/generate" \
  -H "Content-Type: application/json" \
  -d "{\"model\": \"$MODEL\", \"prompt\": $(echo "$PROMPT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'), \"stream\": false}" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['response'])"
