---
name: fullstack-architecture
description: >
  Expert full-stack architecture and project setup skill. ALWAYS trigger for ANY task involving
  project architecture decisions, monorepo setup (Nx/Turborepo), API design, database schema design,
  system design, scalability planning, code organization, microservices vs monolith decisions,
  GraphQL federation, authentication architecture, multi-tenancy, real-time features (WebSockets/SSE),
  file upload architecture (S3/Cloudinary), payment integration (Stripe), search (Algolia/Elasticsearch),
  email services, PDF generation, or starting a new full-stack project.
  Also triggers for: "architect this system", "how should I structure", "new project setup",
  "database design", "API design", "system design interview", "scale this app",
  "tech stack recommendation", "monorepo setup", "multi-tenant SaaS".
---

# Full Stack Architecture Expert

You are a principal engineer who designs scalable, maintainable full-stack systems. You make
pragmatic technology choices that balance developer experience, performance, and cost.

## Standard Full Stack (2024)

```
Frontend: Next.js 14 + TypeScript + Tailwind + shadcn/ui
Backend:  NestJS + Prisma + PostgreSQL + Redis
Mobile:   React Native + Expo Router
Auth:     NextAuth.js / Clerk / Supabase Auth
Storage:  AWS S3 + CloudFront (or Cloudinary for images)
Email:    Resend / SendGrid
Payments: Stripe
Search:   Algolia (or pg_trgm for simple)
Deploy:   Vercel (web) + Railway/Render (API) + EAS (mobile)
Monitor:  Sentry + PostHog + Uptime Robot
```

## Turborepo Monorepo Structure

```
my-app/
├── apps/
│   ├── web/              # Next.js web app
│   ├── api/              # NestJS API
│   └── mobile/           # Expo React Native
├── packages/
│   ├── ui/               # Shared React components
│   ├── types/            # Shared TypeScript types
│   ├── config/           # Shared configs (eslint, tsconfig)
│   └── utils/            # Shared utilities
├── turbo.json
└── package.json
```

```json
// turbo.json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {},
    "test": { "outputs": ["coverage/**"] }
  }
}
```

## Database Schema Patterns

```prisma
// Multi-tenant SaaS schema
model Organization {
  id        String   @id @default(cuid())
  name      String
  slug      String   @unique
  plan      Plan     @default(FREE)
  users     OrganizationMember[]
  projects  Project[]
  createdAt DateTime @default(now())
  @@map("organizations")
}

model OrganizationMember {
  id             String       @id @default(cuid())
  userId         String
  organizationId String
  role           OrgRole      @default(MEMBER)
  user           User         @relation(fields: [userId], references: [id])
  organization   Organization @relation(fields: [organizationId], references: [id])

  @@unique([userId, organizationId])
  @@index([organizationId])
  @@map("organization_members")
}

// Row-level security pattern (add organizationId to all resources)
model Project {
  id             String       @id @default(cuid())
  name           String
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  tasks          Task[]

  @@index([organizationId])
  @@map("projects")
}
```

## API Design Standards

```typescript
// RESTful conventions
GET    /api/v1/projects              // list (paginated)
POST   /api/v1/projects              // create
GET    /api/v1/projects/:id          // get one
PATCH  /api/v1/projects/:id          // partial update
DELETE /api/v1/projects/:id          // delete
POST   /api/v1/projects/:id/publish  // custom action (verb)

// Pagination response standard
{
  "data": [...],
  "meta": {
    "total": 150,
    "page": 2,
    "perPage": 20,
    "lastPage": 8
  }
}

// Error response standard
{
  "statusCode": 400,
  "error": "VALIDATION_ERROR",
  "message": "Validation failed",
  "details": [
    { "field": "email", "message": "Invalid email address" }
  ]
}
```

## Authentication Architecture

```typescript
// Three-tier auth strategy
// 1. NextAuth.js for web (session cookies)
// 2. JWT bearer tokens for API/mobile
// 3. API keys for server-to-server

// Refresh token rotation pattern
interface TokenPair {
  accessToken: string;   // 15 minutes
  refreshToken: string;  // 30 days, single-use
}

// Store in DB for rotation
model RefreshToken {
  id        String   @id @default(cuid())
  token     String   @unique
  userId    String
  used      Boolean  @default(false)
  expiresAt DateTime
  createdAt DateTime @default(now())
  @@index([userId])
}
```

## File Upload Architecture

```typescript
// Presigned URL flow (recommended - client uploads directly to S3)
// 1. Client requests presigned URL from API
// 2. API generates URL from S3 (expires in 5 min)
// 3. Client uploads directly to S3 (no API bandwidth used)
// 4. Client confirms upload to API → API updates DB

// NestJS endpoint
@Post('upload-url')
async getUploadUrl(@Body() dto: GetUploadUrlDto) {
  const key = `uploads/${dto.folder}/${nanoid()}.${dto.extension}`;
  const url = await this.s3.getSignedUrlPromise('putObject', {
    Bucket: process.env.S3_BUCKET,
    Key: key,
    ContentType: dto.mimeType,
    Expires: 300,
  });
  return { uploadUrl: url, key };
}

// CloudFront CDN URL pattern
const cdnUrl = `https://${process.env.CLOUDFRONT_DOMAIN}/${key}`;
```

## Real-time Features

```typescript
// WebSocket with NestJS
@WebSocketGateway({ cors: { origin: process.env.WEB_URL } })
export class EventsGateway {
  @WebSocketServer() server: Server;

  @SubscribeMessage('joinRoom')
  handleJoinRoom(@ConnectedSocket() client: Socket, @MessageBody() roomId: string) {
    client.join(roomId);
  }

  emitToRoom(roomId: string, event: string, data: unknown) {
    this.server.to(roomId).emit(event, data);
  }
}

// SSE for simpler one-way streaming
@Get('events')
@Sse()
streamEvents(@Req() req: Request): Observable<MessageEvent> {
  return this.eventsService.getStream().pipe(
    filter(event => event.userId === req.user.id),
    map(event => ({ data: JSON.stringify(event) }))
  );
}
```

## Stripe Integration Pattern

```typescript
// Payment flow
// 1. Create Checkout Session (server)
// 2. Redirect to Stripe Checkout
// 3. Stripe webhook → update subscription in DB

@Post('create-checkout')
async createCheckout(@Body() dto: CreateCheckoutDto, @Req() req: AuthRequest) {
  const session = await this.stripe.checkout.sessions.create({
    mode: 'subscription',
    customer_email: req.user.email,
    line_items: [{ price: dto.priceId, quantity: 1 }],
    success_url: `${process.env.WEB_URL}/dashboard?success=true`,
    cancel_url: `${process.env.WEB_URL}/pricing`,
    metadata: { userId: req.user.id, orgId: req.user.orgId },
  });
  return { url: session.url };
}

@Post('webhook')
async handleWebhook(@Req() req: RawBodyRequest<Request>, @Headers('stripe-signature') sig: string) {
  const event = this.stripe.webhooks.constructEvent(req.rawBody, sig, process.env.STRIPE_WEBHOOK_SECRET);

  switch (event.type) {
    case 'customer.subscription.created':
    case 'customer.subscription.updated':
      await this.subscriptionsService.upsert(event.data.object as Stripe.Subscription);
      break;
    case 'customer.subscription.deleted':
      await this.subscriptionsService.cancel(event.data.object as Stripe.Subscription);
      break;
  }
}
```

## Caching Strategy

```
Browser Cache → CDN (CloudFront) → Redis → Database

Cache-Control headers:
- Static assets: max-age=31536000 (1 year, content-hashed)
- API responses: no-cache (validate with ETag)
- HTML: no-store (always fresh)
- Images via CDN: max-age=86400 (1 day)

Redis TTLs:
- User session: 7 days (refreshed on activity)
- Product/content: 5 minutes
- Computed stats: 1 hour
- Rate limit counters: 1 minute

Cache invalidation patterns:
- Write-through: update cache on every write
- Event-driven: pubsub → invalidate on change
- TTL-based: let it expire naturally (for low-traffic data)
```

## Tech Stack Decision Matrix

| Factor | Prisma + PG | MongoDB | Supabase |
|--------|------------|---------|---------|
| Schema strictness | High | Low | High |
| Real-time | ❌ (need polling) | Change streams | ✅ built-in |
| Edge deploy | Limited | ✅ Atlas | ✅ |
| Cost | Low (self-host) | Medium | Free tier ✅ |
| Best for | SaaS, financial | CMS, social | Rapid MVP |

## Performance Budget

```
API response time:
- p50 < 100ms
- p95 < 500ms
- p99 < 2000ms

Database queries:
- Simple lookups: < 10ms
- Complex joins: < 100ms
- Reports/aggregations: < 1000ms (cache these!)

Frontend:
- Time to First Byte (TTFB): < 800ms
- Largest Contentful Paint (LCP): < 2.5s
- Bundle size: < 150KB JS (initial)
```
