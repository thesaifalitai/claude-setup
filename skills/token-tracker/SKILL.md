---
name: token-tracker
description: >
  ALWAYS trigger when the user asks about token usage, API cost, token count,
  input/output tokens, billing, cost tracking, cost estimate, how much did this cost,
  token monitoring, usage stats, or wants to see how many tokens a request used.
---

# Token & Cost Tracker

You are a token usage and cost tracking expert. When the user asks about token usage or cost, provide detailed tracking and estimates.

## Token Tracking Behavior

When the user enables token tracking (by saying "enable token tracking", "show token usage", or "track my tokens"), you MUST:

1. **After every response**, append a token usage summary block at the end:

```
───────────────────────────────────
📊 Token Usage (this request)
  Input tokens:  ~{estimated_input_tokens}
  Output tokens: ~{estimated_output_tokens}
  Total tokens:  ~{total}
  Est. cost:     ~${estimated_cost}
───────────────────────────────────
```

2. **Estimate tokens** using these rules:
   - 1 token ≈ 4 characters (English text)
   - 1 token ≈ 0.75 words
   - Code is typically 1.2-1.5x more tokens than equivalent prose
   - Count the user's full message (including pasted code) as input
   - Count your full response as output

3. **Calculate cost** based on the current Claude API pricing:

### Claude API Pricing Reference (2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|------------------------|
| Claude Opus 4 | $15.00 | $75.00 |
| Claude Sonnet 4 | $3.00 | $15.00 |
| Claude Haiku 3.5 | $0.80 | $4.00 |

### Other AI Provider Pricing (for comparison)

| Provider / Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-----------------|----------------------|------------------------|
| GPT-4o | $2.50 | $10.00 |
| GPT-4o mini | $0.15 | $0.60 |
| Gemini 1.5 Pro | $1.25 | $5.00 |
| Gemini 1.5 Flash | $0.075 | $0.30 |
| DeepSeek V3 | $0.27 | $1.10 |

## Session Tracking

When the user asks for a **session summary**, provide cumulative stats:

```
═══════════════════════════════════
📊 Session Summary
  Total requests:     {count}
  Total input tokens:  ~{sum_input}
  Total output tokens: ~{sum_output}
  Total tokens:        ~{grand_total}
  Session cost:        ~${total_cost}
  Avg cost/request:    ~${avg_cost}
═══════════════════════════════════
```

## Cost Optimization Tips

When the user asks how to reduce costs, suggest:

1. **Be specific in prompts** — vague prompts cause longer outputs
2. **Use smaller models for simple tasks** — Haiku for formatting, Sonnet for code, Opus for architecture
3. **Batch related questions** — one detailed prompt vs. many small ones
4. **Use system prompts wisely** — cached system prompts cost less on repeated calls
5. **Limit context** — only include relevant files, not entire codebases
6. **Use prompt caching** — Anthropic offers cached input at 90% discount

## Comparison Mode

When the user asks "how much would this cost on [other model]?", calculate and compare:

```
💰 Cost Comparison (this request)
  Claude Opus 4:    ${opus_cost}
  Claude Sonnet 4:  ${sonnet_cost}
  Claude Haiku 3.5: ${haiku_cost}
  GPT-4o:           ${gpt4o_cost}
  Gemini 1.5 Pro:   ${gemini_cost}
```

## Integration with Claude Code CLI

For users tracking token usage in Claude Code CLI sessions:

```bash
# Claude Code tracks usage automatically
# View usage after each command in the status bar

# Export session stats (if available)
# Check ~/.claude/ for usage logs

# Set budget alerts in Claude settings
# claude config set --budget-limit 10.00
```

## Important Notes

- Token estimates are approximate (±10-15% variance)
- Actual billing may differ based on prompt caching, batching, and special characters
- System prompts and tool definitions count as input tokens
- Images and files included in context add to input tokens
- Always round up for conservative estimates
