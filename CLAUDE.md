# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A zero-dependency CLI that automates configuring Claude Code to use Amazon Bedrock as its backend. Users run a one-liner (`curl ... | sh`) which downloads `install.sh`, which then downloads and executes `src/setup.js`.

## Distribution

- **npm package**: published to GitHub Packages as `@huyjack178/claude-bedrock-setup`, entry point `bin/cli.js`
- **curl installer**: `install.sh` downloads `src/setup.js` directly from GitHub raw URLs and runs it with Node.js
- **CI/CD**: pushing to `main` auto-bumps the patch version, commits, tags, and creates a GitHub release (see [`.github/workflows/publish.yml`](.github/workflows/publish.yml))

Because the repo is **private**, the raw GitHub URL used in `install.sh` requires authentication — this is the known open issue with the curl install path.

## Key files

- [`install.sh`](install.sh) — shell entry point for the curl-pipe install; checks Node ≥18, downloads `src/setup.js` to a temp `.mjs` file, runs it with stdin from `/dev/tty`
- [`src/setup.js`](src/setup.js) — all interactive setup logic (interactive mode)
- [`bin/cli.js`](bin/cli.js) — npm CLI entry; routes to `src/setup.js` (interactive) or `src/setup-auto.js` (non-interactive via `--yes`/`-y`/`--auto` flags) — **`src/setup-auto.js` does not exist yet**

## Setup flow (src/setup.js)

1. Checks `claude` CLI is installed and warns if below v2.1.94
2. Prompts for AWS region (default `us-east-1`)
3. Reads existing Bedrock API key from `~/.claude/settings.json` or `$AWS_BEARER_TOKEN_BEDROCK`; allows replacing it
4. Writes merged settings to `~/.claude/settings.json` with `CLAUDE_CODE_USE_BEDROCK=1`, region, model IDs (region-prefixed `us`/`eu`/`ap`)
5. Appends exports to shell profile (`.zshrc`, `.bashrc`, or `config.fish`) using `# Claude Code + Amazon Bedrock` as an idempotency marker
6. Optionally runs a smoke test (`claude --print "Reply with exactly one word: ready"`)
7. Optionally sets up CloudWatch invocation logging via AWS CLI (only offered when no API key — IAM/SSO path)

## No build, lint, or test setup

There are no npm scripts, no test framework, no linter, and no TypeScript. The project is plain ESM JavaScript (`"type": "module"` in package.json). Node.js stdlib only — no runtime dependencies.

To run the setup interactively during development:
```sh
node src/setup.js
```

To test the CLI entry point:
```sh
node bin/cli.js
node bin/cli.js --yes   # would invoke src/setup-auto.js (not yet implemented)
```
