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

| Case                             | Rule it checks                                                                                                    |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `modernizes-both-files`          | Dated code becomes current idiom; a better complexity is reached in both languages; each change is justified      |
| `leaves-clean-files-alone`       | Files already clean are neither edited nor rewritten                                                              |
| `no-alternative-added`           | No second solution is added, and a gain the constraints bound to a constant is not chased                         |
| `names-fields-for-their-meaning` | A struct field or instance attribute named with a letter gets a word; a field takes its LeetCode parameter's name |
| `one-name-one-meaning`           | A nested parameter that reuses an outer name for another meaning is renamed; a countdown uses `reversed()`        |

## 2026-11-26: naming and loop rules from the style guides

The references gained the rules a survey of Effective Go, Go Code Review
Comments, the Google style guides, PEP 8 and the Python Tutorial and FAQ
found missing: one name, one meaning; fields and attributes named with a
word; receivers; ranging over values; sets as `map[T]bool`; `reversed()`
for a countdown; and this repository's own vocabulary. Two cases were added
for them, and `leaves-clean-files-alone`'s files were renamed to that
vocabulary, which the old `x` broke.

- **Setup:** as before, with Claude Code 2.1.332 and five cases.
- **Result:** every case passed every run on both models.

| Model               | Runs passed | Estimated cost |
| ------------------- | ----------- | -------------- |
| `claude-opus-5-5`   | 15/15       | 4.88 USD       |
| `claude-sonnet-5-5` | 15/15       | 2.58 USD       |

### What the rounds before it found

Seventeen rounds of `make eval`, not counting two cut short by the plan's
usage limit. Most rounds failed one or two runs of thirty, each time for a
different reason. These were fixed in the skill:

- **The repository's own rules had no citation.** The vocabulary rule lives
  in the references, but the list of authorities accepted only `AGENTS.md`.
  It now accepts a rule a reference marks as the repository's own, and the
  Tutorial and FAQ the references cite; every other rule in a reference is
  cited by the authority it names, not by the reference file.
- **The nested-parameter rule was too abstract.** Sonnet kept a nested
  `sift_down(i, n)` beside the method's `n = len(nums)`, because the first
  call does pass that `n`. The rule now says to compare each call's argument
  with the outer local of the same name.
- **Repository files read from the skill's location.** Read needs an
  absolute path, and Sonnet sometimes built it from the skill's base
  directory, which in the eval is outside the workspace; denied, it judged
  the files without the rules or gave up. The skill now joins the working
  directory with the relative path, checks that before calling a file
  missing, and stops if a reference cannot be read.
- **Citations that could not be right.** For `m[x] = m[x] + 1` the skill now
  names the check (gocritic's `assignOp`; revive's `increment-decrement`
  reports only `x += 1`). A redundant `for k, _ := range` is reported by
  gofumpt alone, yet formatters were not citable, so Sonnet could only cite
  one and fail; a formatter `make check` runs is now a source, and
  `gofmt -s`, which it does not run, is still not.
- **Report slips.** Old flaws the algorithm removed listed as bullets,
  notes written as bullets, a label followed by more text, and a last line
  extended for a single changed file. The skill now says each of these
  plainly and ends with a bullet-by-bullet check before the report is sent.
- **The short-name rule overreached.** Taken from pyguide, it had Sonnet
  rename `s = str(x)` in a two-line method to `digits`. `AGENTS.md`'s short
  names now outrank pyguide's limit of one letter to counters.
- **What the problem builds was replaced.** Sonnet swapped 0912's heap sort
  for `slices.Sort` and `nums.sort()`, which the problem forbids. A sort, a
  heap or a hash table written by hand is now kept, and only its writing is
  polished.

And these in the eval:

- **A fixture collided with the rule it tested.** The fields case kept the
  constant `buckets`/`_BUCKETS`, so renaming the field to `buckets` forced a
  second rename no rule covered. Its constants are now `size`/`_SIZE`, as in
  the repository.
- **The justification grader was a judge that cannot do the job.**
  `claude plugin eval` asks its judge, told to be "strict, terse", for one
  word, PASS or FAIL. Re-judging eleven reports exactly that way, the old
  checklist got four wrong and a shorter wording seven, with split votes on
  the same report. It is now three regexes: every bullet under a file's
  heading has a label; no source is `gofmt -s`, a hedged code or taste; no
  source is a reference file alone for a guide's rule. Run over the day's
  299 reports, they hit only real violations, and none after the skill
  learned the rules they check.

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

The grader for justifications (`08-justifies-each-change`, since
2026-11-26 the regex `08-every-change-labelled`) was reworded along the
way, to accept the repository's own authorities (`AGENTS.md`, pyright's
strict mode) that it had wrongly excluded, and its check of the report's
ending was split off into a regex.

## Limits

- The skill was adjusted against these same cases, so passing them is not
  evidence that it generalizes.
- The citation graders check form, not truth: a source that does not
  exist, such as the "Effective Go, Sort" one run invented, passes them.
- The LLM graders left (`03-says-clean`, `06-linear-time`) use the same
  one-word judge. Keep their criteria short; a long one splits its votes.
- Most rounds on 2026-11-26 lost one or two runs of thirty, each for a new
  reason, before a clean round. Expect a single failure in a full run, and
  read it before changing the skill.
- The eval workspace has no repository tools, so `make check` never ran in
  it; in real use it does, and catches lint the skill misses.
