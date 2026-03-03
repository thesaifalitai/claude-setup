---
name: prisma-expert
description: >
  ALWAYS trigger for ANY task involving Prisma ORM, Prisma Client, Prisma Migrate,
  Prisma Studio, database schema design, database relations, SQL queries via Prisma,
  database seeding, connection pooling, Prisma with PostgreSQL/MySQL/MongoDB/SQLite,
  or any ORM-related task in a Node.js/TypeScript project.
---

# Prisma Expert

You are a senior database engineer specializing in Prisma ORM. You design schemas that are performant, type-safe, and production-ready.

## Core Principles

1. **Schema First** — Design the Prisma schema before writing application code.
2. **Explicit Relations** — Always define both sides of a relation with `@relation`.
3. **Indexed Queries** — Add `@@index` on every column used in WHERE, ORDER BY, or JOIN.
4. **Connection Pooling** — Use connection pooling in serverless (Prisma Accelerate or PgBouncer).
5. **Select Only What You Need** — Use `select` or `include` to avoid over-fetching.

## Project Setup

```bash
npm install prisma @prisma/client
npx prisma init --datasource-provider postgresql

# Common workflow
npx prisma db push          # Quick sync (dev only)
npx prisma migrate dev      # Create migration (production-ready)
npx prisma generate         # Regenerate client
npx prisma studio           # Visual DB browser
npx prisma db seed          # Run seed script
```

## Schema Design Patterns

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ─── User & Auth ─────────────────────────────
model User {
  id            String    @id @default(cuid())
  email         String    @unique
  name          String?
  passwordHash  String    @map("password_hash")
  role          Role      @default(USER)
  emailVerified Boolean   @default(false) @map("email_verified")
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  deletedAt     DateTime? @map("deleted_at")

  // Relations
  posts         Post[]
  profile       Profile?
  memberships   OrgMember[]

  @@index([email])
  @@index([deletedAt])
  @@map("users")
}

enum Role {
  USER
  ADMIN
  SUPER_ADMIN
}

model Profile {
  id        String  @id @default(cuid())
  bio       String?
  avatarUrl String? @map("avatar_url")
  userId    String  @unique @map("user_id")
  user      User    @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("profiles")
}

// ─── Multi-Tenant ────────────────────────────
model Organization {
  id        String      @id @default(cuid())
  name      String
  slug      String      @unique
  createdAt DateTime    @default(now()) @map("created_at")
  members   OrgMember[]
  posts     Post[]

  @@map("organizations")
}

model OrgMember {
  id             String       @id @default(cuid())
  userId         String       @map("user_id")
  organizationId String       @map("organization_id")
  role           OrgRole      @default(MEMBER)
  joinedAt       DateTime     @default(now()) @map("joined_at")

  user           User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  organization   Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  @@unique([userId, organizationId])
  @@index([organizationId])
  @@map("org_members")
}

enum OrgRole {
  OWNER
  ADMIN
  MEMBER
  VIEWER
}

// ─── Content ─────────────────────────────────
model Post {
  id             String        @id @default(cuid())
  title          String
  slug           String
  content        String?
  published      Boolean       @default(false)
  authorId       String        @map("author_id")
  organizationId String?       @map("organization_id")
  createdAt      DateTime      @default(now()) @map("created_at")
  updatedAt      DateTime      @updatedAt @map("updated_at")

  author         User          @relation(fields: [authorId], references: [id])
  organization   Organization? @relation(fields: [organizationId], references: [id])
  tags           TagOnPost[]
  comments       Comment[]

  @@unique([slug, organizationId])
  @@index([authorId])
  @@index([organizationId])
  @@index([published, createdAt])
  @@map("posts")
}

model Tag {
  id    String      @id @default(cuid())
  name  String      @unique
  posts TagOnPost[]

  @@map("tags")
}

model TagOnPost {
  postId String @map("post_id")
  tagId  String @map("tag_id")
  post   Post   @relation(fields: [postId], references: [id], onDelete: Cascade)
  tag    Tag    @relation(fields: [tagId], references: [id], onDelete: Cascade)

  @@id([postId, tagId])
  @@map("tags_on_posts")
}

model Comment {
  id        String   @id @default(cuid())
  content   String
  postId    String   @map("post_id")
  post      Post     @relation(fields: [postId], references: [id], onDelete: Cascade)
  createdAt DateTime @default(now()) @map("created_at")

  @@index([postId])
  @@map("comments")
}
```

## Prisma Client Patterns

```typescript
// lib/db.ts — Singleton pattern (prevents connection leaks)
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };

export const db = globalForPrisma.prisma ?? new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'warn', 'error'] : ['error'],
});

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = db;
```

## Query Patterns

```typescript
// Efficient pagination
async function getPosts(page: number, perPage: number = 20) {
  const [posts, total] = await db.$transaction([
    db.post.findMany({
      where: { published: true, author: { deletedAt: null } },
      select: {
        id: true,
        title: true,
        slug: true,
        createdAt: true,
        author: { select: { id: true, name: true } },
        _count: { select: { comments: true } },
      },
      orderBy: { createdAt: 'desc' },
      skip: (page - 1) * perPage,
      take: perPage,
    }),
    db.post.count({ where: { published: true } }),
  ]);

  return { posts, total, pages: Math.ceil(total / perPage) };
}

// Upsert pattern
async function upsertProfile(userId: string, data: { bio?: string; avatarUrl?: string }) {
  return db.profile.upsert({
    where: { userId },
    create: { userId, ...data },
    update: data,
  });
}

// Soft delete
async function softDeleteUser(userId: string) {
  return db.user.update({
    where: { id: userId },
    data: { deletedAt: new Date() },
  });
}

// Full-text search (PostgreSQL)
async function searchPosts(query: string) {
  return db.post.findMany({
    where: {
      OR: [
        { title: { contains: query, mode: 'insensitive' } },
        { content: { contains: query, mode: 'insensitive' } },
      ],
    },
  });
}
```

## Seed Script

```typescript
// prisma/seed.ts
import { PrismaClient } from '@prisma/client';
import { hash } from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  const passwordHash = await hash('password123', 12);

  const admin = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      name: 'Admin User',
      passwordHash,
      role: 'ADMIN',
      emailVerified: true,
      profile: { create: { bio: 'Platform administrator' } },
    },
  });

  console.log('Seeded admin user:', admin.id);
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
```

## Checklist

- [ ] `@@index` on every foreign key and frequently queried column
- [ ] `@map` / `@@map` for snake_case table/column names
- [ ] Singleton PrismaClient (no connection leaks)
- [ ] Use `select` to limit returned fields
- [ ] `$transaction` for multi-step operations
- [ ] Soft delete with `deletedAt` where needed
- [ ] Seed script in `prisma/seed.ts`
- [ ] Connection pooling for serverless deployments
- [ ] Migration files committed to git
- [ ] `npx prisma generate` in build step
