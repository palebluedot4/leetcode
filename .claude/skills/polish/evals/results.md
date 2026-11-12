# Results

Summaries of eval runs; raw output is in the gitignored `results/`. The
skill is evaluated on the models it is used with, `claude-opus-5-5` and
`claude-sonnet-5-5`, each at its default effort.

Every cost below is the evaluator's estimate at API list prices. The runs
used a Claude plan login (`apiKeySource: none` in every trace), not an API
key, so they drew on the plan's usage rather than being billed; the
estimates still compare runs with each other.

## The cases

Each case's `place-files.sh` copies `AGENTS.md`, `go.mod`, `pyproject.toml`
and `.golangci.yml` from this repository, so the cases read the rules as
they stand.

| Case                       | Rule it checks                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `modernizes-both-files`    | Dated code becomes current idiom; a better complexity is reached in both languages; each change is justified |
| `leaves-clean-files-alone` | Files already clean are neither edited nor rewritten                                                         |
| `no-alternative-added`     | No second solution is added, and a gain the constraints bound to a constant is not chased                    |

## 2026-11-12: final run

- **Setup:** `make eval SKILL=polish`: `--ablation none`, three runs per
  case, threshold 1.0, judge `claude-sonnet-5-5`; Claude Code 2.1.322 with
  `DISABLE_AUTOUPDATER=1`.
- **Result:** every case passed every run on both models.

| Model               | Cases | Score | Estimated cost |
| ------------------- | ----- | ----- | -------------- |
| `claude-opus-5-5`   | 3/3   | 1.00  | 2.39 USD       |
| `claude-sonnet-5-5` | 3/3   | 1.00  | 1.45 USD       |

## How it got there

Before the CLI runs, one subagent run per case with and without the skill,
through skill-creator, put the skill at 100% against 90% for the baseline.
The two guard cases pass without the skill too; the difference is in
`modernizes-both-files`, where the baseline kept an O(n log n) sort. That
baseline is indicative only: one run each, and the baseline sessions saw an
older version of the repository's instructions.

Twelve rounds of `make eval` then found these, each fixed in the skill:

- **Paths read from the skill's directory**, as with `/tutor`.
- **A clean file rewritten with Write**, and a bounded gain chased: the
  Python palindrome was rewritten into the Go file's digit arithmetic for
  O(log x) space on at most ten digits.
- **The complexity rule read as a language rule.** Told not to trade a
  language's idiom, the model kept Python at O(n log k), calling bucket sort
  the Go file's technique. An algorithm belongs to the problem; only a gain
  the constraints make constant is not worth an idiom.
- **Unjustified or invented citations.** The longest tail: a change folded
  into the algorithm bullet without a source, a formatter's behavior cited
  as an authority, and check codes recalled wrongly or hedged ("S1005" for
  the wrong change, "S1011-style"). The report now ends every bullet with a
  `Complexity:` or `Source:` label, cites linters by the names the
  repository's configuration gives them rather than by code, and folds what
  only served the old algorithm into the algorithm bullet.
- **Lint findings missed when `make check` cannot run**, such as gocritic's
  `assignOp`. The skill now reads the enabled checks and applies them.

The grader for justifications (`08-justifies-each-change`) was reworded
along the way, to accept the repository's own authorities (`AGENTS.md`,
pyright's strict mode) that it had wrongly excluded, and its check of the
report's ending was split off into a regex.

## Limits

- The skill was adjusted against these same cases, so passing them is not
  evidence that it generalizes.
- `claude-sonnet-5-5` reached a clean run last, and in the rounds before it
  usually lost one run of the justification grader on split judge votes.
  Expect an occasional bullet without a proper source from Sonnet.
- The eval workspace has no repository tools, so `make check` never ran in
  it; in real use it does, and catches lint the skill misses.
