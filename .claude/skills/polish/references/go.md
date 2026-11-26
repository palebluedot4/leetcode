# Go

Authorities, in order; the higher one wins:

1. [The Go Programming Language Specification](https://go.dev/ref/spec),
   `gofmt` and `go vet`
2. [Effective Go](https://go.dev/doc/effective_go)
3. [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
4. Google Go Style Guide: [Guide](https://google.github.io/styleguide/go/guide),
   then [Decisions](https://google.github.io/styleguide/go/decisions), then
   [Best Practices](https://google.github.io/styleguide/go/best-practices)

## The newest idiom the judge allows

The judge runs the release on `go.mod`'s go line. Which constructs and
standard-library APIs are newest changes with every release, so it is not
listed here; the tools track it:

- golangci-lint's `modernize` (in `make check`) proposes the newest form the
  go line allows, and `go vet` rejects an API newer than it.
- When you consider an API and are not sure the judge's release has it, check
  the [release notes](https://go.dev/doc/devel/release) for the version that
  added it.

## What the tools do not check

Each rule names its source, so it can be checked against the source.

- **MixedCaps**, never underscores, for multiword names.
  ([Effective Go, MixedCaps](https://go.dev/doc/effective_go#mixed-caps))
- **Initialisms keep one case**: `ID`, `URL`, never `Id`.
  ([Code Review Comments, Initialisms](https://go.dev/wiki/CodeReviewComments#initialisms))
- **A name's length is proportional to its scope.** Short names, `i`, `n`,
  `c`, for locals with a small scope; more descriptive ones as the scope
  grows. ([Code Review Comments, Variable Names](https://go.dev/wiki/CodeReviewComments#variable-names);
  [Decisions, Variable names](https://google.github.io/styleguide/go/decisions#variable-names))
- **A struct field or package-level name is read far from its declaration**,
  in every method or function of the file, so it gets a word, not a letter:
  `buckets`, not `b`. A field that holds a LeetCode parameter takes the
  parameter's name: `value`, not `val`.
  ([Code Review Comments, Variable Names](https://go.dev/wiki/CodeReviewComments#variable-names);
  [Guide, Maintainability](https://google.github.io/styleguide/go/guide#maintainability))
- **One name means one thing in a function, and one thing keeps one name.**
  When a second concept would reuse a name, such as `n` for an element in one
  loop and a count in the next, or an inner `:=` hiding an outer variable with
  a different meaning, give it its own name. Reusing a name for the same
  concept, such as a sift-down cursor `i`, is fine.
  ([Guide, Consistency](https://google.github.io/styleguide/go/guide#consistency);
  [Best Practices, Shadowing](https://google.github.io/styleguide/go/best-practices#shadowing))
- **A receiver is one or two letters abbreviating its type, the same in every
  method**: `s *MyHashSet`, never `this` or `self`, whatever the stub says.
  ([Code Review Comments, Receiver Names](https://go.dev/wiki/CodeReviewComments#receiver-names);
  [Decisions, Receiver names](https://google.github.io/styleguide/go/decisions#receiver-names))
- **A name does not repeat its type**: `seen`, not `seenMap`.
  ([Decisions, Variable name vs. type](https://google.github.io/styleguide/go/decisions#repetitive-with-type))
- **The normal path stays at minimal indentation**; handle the special case
  first and return. revive's `early-return` and `indent-error-flow` catch the
  mechanical cases.
  ([Code Review Comments, Indent Error Flow](https://go.dev/wiki/CodeReviewComments#indent-error-flow))
- **Range over values when the index only reads the element**:
  `for _, n := range nums`, not `for i := range nums` with `nums[i]`. Keep
  the index when it is written to, compared, or used for a second slice.
  ([Effective Go, For](https://go.dev/doc/effective_go#for))
- **Preallocate only when the final size is known and the hint reads no
  worse**: `make([]int, 0, k)`. It is acceptable, never required; do not add
  one to a small or uncertain size.
  ([Best Practices, Size hints](https://google.github.io/styleguide/go/best-practices#vardeclsize))
- **An empty local slice is `var t []T`.**
  ([Code Review Comments, Declaring Empty Slices](https://go.dev/wiki/CodeReviewComments#declaring-empty-slices);
  [Decisions, Nil slices](https://google.github.io/styleguide/go/decisions#nil-slices))
  Except a slice the solution returns and that may be empty: how the judge
  prints a nil slice is not documented, so keep it non-nil, `[]T{}`. Passing
  the judge outranks both sources, though Decisions prefers nil for a
  returned slice.
- **A set is `map[T]bool`**: add with `seen[n] = true`, test with
  `if seen[n]`. `map[T]struct{}` saves bytes that do not matter at LeetCode's
  sizes, and costs a comma-ok at every lookup.
  ([Effective Go, Maps](https://go.dev/doc/effective_go#maps);
  [Guide, Least mechanism](https://google.github.io/styleguide/go/guide#least-mechanism))
- **This repository's vocabulary**: an element of `nums` is `n`; its length
  stays `len(nums)`, so `n` never means a count; a result is named for what
  it holds, such as `top`, `groups`, `merged`, and `res` only when nothing
  better fits. This one is this repository's rule, not a style guide's; the
  guide only asks that the code near it agree.
  ([Guide, Local consistency](https://google.github.io/styleguide/go/guide#local-consistency))

Everything else this repository requires of a solution, such as no comments,
exact imports, and LeetCode's names untouched, is in `AGENTS.md`.
