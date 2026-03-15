#!/bin/bash
# PostToolUse: warn when Command/Query DTOs contain methods other than __construct
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check Command and Query DTOs
if [[ "$FILE_PATH" != *"/Command/"* && "$FILE_PATH" != *"/Query/"* ]]; then
  exit 0
fi

if [[ "$FILE_PATH" != *.php ]]; then
  exit 0
fi

# Read the file after edit
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check for public/protected/private function other than __construct
if grep -qP '^\s*(public|protected|private)\s+function\s+(?!__construct)' "$FILE_PATH"; then
  echo '{"systemMessage": "DTO purity: Commands and Queries must be pure data carriers with only __construct(). No methods. See .claude/rules/dto.md"}'
  exit 0
fi

exit 0
