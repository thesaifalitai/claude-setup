---
name: ai-integration
description: >
  ALWAYS trigger for ANY task involving AI integration, OpenAI API, Anthropic API,
  Claude API, GPT, embeddings, RAG (Retrieval Augmented Generation), vector databases,
  LangChain, AI SDK (Vercel), text generation, chat completions, streaming responses,
  prompt engineering, function calling, tool use, AI agents, semantic search,
  Pinecone, ChromaDB, pgvector, or any LLM-related development task.
---

# AI Integration Expert

You are a senior AI engineer who integrates LLMs into production applications. You build reliable AI features with proper streaming, error handling, caching, and cost management.

## Core Principles

1. **Stream Everything** — Never block the UI waiting for a full response. Stream tokens.
2. **Anthropic First** — Default to Claude (Anthropic) API. Fall back to OpenAI only when specified.
3. **RAG Over Fine-tuning** — Use retrieval augmented generation before considering fine-tuning.
4. **Cost Control** — Track token usage, cache responses, use the cheapest model that works.
5. **Structured Output** — Use tool_use (Claude) or function_calling (OpenAI) for reliable structured data.

## Vercel AI SDK (Recommended for Web)

```bash
npm install ai @ai-sdk/anthropic @ai-sdk/openai
```

```typescript
// app/api/chat/route.ts — Streaming chat with Claude
import { anthropic } from '@ai-sdk/anthropic';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: anthropic('claude-sonnet-4-20250514'),
    system: 'You are a helpful coding assistant. Be concise.',
    messages,
    maxTokens: 4096,
  });

  return result.toDataStreamResponse();
}

// components/Chat.tsx — Client component
'use client';
import { useChat } from 'ai/react';

export function Chat() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat({
    api: '/api/chat',
  });

  return (
    <div>
      {messages.map((m) => (
        <div key={m.id} className={m.role === 'user' ? 'text-right' : 'text-left'}>
          <p>{m.content}</p>
        </div>
      ))}
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} disabled={isLoading} />
      </form>
    </div>
  );
}
```

## Anthropic SDK (Direct)

```typescript
// lib/anthropic.ts
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

// Simple completion
export async function generateText(prompt: string): Promise<string> {
  const message = await client.messages.create({
    model: 'claude-sonnet-4-20250514',
    max_tokens: 1024,
    messages: [{ role: 'user', content: prompt }],
  });

  return message.content[0].type === 'text' ? message.content[0].text : '';
}

// Streaming
export async function streamText(prompt: string) {
  return client.messages.stream({
    model: 'claude-sonnet-4-20250514',
    max_tokens: 4096,
    messages: [{ role: 'user', content: prompt }],
  });
}

// Tool Use (Structured Output)
export async function extractData(text: string) {
  const response = await client.messages.create({
    model: 'claude-sonnet-4-20250514',
    max_tokens: 1024,
    tools: [{
      name: 'extract_contact',
      description: 'Extract contact information from text',
      input_schema: {
        type: 'object' as const,
        properties: {
          name: { type: 'string', description: 'Full name' },
          email: { type: 'string', description: 'Email address' },
          phone: { type: 'string', description: 'Phone number' },
          company: { type: 'string', description: 'Company name' },
        },
        required: ['name'],
      },
    }],
    messages: [{ role: 'user', content: `Extract contact info: ${text}` }],
  });

  const toolBlock = response.content.find((b) => b.type === 'tool_use');
  return toolBlock?.type === 'tool_use' ? toolBlock.input : null;
}
```

## RAG (Retrieval Augmented Generation)

```typescript
// lib/rag.ts — Using pgvector with Prisma
import { db } from '@/lib/db';
import { generateEmbedding } from './embeddings';

// Store document with embedding
export async function indexDocument(content: string, metadata: Record<string, string>) {
  const embedding = await generateEmbedding(content);

  await db.$executeRaw`
    INSERT INTO documents (content, metadata, embedding)
    VALUES (${content}, ${JSON.stringify(metadata)}::jsonb, ${embedding}::vector)
  `;
}

// Semantic search
export async function searchDocuments(query: string, limit: number = 5) {
  const queryEmbedding = await generateEmbedding(query);

  const results = await db.$queryRaw`
    SELECT content, metadata,
           1 - (embedding <=> ${queryEmbedding}::vector) as similarity
    FROM documents
    WHERE 1 - (embedding <=> ${queryEmbedding}::vector) > 0.7
    ORDER BY embedding <=> ${queryEmbedding}::vector
    LIMIT ${limit}
  `;

  return results;
}

// RAG chat
export async function ragChat(question: string) {
  const context = await searchDocuments(question, 3);
  const contextText = context.map((d: { content: string }) => d.content).join('\n\n');

  const response = await client.messages.create({
    model: 'claude-sonnet-4-20250514',
    max_tokens: 2048,
    system: `Answer based on this context. If the context doesn't contain the answer, say so.\n\nContext:\n${contextText}`,
    messages: [{ role: 'user', content: question }],
  });

  return {
    answer: response.content[0].type === 'text' ? response.content[0].text : '',
    sources: context,
    tokensUsed: response.usage,
  };
}
```

## Embeddings

```typescript
// lib/embeddings.ts
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic();

// Use Voyage AI (Anthropic's recommended embedding model)
export async function generateEmbedding(text: string): Promise<number[]> {
  const response = await fetch('https://api.voyageai.com/v1/embeddings', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.VOYAGE_API_KEY}`,
    },
    body: JSON.stringify({
      input: text,
      model: 'voyage-3',
    }),
  });

  const data = await response.json();
  return data.data[0].embedding;
}
```

## Cost Tracking Middleware

```typescript
// middleware/ai-cost-tracker.ts
interface TokenUsage {
  inputTokens: number;
  outputTokens: number;
  model: string;
  costUsd: number;
}

const MODEL_PRICING: Record<string, { input: number; output: number }> = {
  'claude-opus-4-20250514': { input: 15.0, output: 75.0 },
  'claude-sonnet-4-20250514': { input: 3.0, output: 15.0 },
  'claude-haiku-4-5-20251001': { input: 0.80, output: 4.0 },
};

export function calculateCost(usage: { input_tokens: number; output_tokens: number }, model: string): number {
  const pricing = MODEL_PRICING[model] ?? MODEL_PRICING['claude-sonnet-4-20250514'];
  return (usage.input_tokens / 1_000_000 * pricing.input) + (usage.output_tokens / 1_000_000 * pricing.output);
}
```

## Checklist

- [ ] API keys in environment variables, never hardcoded
- [ ] Streaming enabled for all user-facing AI responses
- [ ] Token usage tracked and logged per request
- [ ] Rate limiting on AI endpoints
- [ ] Fallback model configured (e.g., Haiku for non-critical tasks)
- [ ] Response caching for repeated queries
- [ ] Input validation/sanitization before sending to LLM
- [ ] Error handling for API rate limits (429) and timeouts
- [ ] Cost alerts configured for billing thresholds
- [ ] System prompts version-controlled, not hardcoded in handlers
