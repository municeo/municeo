#!/bin/bash
# PostToolUse: warn when PHP controllers/listeners contain hardcoded user-facing strings
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check Infrastructure PHP files (controllers, listeners, responders)
if [[ "$FILE_PATH" != *.php ]]; then
  exit 0
fi

if [[ "$FILE_PATH" != *"Infrastructure/"* ]]; then
  exit 0
fi

CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')

if [ -z "$CONTENT" ]; then
  exit 0
fi

# Flag: hardcoded French strings in addFlash, Response, subject(), etc.
# Look for French text inside quotes passed to user-facing methods
PATTERNS='(addFlash|JsonResponse|Response|->subject)\s*\([^)]*[\x27"](Votre|Limite|Signalement|Erreur|Compte|Inscription|Bienvenue|Délai|Problème|Merci)'

if echo "$CONTENT" | grep -qPi "$PATTERNS"; then
  echo '{"systemMessage": "i18n warning: Hardcoded French string detected in Infrastructure layer. Use $this->translator->trans('\''key'\'') instead. See .claude/rules/i18n.md"}'
  exit 0
fi

exit 0
