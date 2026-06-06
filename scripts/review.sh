#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROMPT_FILE="$REPO_ROOT/prompts/review.txt"
MODEL="llama3.1"
OLLAMA_HOST="http://localhost:11434"

if [ -n "$1" ]; then
  DIFF=$(git diff "$1")
  if [ -z "$DIFF" ]; then
    DIFF=$(cat "$1")
  fi
else
  DIFF=$(git diff HEAD)
  if [ -z "$DIFF" ]; then
    DIFF=$(git diff --cached)
  fi
fi

if [ -z "$DIFF" ]; then
  echo "No changes to review."
  exit 0
fi

PROMPT=$(sed "s|{diff}|$DIFF|g" "$PROMPT_FILE")

echo "=== Code Review ==="
echo ""
curl -s "$OLLAMA_HOST/api/generate" \
  -H "Content-Type: application/json" \
  -d "{\"model\": \"$MODEL\", \"prompt\": $(echo "$PROMPT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'), \"stream\": false}" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['response'])"
