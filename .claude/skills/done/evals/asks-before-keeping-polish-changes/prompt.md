---
tags: [done]
plugins: ["../..", "../../../polish"]
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
append_system_prompt: >-
  In this environment the shell's `git` is a broken Xcode shim. Run git as
  "$EVAL_GIT" instead, for example `"$EVAL_GIT" status`; nothing else about
  git changes.
---

/done 0001

Input files: AGENTS.md, go.mod, pyproject.toml, lists/neetcode-250.md,
problems/0001-two-sum/solution.go, problems/0001-two-sum/solution.py
