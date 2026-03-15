#!/bin/bash
# PostToolUse: warn when a PHP file is missing declare(strict_types=1)
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE_PATH" != *.php ]]; then
  exit 0
fi

# Only check src/ and tests/ files
if [[ "$FILE_PATH" != *"src/"* && "$FILE_PATH" != *"tests/"* ]]; then
  exit 0
fi

# Read the actual file on disk (after write/edit)
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Check first 5 lines for strict_types declaration
if ! head -5 "$FILE_PATH" | grep -q 'declare(strict_types=1)'; then
  echo '{"systemMessage": "Missing declare(strict_types=1); at the top of '$FILE_PATH'. Every PHP file must have it."}'
  exit 0
fi

exit 0
