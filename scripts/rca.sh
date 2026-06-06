#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PROMPT_FILE="$REPO_ROOT/prompts/rca.txt"
MODEL="llama3.1"
OLLAMA_HOST="http://localhost:11434"

if [ -z "$1" ]; then
  echo "Usage: rca.sh <error_log_file or \"error string\">"
  exit 1
fi

echo "=== Root Cause Analysis ==="
echo ""

python3 - <<PYEOF
import json, urllib.request, os

with open("$PROMPT_FILE") as f:
    template = f.read()

arg = "$1"
error = open(arg).read() if os.path.isfile(arg) else arg
prompt = template.replace("{error}", error)

payload = json.dumps({"model": "$MODEL", "prompt": prompt, "stream": False}).encode()
req = urllib.request.Request("$OLLAMA_HOST/api/generate",
    data=payload, headers={"Content-Type": "application/json"})
with urllib.request.urlopen(req) as resp:
    print(json.loads(resp.read())["response"])
PYEOF
