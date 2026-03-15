#!/bin/bash
# Block framework imports in Domain layer files
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')

# Only check Domain files
if [[ "$FILE_PATH" != *"src/Domain/"* ]]; then
  exit 0
fi

# Check for forbidden imports
if echo "$NEW_CONTENT" | grep -qE '^\s*use (Doctrine|Symfony|Infrastructure)\\'; then
  echo "Blocked: Domain layer must not import Doctrine/Symfony/Infrastructure. File: $FILE_PATH" >&2
  exit 2
fi

exit 0
