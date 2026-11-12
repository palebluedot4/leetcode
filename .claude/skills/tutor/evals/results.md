# Results

Summaries of eval runs; raw output is in the gitignored `results/`. The
skill is evaluated on the models it is used with, `claude-opus-5-5` and
`claude-sonnet-5-5`, each at its default effort.

Every cost below is the evaluator's estimate at API list prices. The runs
used a Claude plan login (`apiKeySource: none` in every trace), not an API
key, so they drew on the plan's usage rather than being billed; the
estimates still compare runs with each other.

## The cases

Each case checks one rule of the skill. The prompts state the earlier turns
in prose, since a case is a single prompt.

| Case                             | Rule it checks                                                   |
| -------------------------------- | ---------------------------------------------------------------- |
| `first-reply-is-l0`              | The first reply is L0: no approach, no target, no code           |
| `hint-moves-one-level`           | A hint request moves exactly one level, here to L2               |
| `jump-to-answer`                 | An explicit request jumps to L5, answered in the user's language |
| `wrong-idea-gets-counterexample` | A wrong idea gets a checked counterexample and nothing more      |
| `never-edits-files`              | No Edit or Write even when asked, and debugging stays a question |

## 2026-11-12: final run

- **Setup:** `make eval SKILL=tutor`: `--ablation none`, three runs per
  case, threshold 1.0, judge `claude-sonnet-5-5`; Claude Code 2.1.322 with
  `DISABLE_AUTOUPDATER=1`.
- **Result:** every case passed every run on both models.

| Model               | Cases | Score | Estimated cost |
| ------------------- | ----- | ----- | -------------- |
| `claude-opus-5-5`   | 5/5   | 1.00  | 1.32 USD       |
| `claude-sonnet-5-5` | 5/5   | 1.00  | 0.67 USD       |

## How it got there

Before the CLI runs, one subagent run per case with and without the skill,
through skill-creator, put the skill at 100% against 38% for the baseline:
without the skill, the model gave the L3 insight with code when asked for
the next hint, led the user to the two-pointer idea instead of giving a
counterexample, and edited the user's file when asked to fix it. That
baseline is indicative only: one run each, and the baseline sessions saw an
older version of the repository's instructions.

Seven rounds of `make eval` then found these, each fixed in the skill:

- **Paths read from the skill's directory.** The model looked for `lists/`
  and `problems/` beside the skill rather than in the working directory;
  in the eval's sandbox that read was denied and the model guessed.
- **L0 leaked the method.** A complexity target ("you need O(n log n)"), a
  data structure even when ruled out ("too large to use as positions"), and
  an example walked as a procedure ("1 was seen at index 0") each point at
  the solution. L0 now has a fixed shape.
- **Debugging did the tracing.** Stating what the user's code computes on
  the failing input finds the bug for them.
- **A wrong counterexample, and an explanation after it.** The model must
  now check both answers before giving an input, and stop after it.
- **Comments in L5 code, and replies in English to a Chinese request.**

## Limits

- The skill was adjusted against these same cases, so passing them is not
  evidence that it generalizes to other problems.
- The eval sandbox denies reads outside the working directory and has no
  repository tools; a real session has both, so the eval is the harder
  setting for finding files.
