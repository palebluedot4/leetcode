---
tags: [recall]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
append_system_prompt: >-
  In this environment the shell's `git` is a broken Xcode shim. Run git as
  "$EVAL_GIT" instead, for example `"$EVAL_GIT" status`; nothing else about
  git changes.
---

/recall done

Input files: lists/neetcode-250.md, .recall/0242-valid-anagram/solution.go,
.recall/0242-valid-anagram/solution.py
