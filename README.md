# code-reviewer

Local LLM-powered code review tool using Llama via Ollama.

## What it does

1. **Analyzes** a git diff or file for bugs, issues, and code quality
2. **Performs RCA** (root cause analysis) on errors or failing tests
3. **Proposes a fix** as a git patch
4. **Opens a draft PR** on GitHub for human review
5. **Never auto-merges** — a human must approve and merge

## Requirements

- [Ollama](https://ollama.com) running locally
- `gh` CLI authenticated (`gh auth login`)
- `git` configured with your identity

## Setup

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull the code model
ollama pull llama3.1

# Install Python deps
pip install -r requirements.txt
```

## Usage

```bash
# Review uncommitted changes
./scripts/review.sh

# Review a specific file
./scripts/review.sh path/to/file.py

# Root cause analysis on an error log
./scripts/rca.sh error.log

# Propose a fix and open a draft PR
./scripts/fix-and-pr.sh
```

## Workflow

```
analyze → propose fix → create branch → open draft PR → human reviews → human merges
```

Branch protection on target repos enforces that no PR can be merged without a human approval.
