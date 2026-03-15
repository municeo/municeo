#!/bin/bash
# Auto-fix code style on edited PHP files
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only process PHP files
if [[ "$FILE_PATH" != *.php ]]; then
  exit 0
fi

# Only run if php-cs-fixer is installed
if [ -f vendor/bin/php-cs-fixer ]; then
  vendor/bin/php-cs-fixer fix "$FILE_PATH" --quiet 2>/dev/null
fi

exit 0
