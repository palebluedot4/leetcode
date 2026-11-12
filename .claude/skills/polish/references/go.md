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
- **A name's length is proportional to its scope.** Short names, `i`, `l`,
  `r`, `n`, for locals with a small scope; more descriptive ones as the scope
  grows. ([Code Review Comments, Variable Names](https://go.dev/wiki/CodeReviewComments#variable-names);
  [Decisions, Variable names](https://google.github.io/styleguide/go/decisions#variable-names))
- **A name does not repeat its type**: `seen`, not `seenMap`.
  ([Decisions, Variable name vs. type](https://google.github.io/styleguide/go/decisions#repetitive-with-type))
- **The normal path stays at minimal indentation**; handle the special case
  first and return. revive's `early-return` and `indent-error-flow` catch the
  mechanical cases.
  ([Code Review Comments, Indent Error Flow](https://go.dev/wiki/CodeReviewComments#indent-error-flow))
- **Preallocate when the final size is known**: `make([]int, 0, n)`.
  ([Best Practices, Size hints](https://google.github.io/styleguide/go/best-practices#vardeclsize))
- **An empty local slice is `var t []T`.**
  ([Code Review Comments, Declaring Empty Slices](https://go.dev/wiki/CodeReviewComments#declaring-empty-slices))
  Except a slice the solution returns and that may be empty: how the judge
  prints a nil slice is not documented, so keep it non-nil, `[]T{}`. Passing
  the judge outranks the style guide.

Everything else this repository requires of a solution, such as no comments,
exact imports, and LeetCode's names untouched, is in `AGENTS.md`.
