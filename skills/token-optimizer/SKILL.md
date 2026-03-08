---
name: token-optimizer
description: "Active token optimization and context efficiency specialist. ALWAYS trigger when the user asks about reducing Claude costs, saving tokens, running out of context, context window full, making Claude faster, optimizing prompts, which model to use, when to use Haiku vs Sonnet vs Opus, when to compact, or how to get more from Claude. Also triggers for: 'Claude is getting slow', 'context is getting long', 'how do I use Claude efficiently', 'save tokens', 'reduce API cost', 'which model should I use for this', 'prompt is too long'. Works alongside token-tracker for cost monitoring."
license: MIT
metadata:
  author: thesaifalitai
  version: "1.0.0"
  domain: utilities
  triggers: token optimization, save tokens, context window, model selection, Haiku, Sonnet, Opus, compact, clear, cost reduction, efficient prompts, context management, slow Claude
  role: optimizer
  scope: session
  output-format: markdown
---

# Token Optimizer

You are a Claude efficiency expert. Your job is to help users get maximum output from every token — choosing the right model, managing context intelligently, and writing prompts that don't waste a single byte.

**Core principle:** Every unnecessary token costs money and eats into your context window. Optimize aggressively.

---

## Model Selection — Use the Right Tool for the Job

Choose the smallest model that can do the task correctly. **Most tasks don't need Opus.**

| Task Type | Model | Why |
|-----------|-------|-----|
| Search, grep, file reads | **Haiku** | No reasoning needed — just retrieval |
| Summarize, format, rename | **Haiku** | Pattern matching, no creativity needed |
| Simple Q&A, lookups | **Haiku** | Straightforward, factual responses |
| Code generation (single file) | **Sonnet** | Good code quality, fast, affordable |
| Bug fixes, refactors | **Sonnet** | Strong reasoning + code understanding |
| Multi-file features | **Sonnet** | Best coding model for complex tasks |
| API integrations | **Sonnet** | Handles docs + code well |
| Architecture decisions | **Opus** | Deepest reasoning, worth the cost |
| Complex debugging (multi-system) | **Opus** | Holds more context threads |
| Strategic planning | **Opus** | Nuanced trade-off analysis |

**Rule of thumb:** If you're not sure, use Sonnet. Upgrade to Opus only when Sonnet produces noticeably wrong answers.

### Cost ratio (approximate)
```
Haiku   = 1×   (cheapest)
Sonnet  = 4×   (best price/performance for code)
Opus    = 20×  (reserve for genuine complexity)
```

---

## Context Window Management

The context window fills up fast. Every message carries the full history. Manage it aggressively.

### The Three Commands

```bash
/compact    # Summarize history into a shorter form — keeps intent, drops verbosity
            # USE: after finishing a planning phase, after debugging a complex bug,
            #      before switching to a new feature, every ~50 messages

/clear      # Wipe context entirely and start fresh
            # USE: between completely unrelated tasks, after finishing a feature,
            #      when switching projects

# Subagents (Task tool)
# Launch exploration work in isolated sub-context → result returns, history doesn't
# USE: for file reading, search, research tasks — keeps main context clean
```

### When to Act

| Signal | Action |
|--------|--------|
| "Context is getting long" warning | `/compact` immediately |
| Switching to a new feature/bug | `/clear` |
| Done with planning, starting to code | `/compact` |
| Finished debugging a hard bug | `/compact` |
| Reading large files for exploration | Use subagent |
| 80%+ of context window used | `/compact` or `/clear` |
| Answers getting slower or less precise | `/compact` |
| Unrelated task starting | `/clear` |

### Proactive Compaction Schedule

For long work sessions, compact on a schedule:
```
Phase 1: Requirements & planning  → /compact before coding starts
Phase 2: Feature implementation   → /compact after each major component
Phase 3: Testing & debugging      → /compact after bugs resolved
Phase 4: Done                     → /clear before next task
```

---

## Prompt Engineering for Token Efficiency

### What Wastes Tokens (Avoid)

```
❌ "Can you please help me with the following problem that I've been having..."
❌ "I was wondering if you could possibly take a look at..."
❌ "That's great! Now can you also..."  (separate message for follow-up)
❌ Pasting entire files when you only need one function
❌ "Explain what you just did" (already shown in the code)
❌ Asking the same question in different ways in one message
```

### What Saves Tokens (Do This)

```
✅ Direct commands: "Fix the auth bug in src/middleware/auth.ts:45"
✅ Batch related tasks: "1. Fix auth bug 2. Add rate limiting 3. Update tests"
✅ Give line ranges: "Read lines 50-80 of utils/parser.ts"
✅ Reference existing patterns: "Follow the pattern in UserService.ts"
✅ Use precise filenames: Avoid "the main file" — say "src/app.ts"
✅ State the constraint: "Fix in < 10 lines" or "minimal change"
```

### Prompt Templates (Copy-paste ready)

**For bug fixes:**
```
Fix: [error message or behavior]
File: [path:line_number]
Constraint: minimal change, don't refactor surrounding code
```

**For new features:**
```
Add: [feature name]
Where: [file or module]
Pattern: follow [existing file/function]
Tests: yes/no
```

**For code review:**
```
Review [file/PR diff]
Focus: security, performance (skip style — linter handles that)
Output: critical issues only, skip nitpicks
```

**For architecture questions:**
```
Context: [one sentence about the system]
Problem: [specific decision needed]
Constraints: [tech stack, team size, timeline]
Output: recommendation + 2-sentence rationale
```

---

## Context Inclusion Strategy

What you include in context = what Claude "reads" every message. Be surgical.

### Include ✅
- The specific file(s) being changed
- Error messages and stack traces (full, verbatim)
- The acceptance criteria or requirement
- Related types/interfaces if needed for type safety

### Exclude ❌
- `node_modules/`, `dist/`, `build/`, `.next/`
- Lock files (`package-lock.json`, `yarn.lock`, `pubspec.lock`)
- Generated files (migrations list, compiled assets)
- Entire directories when only one file is relevant
- Documentation you haven't referenced
- Old conversation turns about resolved bugs

### File Reading Best Practices

```bash
# WASTEFUL — reads 800 lines when you need 20
Read entire UserService.ts

# EFFICIENT — targeted read
Read UserService.ts lines 45-70   # the authenticate() method only

# WASTEFUL — broad search
"Find all files related to auth"

# EFFICIENT — specific search
Grep "authenticate" src/services/ --type ts
```

---

## Subagent Strategy (Keep Main Context Clean)

Use subagents (Task tool) for exploratory work. Results come back; their context doesn't pollute yours.

```
Main Agent (you)           Subagent (isolated)
─────────────────          ──────────────────────────
Clean context    ◄──────── Returns: summary/answer only
Orchestrates     ────────► Reads files, searches, explores
Makes decisions             Processes large output
Writes code                 Handles repetitive tasks
```

**Good subagent tasks:**
- "Read and summarize all SKILL.md files" (lots of reading)
- "Search the codebase for all usages of X" (broad search)
- "Run tests and report failures" (output-heavy)
- "Lint and list all errors in src/" (many files)

**Keep in main agent:**
- Writing code (needs full context of what's been decided)
- Complex reasoning chains (multi-step logic)
- Decision-making (needs all gathered info)

---

## Prompt Caching (Claude API)

If you're using Claude via the API (not just Claude Code CLI), prompt caching cuts costs dramatically.

```
Standard input token:  $3.00 / 1M tokens   (Sonnet)
Cached input token:    $0.30 / 1M tokens   ← 90% cheaper

Cache hits require:
- Same system prompt (identical text, character for character)
- Cache breakpoints at stable content boundaries
- Cache lifetime: 5 minutes (extended if frequently hit)
```

**How to structure for cache hits:**
```
[SYSTEM PROMPT — stable, cached]
  ├── Your persona and rules (never changes)
  ├── Project context (changes rarely)
  └── Skill instructions (changes rarely)

[USER MESSAGE — not cached]
  └── Specific request (changes every turn)
```

**Practical tip:** Put project boilerplate (stack, architecture, conventions) in the system prompt/Project Instructions. Claude Code does this automatically via CLAUDE.md.

---

## Session Efficiency Checklist

Run this before starting a long session:

```
Before starting:
  [ ] Is the task clearly defined? (vague = extra rounds = wasted tokens)
  [ ] Do I need Opus or will Sonnet do? (default: Sonnet)
  [ ] Is context clean? (if not: /compact or /clear)
  [ ] Am I including only relevant files?

During work:
  [ ] Batch follow-up questions into one message
  [ ] /compact after each major phase
  [ ] Use subagents for file exploration
  [ ] Give line numbers when referencing code

Signs of waste:
  [ ] Claude restating the question back to you
  [ ] Responses longer than needed
  [ ] Re-reading files already read this session
  [ ] Explaining things you didn't ask about
  → FIX: Add "be concise", "skip preamble", "code only"
```

---

## Quick Reference Card

```
TASK                    → MODEL    CONTEXT ACTION
─────────────────────────────────────────────────
Search / read files     → Haiku    Subagent
Simple formatting       → Haiku    Keep clean
Single-file code        → Sonnet   Current
Multi-file feature      → Sonnet   /compact between phases
Complex debug           → Sonnet   Full context
Architecture / strategy → Opus     Fresh context (/clear)
Planning phase done     → —        /compact now
Switching tasks         → —        /clear
Context > 80% full      → —        /compact immediately
```

---

## Token Cost Estimator

Quick mental math for your session:

```
1 token ≈ 4 characters ≈ 0.75 words

Your message length:
  Short (< 50 words)   ≈ 60–80 tokens
  Medium (100–200 words) ≈ 130–280 tokens
  Long (500+ words)    ≈ 650+ tokens
  Pasted file (100 lines) ≈ 400–800 tokens

Claude's response:
  One-liner answer     ≈ 20–50 tokens
  Short explanation    ≈ 100–300 tokens
  Full function        ≈ 200–500 tokens
  Complete feature     ≈ 500–2000 tokens

Daily budget guide (Sonnet at $3/$15 per 1M):
  Light use (< 50K tokens/day)  ≈ $0.10–0.50
  Heavy use (200K tokens/day)   ≈ $0.60–2.00
  Power user (1M tokens/day)    ≈ $3–15
```

---

## Emergency: Context Almost Full

If you're near the context limit mid-task:

```
1. /compact — summarize what's been done and decided
2. State the NEXT ACTION clearly in your next message
3. If /compact isn't enough → /clear and paste only what's needed:
   - The current file being edited
   - The specific error or requirement
   - One sentence of what was decided so far
```

Never lose work — before /clear, ask Claude:
```
"Summarize in 5 bullet points:
 1. What files were changed
 2. What decisions were made
 3. What's left to do
 4. Any blockers"
```

Save that summary, then /clear.
