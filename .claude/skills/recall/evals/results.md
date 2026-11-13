# Results

Summaries of eval runs; raw output is in the gitignored `results/`. The
skill is evaluated on the models it is used with, `claude-opus-5-5` and
`claude-sonnet-5-5`, each at its default effort.

Every cost below is the evaluator's estimate at API list prices. The runs
used a Claude plan login, not an API key, so they drew on the plan's usage
rather than being billed; the estimates still compare runs with each other.

## The cases

Each case's `place-files.sh` builds a repository whose commits are
backdated, so the schedule finds problems due on the day the eval runs.

| Case                          | Rule it checks                                                                                                        |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `serves-most-overdue-bare`    | The schedule is asked; the most overdue problem is served with bare drafts and a reply that hints at nothing          |
| `grades-a-different-approach` | A correct sort is graded Correct, different, in Chinese, with the committed code; logged; the next due problem served |
| `wrong-answer-resets`         | A wrong draft is logged as a reset, with an input on which it fails                                                   |
| `nothing-due-offers-next`     | With nothing due, nothing is written and the next new problem is offered                                              |

## 2026-11-13: final run

- **Setup:** `make eval SKILL=recall`: `--ablation none`, three runs per
  case, threshold 1.0, judge `claude-sonnet-5-5`; Claude Code 2.1.323 with
  `DISABLE_AUTOUPDATER=1`.
- **Result:** every case passed every run on both models. Before it,
  `grades-a-different-approach` alone passed six of six runs on Sonnet.

| Model               | Cases | Score | Estimated cost |
| ------------------- | ----- | ----- | -------------- |
| `claude-opus-5-5`   | 4/4   | 1.00  | 2.78 USD       |
| `claude-sonnet-5-5` | 4/4   | 1.00  | 2.06 USD       |

## How it got there

Twelve rounds of `make eval`, the last five on one case. The eval's own
problems came first; `/done`'s
[results](../../done/evals/results.md) describe the git one, and the cases
here use the same `EVAL_GIT`. These were fixed in the skill:

- **The draft in the wrong place.** Told `.recall/<directory name>/` while
  the schedule printed `problems/0217-...`, Sonnet made
  `.recall/problems/0217-.../`. `schedule.py due` now prints each problem's
  `draft` path, used as printed.
- **A reply in the wrong language**, English to a user writing Chinese.
  Every reply now follows the user's language, whatever the files are in.
- **A different algorithm graded Perfect**, and the committed solution
  described rather than shown. The verdict now compares algorithms and
  complexity, opens the grade, and the code goes in a code block.
- **`cd` into the skill's own repository**, taken for the one to work in.
  The skill now stays in the working directory.
- **The grade left out.** The longest tail: after logging, Sonnet served
  the next problem and never told the user the verdict, about one run in
  six. Reminders in prose did not hold, and asking for the grade before
  the tool calls failed all six runs: Sonnet wrote no text between them,
  and took the grade as already given. What held was a slot for the grade
  at the top of the serving reply's template.

And these in the graders, each failing correct replies:

- **The problem's identity read as a hint.** The same bare reply passed or
  failed three votes to none across runs; the grader now says that the
  number, title, URL, slug, draft paths and recall count are not hints.
- **Drafts judged from the trace**, inside escaped `printf` strings, where
  the judge misread them; then from `focus: files`, which shows the judge
  file names only, not their content. The next problem's drafts are now
  checked by regexes on the files, its serving by a regex on the reply, and
  the removed draft by `file_exists`.

## Limits

- The skill was adjusted against these same cases, so passing them is not
  evidence that it generalizes.
- Sonnet leaving the grade out was the last failure to go, and it showed
  up once in six runs; one clean run of three per case does not rule it
  out.
