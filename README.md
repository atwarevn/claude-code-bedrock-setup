# claude-bedrock-setup

One-command CLI to configure [Claude Code](https://claude.ai/code) with [Amazon Bedrock](https://aws.amazon.com/bedrock/).

## Usage

```bash
npx @huyjack178/claude-bedrock-setup
```

Or install globally:

```bash
npm install -g @huyjack178/claude-bedrock-setup
claude-bedrock-setup
```

> **Note:** This package is hosted on GitHub Packages. Add the following to your `~/.npmrc` before installing:
> ```
> @huyjack178:registry=https://npm.pkg.github.com
> ```

## What it does

1. Checks Claude Code CLI is installed (≥ v2.1.94)
2. Asks for your preferred AWS region (default: `us-east-1`)
3. Prompts for a Bedrock API key
4. Writes `~/.claude/settings.json` with Bedrock enabled and models pinned
5. Optionally runs a smoke test to confirm the connection works
6. Optionally enables CloudWatch invocation logging for usage monitoring

## Prerequisites

| Requirement | Notes |
|---|---|
| [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) v2.1.94+ | `npm install -g @anthropic-ai/claude-code` |
| AWS account with Bedrock access | Enable Anthropic models in the [Model catalog](https://console.aws.amazon.com/bedrock/) |
| Node.js ≥ 18 | Required to run this CLI |

## Settings written

After setup, `~/.claude/settings.json` will contain:

```json
{
  "env": {
    "CLAUDE_CODE_USE_BEDROCK": "1",
    "AWS_REGION": "us-east-1",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "us.anthropic.claude-sonnet-4-6",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "us.anthropic.claude-haiku-4-5-20251001-v1:0",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "us.anthropic.claude-opus-4-7"
  }
}
```

## Monitoring

During setup you can opt in to **Bedrock model invocation logging**. This creates:

- An IAM role (`BedrockInvocationLoggingRole`) that Bedrock uses to write logs
- A CloudWatch log group `/aws/bedrock/model-invocations` with token counts, latency, and model ID per request

Once enabled, use **CloudWatch Metrics** (namespace `AWS/Bedrock`) to track usage and costs. Bedrock spend also appears in **AWS Cost Explorer** under service `Amazon Bedrock`.

## References

- [Claude Code on Amazon Bedrock](https://code.claude.com/docs/en/amazon-bedrock)
- [Bedrock inference profiles](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html)
