# `make check` is the only gate: there is no CI and there are no tests, and
# LeetCode's judge decides whether a solution is correct. The pre-commit hook
# runs it on a snapshot of what the commit stages; run by hand, it checks the
# working tree.
#
# On a fresh machine with Go, uv, Node.js, pnpm, jq and Claude Code installed,
# `make setup` installs everything else.

GO ?= go

# golangci-lint's release binary, pinned here by version and by the SHA-256 of
# each platform's archive, as the release's checksums file listed them when
# the version was pinned; a later change to the release then fails the
# install instead of reaching every commit. Installed into ./bin under a
# versioned name, so a bump is a reinstall. .claude/hooks/format.sh reads the
# version line. Bump all five lines together.
GOLANGCI_LINT_VERSION ?= v2.15.0
GOLANGCI_LINT_SHA256_darwin_amd64 := 767b899a28285e88ded2823d5dcc4bc5ef681173eb2d80f029a7b17ee4ece3b8
GOLANGCI_LINT_SHA256_darwin_arm64 := d1e409481a8ca846c4bc97e781eb5cb1bd5c23353a0b3977a1cbda1b1b6447d5
GOLANGCI_LINT_SHA256_linux_amd64 := 9b7fe6a6bf6334b98decf8d86b11415ea7889afdabdd1959fdce23af2a9ebcea
GOLANGCI_LINT_SHA256_linux_arm64 := b4d8f17068b35ee6060cc2f69a16fb48740d706fbba81661c318649c114a6998
GOLANGCI_LINT := bin/golangci-lint-$(GOLANGCI_LINT_VERSION)

OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := $(shell uname -m)
GOLANGCI_ARCH := $(patsubst x86_64,amd64,$(patsubst aarch64,arm64,$(ARCH)))

# Python's checkers and the shell tools are pinned in pyproject.toml and
# locked in uv.lock.
UV_RUN := uv run --frozen

# Node tools are pinned, with their whole dependency tree and overrides, by
# pnpm-lock.yaml, and reinstalled when its content changes; not its
# timestamp, which a git checkout rewrites, and not a comment in
# package.json or pnpm-workspace.yaml, which changes no dependency.
NODE_TOOLS := node-tools
NODE_LOCK_SUM := $(shell shasum -a 256 pnpm-lock.yaml 2>/dev/null | cut -d' ' -f1)
PRETTIER := node_modules/.bin/prettier
MARKDOWNLINT := node_modules/.bin/markdownlint-cli2

SHELL_SCRIPTS := $(wildcard .githooks/* .claude/hooks/*.sh .claude/skills/*/evals/*/*.sh)

# golangci-lint and go vet refuse a module without a Go file, which this one
# is until its first solution; until then, Go is skipped, and golangci-lint is
# not even installed for it.
GO_FILES := $(wildcard problems/*/*.go)

.DEFAULT_GOAL := help
.PHONY: help setup tools node-tools hooks check fmt go-check python-check \
	shell-check doc-check eval

help: ## Show the available targets
	@awk 'BEGIN { FS = ":.*## " } /^[a-z%-]+:.*## / { printf "  %-14s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

setup: tools hooks ## Once per clone: pinned tools and git hooks

tools: $(GOLANGCI_LINT) $(NODE_TOOLS) ## Install every pinned tool
	uv sync --frozen
	$(UV_RUN) pyright --version >/dev/null

hooks: ## Install the repository's git hooks
	git config core.hooksPath .githooks

check: go-check python-check shell-check doc-check ## Lint everything and check its formatting

fmt: $(if $(GO_FILES),$(GOLANGCI_LINT)) $(NODE_TOOLS) ## Format everything in place
	$(if $(GO_FILES),$(GOLANGCI_LINT) fmt ./...)
	$(UV_RUN) ruff check --fix-only --quiet .
	$(UV_RUN) ruff format .
	$(UV_RUN) shfmt -w $(SHELL_SCRIPTS)
	$(PRETTIER) --write --log-level warn .
	$(MARKDOWNLINT) --fix

# go vet runs on its own as well as inside golangci-lint: its stdversion
# analyzer is what rejects a standard-library API newer than the go line in
# go.mod, which is the judge's release.
go-check: $(if $(GO_FILES),$(GOLANGCI_LINT)) ## Lint Go and check its formatting
ifneq ($(GO_FILES),)
	$(GOLANGCI_LINT) fmt --diff ./...
	$(GOLANGCI_LINT) run ./...
	$(GO) vet ./...
endif

python-check: ## Lint and type-check Python and check its formatting
	$(UV_RUN) ruff format --check .
	$(UV_RUN) ruff check .
	$(UV_RUN) pyright

shell-check: ## Lint the repository's shell scripts and check their formatting
	$(UV_RUN) shellcheck $(SHELL_SCRIPTS)
	$(UV_RUN) shfmt -d $(SHELL_SCRIPTS)

# Prettier formats Markdown, YAML and JSON; markdownlint lints the Markdown.
doc-check: $(NODE_TOOLS) ## Check Markdown, YAML and JSON formatting, and lint Markdown
	$(PRETTIER) --check --log-level warn .
	$(MARKDOWNLINT)

$(GOLANGCI_LINT):
	@mkdir -p bin
	@set -e; v=$(GOLANGCI_LINT_VERSION:v%=%); \
	name=golangci-lint-$$v-$(OS)-$(GOLANGCI_ARCH); \
	sum=$(GOLANGCI_LINT_SHA256_$(OS)_$(GOLANGCI_ARCH)); \
	if [ -z "$$sum" ]; then echo "no pinned checksum for $$name" >&2; exit 1; fi; \
	tmp=$$(mktemp -d); trap 'rm -rf "$$tmp"' EXIT; \
	curl -fsSL -o "$$tmp/$$name.tar.gz" \
		"https://github.com/golangci/golangci-lint/releases/download/$(GOLANGCI_LINT_VERSION)/$$name.tar.gz"; \
	echo "$$sum  $$name.tar.gz" | (cd "$$tmp" && shasum -a 256 -c - >/dev/null); \
	tar -xzf "$$tmp/$$name.tar.gz" -C "$$tmp"; \
	mv "$$tmp/$$name/golangci-lint" $@
	@echo "installed $@"

node-tools:
	@if [ "$$(cat node_modules/.lock-sum 2>/dev/null)" != "$(NODE_LOCK_SUM)" ]; then \
		pnpm install --frozen-lockfile && echo "$(NODE_LOCK_SUM)" > node_modules/.lock-sum; \
	fi

# Skill evals run full Claude sessions on the logged-in credential: they draw
# on the plan's usage, or bill API credit if ANTHROPIC_API_KEY is set, so they
# are never part of the gate. Each model runs at its default effort. The cost
# cap is the evaluator's list-price estimate per model, not a bill. They run
# outside Claude Code's sandbox only: the evaluator starts a sandbox of its
# own. --scaffold runs each case's place-files.sh, written here; Edit and
# Write are granted so a case can check that /tutor never uses them and that
# /polish does. --allow-tools takes every word after it, so it goes last.
SKILL ?= tutor
EVAL_MODELS ?= claude-opus-5-5 claude-sonnet-5-5
EVAL_JUDGE_MODEL ?= claude-sonnet-5-5
EVAL_MAX_COST_USD ?= 10
# Extra flags, e.g. --keep-temp to read each run's workspace and trace
# afterwards, or --case <name> to run one case. Every model runs even when
# one falls short; the target fails at the end if any did.
EVAL_FLAGS ?=

eval: ## Run a skill's evals on each model (SKILL=tutor|polish); uses plan usage or API credit
	@test -d .claude/skills/$(SKILL)/evals || { echo ".claude/skills/$(SKILL) has no evals/ yet" >&2; exit 1; }
	@failed=; for model in $(EVAL_MODELS); do \
		echo "== $(SKILL) on $$model"; \
		DISABLE_AUTOUPDATER=1 claude plugin eval .claude/skills/$(SKILL) \
			--model $$model --judge-model $(EVAL_JUDGE_MODEL) --ablation none \
			--max-cost-usd $(EVAL_MAX_COST_USD) --no-publish --scaffold $(EVAL_FLAGS) \
			--allow-tools Edit Write || failed="$$failed $$model"; \
	done; \
	if [ -n "$$failed" ]; then echo "$(SKILL) fell short on:$$failed" >&2; exit 1; fi

print-%: ## Print a variable, e.g. make print-GOLANGCI_LINT
	@echo $($*)
