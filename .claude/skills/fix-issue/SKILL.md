---
name: fix-issue
description: Fix a GitHub issue end-to-end
argument-hint: <issue-number>
disable-model-invocation: true
---

Fix GitHub issue #$ARGUMENTS:

1. `gh issue view $ARGUMENTS` — read the issue details
2. Search the codebase for relevant files
3. Implement the fix following project architecture (Domain → Application → Infrastructure)
4. Write tests that cover the fix
5. Run `/run-checks` to verify everything passes
6. Create a descriptive commit
7. Push and open a PR with `gh pr create`
