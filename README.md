# claude-code-bedrock-setup

One-command CLI to configure [Claude Code](https://claude.ai/code) to use a custom API Gateway (e.g. LiteLLM proxy in front of Amazon Bedrock).

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/atwarevn/claude-code-bedrock-setup/refs/heads/main/install.sh | sh
```
- Input proxy url: https://proxy.heyalice.net
- Input the API key that admin provide you: api_key
No installation required — just run the command above. Node.js ≥ 18 must be installed on your machine.

## Cleanup

To remove all gateway configuration from `~/.claude/settings.json` and your shell profile:

```bash
curl -fsSL https://raw.githubusercontent.com/atwarevn/claude-code-bedrock-setup/refs/heads/main/cleanup.sh | sh
```

Or if you installed via npm:

```bash
claude-bedrock-setup --cleanup
```

## What setup does

1. Checks Claude Code CLI is installed (≥ v2.1.94)
2. Asks for the gateway base URL (default: `http://localhost:4000`)
3. Prompts for auth — either a static token (`ANTHROPIC_AUTH_TOKEN`) or a helper script path for rotating keys (`apiKeyHelper`)
4. Writes `~/.claude/settings.json` with gateway env vars and pinned model IDs
5. Adds environment variable exports to your shell profile (`.zshrc`, `.bashrc`, or `config.fish`)
6. Optionally runs a smoke test to confirm the gateway connection works

## What cleanup does

1. Removes all gateway and Bedrock env keys from `~/.claude/settings.json`
2. Removes the `apiKeyHelper` field from `~/.claude/settings.json`
3. Strips the exported block from `.zshrc`, `.bashrc`, and `config.fish` (whichever exist)

## Prerequisites

| Requirement | Notes |
|---|---|
| [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) v2.1.94+ | `npm install -g @anthropic-ai/claude-code` |
| Node.js ≥ 18 | Required to run this CLI |
| API Gateway | e.g. LiteLLM proxy — must be running and reachable |

## Settings written

After setup, `~/.claude/settings.json` will contain:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "ANTHROPIC_AUTH_TOKEN": "<your-token>",
    "CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS": "1",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-4-6",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4-5",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-4-5"
  }
}
```

When using a key helper script instead of a static token, `ANTHROPIC_AUTH_TOKEN` is replaced with:

```json
{
  "apiKeyHelper": "~/bin/get-litellm-key.sh"
}
```

## npm usage

```bash
npx @huyjack178/claude-bedrock-setup          # interactive setup
npx @huyjack178/claude-bedrock-setup --cleanup # remove all config
```

## References

- [Claude Code custom API](https://docs.anthropic.com/en/docs/claude-code)
- [LiteLLM proxy](https://docs.litellm.ai/docs/proxy/quick_start)
- [Claude Code on Amazon Bedrock](https://code.claude.com/docs/en/amazon-bedrock)
