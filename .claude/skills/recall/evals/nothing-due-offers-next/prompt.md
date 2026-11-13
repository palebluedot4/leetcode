---
tags: [recall]
max_turns: 15
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
append_system_prompt: >-
  In this environment the shell's `git` is a broken Xcode shim. Run git as
  "$EVAL_GIT" instead, for example `"$EVAL_GIT" status`; nothing else about
  git changes.
---

/recall

Input files: lists/neetcode-250.md, problems/0217-contains-duplicate
