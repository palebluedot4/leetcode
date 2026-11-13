# Results

Summaries of eval runs; raw output is in the gitignored `results/`. The
skill is evaluated on the models it is used with, `claude-opus-5-5` and
`claude-sonnet-5-5`, each at its default effort.

Every cost below is the evaluator's estimate at API list prices. The runs
used a Claude plan login, not an API key, so they drew on the plan's usage
rather than being billed; the estimates still compare runs with each other.

## The cases

Each case's `place-files.sh` copies `AGENTS.md` from this repository, so the
cases read the rules as they stand.

| Case                              | Rule it checks                                                                                                                 |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `scaffolds-a-linked-list-problem` | Premium 271 is skipped; 206's stubs come from LeetCode, with `ListNode` in `judge.go` and opening `solution.py`; no hint given |
| `leaves-work-in-progress-alone`   | A problem begun and not committed is named, and nothing is written                                                             |

`scaffolds-a-linked-list-problem` fetches the stubs from leetcode.com, so
it needs the network and LeetCode's API as it is on the day.

## 2026-11-13: final run

- **Setup:** `make eval SKILL=next`: `--ablation none`, three runs per
  case, threshold 1.0, judge `claude-sonnet-5-5`; Claude Code 2.1.322 with
  `DISABLE_AUTOUPDATER=1`.
- **Result:** every case passed every run on both models.

| Model               | Cases | Score | Estimated cost |
| ------------------- | ----- | ----- | -------------- |
| `claude-opus-5-5`   | 2/2   | 1.00  | 1.97 USD       |
| `claude-sonnet-5-5` | 2/2   | 1.00  | 1.35 USD       |

## How it got there

Two rounds. The one failure was in the eval, not the skill: the
evaluator's sandbox lets shell commands reach only the domains granted as
`WebFetch(domain:...)`, so the script's request to leetcode.com was refused,
and the skill correctly stopped rather than write stubs from memory.
`make eval` now grants `WebFetch(domain:leetcode.com)`.

## Limits

- The final run predates two changes to how `make eval` runs every suite:
  the target became `.claude/skills` with `--eval-dir`, and `EVAL_GIT` was
  added for the suites that run git. Neither touches what these cases do,
  since the skill runs git only through its script, but the run is not on
  the current command.
- The skill was adjusted against these same cases, so passing them is not
  evidence that it generalizes.
