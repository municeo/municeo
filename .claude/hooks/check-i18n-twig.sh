#!/bin/bash
# PostToolUse: warn when Twig templates contain hardcoded user-facing text without |trans
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check Twig files
if [[ "$FILE_PATH" != *.twig ]]; then
  exit 0
fi

# Skip email templates (may use translated variables already)
if [[ "$FILE_PATH" == *"emails/"* ]]; then
  exit 0
fi

# Check for common hardcoded text patterns in the written content
# Look for text inside HTML tags that isn't a Twig expression and isn't a trans filter
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')

if [ -z "$CONTENT" ]; then
  exit 0
fi

# Flag: raw French text patterns (common words that should be translated)
FRENCH_PATTERNS='(Créer|Signalement|Valider|Rejeter|Clôturer|Soumettre|Connexion|Inscription|Envoyer|Supprimer|Modifier|Annuler|Confirmer|Bienvenue|Accueil|Mot de passe|Adresse|Erreur|Succès)'

if echo "$CONTENT" | grep -qPi "$FRENCH_PATTERNS"; then
  # Check if these words appear outside of trans filters
  if echo "$CONTENT" | grep -Pi "$FRENCH_PATTERNS" | grep -qvP "(\|trans|trans\(|'[^']*'|\"[^\"]*\")"; then
    echo '{"systemMessage": "i18n warning: Twig template may contain hardcoded French text. Use {{ '\''key'\''|trans }} instead of raw strings. See .claude/rules/i18n.md"}'
    exit 0
  fi
fi

exit 0
