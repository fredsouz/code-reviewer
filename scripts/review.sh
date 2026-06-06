#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROMPT_FILE="$REPO_ROOT/prompts/review.txt"
MODEL="llama3.1"
OLLAMA_HOST="http://localhost:11434"

if [ -n "$1" ]; then
  DIFF=$(git diff "$1" 2>/dev/null)
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

echo "=== Code Review ==="
echo ""

python3 - <<PYEOF
import json, urllib.request, sys

with open("$PROMPT_FILE") as f:
    template = f.read()

diff = open("$1").read() if "$1" and __import__("os").path.isfile("$1") else """$DIFF"""
prompt = template.replace("{diff}", diff)

payload = json.dumps({"model": "$MODEL", "prompt": prompt, "stream": False}).encode()
req = urllib.request.Request("$OLLAMA_HOST/api/generate",
    data=payload, headers={"Content-Type": "application/json"})
with urllib.request.urlopen(req) as resp:
    print(json.loads(resp.read())["response"])
PYEOF
