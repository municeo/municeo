#!/bin/bash
# Block edits to files that should not be modified manually
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(".env" "migrations/" "var/" "vendor/" "public/bundles/")

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'. Migrations must be generated via doctrine:migrations:diff." >&2
    exit 2
  fi
done

exit 0
