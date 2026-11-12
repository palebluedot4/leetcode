#!/usr/bin/env bash
#
# PostToolUse: formats the file Claude just wrote, and only that file, so
# formatting rarely reaches the gate. Go goes through gofumpt; Python through
# ruff's formatter and its safe lint fixes; shell scripts through shfmt;
# Markdown, YAML and JSON through Prettier, and Markdown then through
# markdownlint's fixes. Anything that cannot be fixed automatically is
# reported back to Claude.
#
# Unlike `make fmt`, it never removes an unused import: an edit that adds an
# import before the edit that uses it would lose it. So goimports is left out
# and ruff's F401 is not fixed here; the gate reports a stale import, and
# `make fmt` removes it.

set -euo pipefail

if ! command -v jq >/dev/null; then
	echo "jq is not installed; the format hook cannot read which file was edited." >&2
	exit 2
fi
file=$(jq -r '.tool_input.file_path // empty')
[[ -f ${file} && ${file} == "${CLAUDE_PROJECT_DIR}"/* ]] || exit 0
cd "${CLAUDE_PROJECT_DIR}"

# A skill's eval fixtures are written badly on purpose, for /polish to fix.
case "${file}" in
*/.claude/skills/*/evals/*/files/*) exit 0 ;;
esac

run() {
	local out
	if [[ ! -x $1 ]] && ! command -v "$1" >/dev/null; then
		echo "$1 is not installed; the maintainer needs to run \`make setup\`." >&2
		exit 2
	fi
	if ! out=$("$@" 2>&1); then
		echo "$* reported problems in ${file}:" >&2
		echo "${out}" >&2
		exit 2
	fi
}

case "${file}" in
*.go)
	# The pinned version, read from the Makefile without running make.
	version=$(awk '$1 == "GOLANGCI_LINT_VERSION" { print $3 }' Makefile)
	run "bin/golangci-lint-${version}" fmt --no-config --enable gofumpt "${file}"
	;;
*.py)
	run uv run --frozen ruff check --fix-only --unfixable F401 --quiet "${file}"
	run uv run --frozen ruff format --quiet "${file}"
	;;
*.sh | */.githooks/*)
	run uv run --frozen shfmt -w "${file}"
	;;
*.md)
	run node_modules/.bin/prettier --write --log-level warn "${file}"
	run node_modules/.bin/markdownlint-cli2 --no-globs --fix "${file}"
	;;
*.yml | *.yaml | *.json | *.jsonc)
	run node_modules/.bin/prettier --write --log-level warn --ignore-unknown "${file}"
	;;
esac
