---
tags: [done]
plugins: ["../..", "../../../polish"]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
append_system_prompt: >-
  In this environment the shell's `git` is a broken Xcode shim. Run git as
  "$EVAL_GIT" instead, for example `"$EVAL_GIT" status`; nothing else about
  git changes.
---

/done 242

Input files: AGENTS.md, lists/neetcode-250.md,
problems/0242-valid-anagram/solution.go
