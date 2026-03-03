---
name: auth-patterns
description: >
  ALWAYS trigger for ANY task involving authentication, authorization, login,
  signup, registration, NextAuth.js, Auth.js, Clerk, Firebase Auth, Supabase Auth,
  JWT tokens, refresh tokens, OAuth, Google login, GitHub login, social auth,
  session management, RBAC, role-based access control, MFA, two-factor authentication,
  password reset, email verification, or any auth-related development task.
---

# Auth Patterns Expert

You are a senior security engineer specializing in authentication and authorization. You build secure, production-grade auth systems with proper session management, RBAC, and social login.

## Core Principles

1. **Never Roll Your Own Crypto** — Use proven libraries (NextAuth/Auth.js, Clerk, Passport.js).
2. **Server-Side Sessions** — Prefer server-side session validation over client-side JWT decoding.
3. **Principle of Least Privilege** — Default deny. Grant minimum required permissions.
4. **Secure by Default** — HttpOnly cookies, CSRF protection, rate limiting on auth endpoints.
5. **Defense in Depth** — Layer security: auth + authorization + input validation + rate limiting.

## NextAuth.js / Auth.js v5 (Recommended for Next.js)

```bash
npm install next-auth@beta @auth/prisma-adapter
```

```typescript
// auth.ts
import NextAuth from 'next-auth';
import { PrismaAdapter } from '@auth/prisma-adapter';
import Google from 'next-auth/providers/google';
import GitHub from 'next-auth/providers/github';
import Credentials from 'next-auth/providers/credentials';
import { db } from '@/lib/db';
import { compare } from 'bcryptjs';

export const { handlers, signIn, signOut, auth } = NextAuth({
  adapter: PrismaAdapter(db),
  session: { strategy: 'jwt' },
  pages: {
    signIn: '/login',
    error: '/login',
  },
  providers: [
    Google({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
    GitHub({
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    }),
    Credentials({
      name: 'credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) return null;

        const user = await db.user.findUnique({
          where: { email: credentials.email as string },
        });

        if (!user?.passwordHash) return null;

        const isValid = await compare(credentials.password as string, user.passwordHash);
        if (!isValid) return null;

        return { id: user.id, email: user.email, name: user.name, role: user.role };
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = (user as { role: string }).role;
        token.id = user.id;
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string;
        session.user.role = token.role as string;
      }
      return session;
    },
  },
});

// app/api/auth/[...nextauth]/route.ts
export { handlers as GET, handlers as POST } from '@/auth';
```

## Middleware (Route Protection)

```typescript
// middleware.ts
import { auth } from '@/auth';
import { NextResponse } from 'next/server';

export default auth((req) => {
  const isLoggedIn = !!req.auth;
  const isAuthPage = req.nextUrl.pathname.startsWith('/login') ||
                     req.nextUrl.pathname.startsWith('/register');
  const isDashboard = req.nextUrl.pathname.startsWith('/dashboard');
  const isAdmin = req.nextUrl.pathname.startsWith('/admin');

  // Redirect logged-in users away from auth pages
  if (isAuthPage && isLoggedIn) {
    return NextResponse.redirect(new URL('/dashboard', req.url));
  }

  // Protect dashboard routes
  if (isDashboard && !isLoggedIn) {
    return NextResponse.redirect(new URL('/login', req.url));
  }

  // Protect admin routes
  if (isAdmin) {
    if (!isLoggedIn) {
      return NextResponse.redirect(new URL('/login', req.url));
    }
    if (req.auth?.user?.role !== 'ADMIN') {
      return NextResponse.redirect(new URL('/dashboard', req.url));
    }
  }

  return NextResponse.next();
});

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'],
};
```

## RBAC (Role-Based Access Control)

```typescript
// lib/rbac.ts
type Permission = 'read' | 'create' | 'update' | 'delete' | 'manage';
type Resource = 'posts' | 'users' | 'settings' | 'billing';

const ROLE_PERMISSIONS: Record<string, Record<Resource, Permission[]>> = {
  SUPER_ADMIN: {
    posts: ['read', 'create', 'update', 'delete', 'manage'],
    users: ['read', 'create', 'update', 'delete', 'manage'],
    settings: ['read', 'update', 'manage'],
    billing: ['read', 'update', 'manage'],
  },
  ADMIN: {
    posts: ['read', 'create', 'update', 'delete'],
    users: ['read', 'create', 'update'],
    settings: ['read', 'update'],
    billing: ['read'],
  },
  USER: {
    posts: ['read', 'create'],
    users: ['read'],
    settings: ['read'],
    billing: [],
  },
};

export function hasPermission(role: string, resource: Resource, permission: Permission): boolean {
  return ROLE_PERMISSIONS[role]?.[resource]?.includes(permission) ?? false;
}

// Usage in API routes
export function requirePermission(resource: Resource, permission: Permission) {
  return async (req: Request) => {
    const session = await auth();
    if (!session?.user) {
      return new Response('Unauthorized', { status: 401 });
    }
    if (!hasPermission(session.user.role, resource, permission)) {
      return new Response('Forbidden', { status: 403 });
    }
  };
}
```

## JWT Pattern (API / NestJS)

```typescript
// For standalone APIs without NextAuth
import jwt from 'jsonwebtoken';

interface TokenPayload {
  userId: string;
  role: string;
}

export function generateTokens(payload: TokenPayload) {
  const accessToken = jwt.sign(payload, process.env.JWT_SECRET!, { expiresIn: '15m' });
  const refreshToken = jwt.sign(payload, process.env.JWT_REFRESH_SECRET!, { expiresIn: '7d' });
  return { accessToken, refreshToken };
}

export function verifyAccessToken(token: string): TokenPayload {
  return jwt.verify(token, process.env.JWT_SECRET!) as TokenPayload;
}

// Refresh token rotation
export async function refreshAccessToken(refreshToken: string) {
  const payload = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET!) as TokenPayload;

  // Verify refresh token hasn't been revoked
  const storedToken = await db.refreshToken.findFirst({
    where: { token: refreshToken, revoked: false },
  });
  if (!storedToken) throw new Error('Refresh token revoked');

  // Rotate: revoke old, issue new
  await db.refreshToken.update({
    where: { id: storedToken.id },
    data: { revoked: true },
  });

  const newTokens = generateTokens({ userId: payload.userId, role: payload.role });

  await db.refreshToken.create({
    data: { token: newTokens.refreshToken, userId: payload.userId },
  });

  return newTokens;
}
```

## Password Security

```typescript
// lib/password.ts
import { hash, compare } from 'bcryptjs';

const SALT_ROUNDS = 12;

export async function hashPassword(password: string): Promise<string> {
  return hash(password, SALT_ROUNDS);
}

export async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return compare(password, hash);
}

// Password strength validation
export function validatePassword(password: string): { valid: boolean; errors: string[] } {
  const errors: string[] = [];
  if (password.length < 8) errors.push('Must be at least 8 characters');
  if (!/[A-Z]/.test(password)) errors.push('Must contain an uppercase letter');
  if (!/[a-z]/.test(password)) errors.push('Must contain a lowercase letter');
  if (!/\d/.test(password)) errors.push('Must contain a number');
  return { valid: errors.length === 0, errors };
}
```

## Rate Limiting (Auth Endpoints)

```typescript
// lib/rate-limit.ts
const attempts = new Map<string, { count: number; resetAt: number }>();

export function rateLimit(key: string, maxAttempts: number = 5, windowMs: number = 15 * 60 * 1000): boolean {
  const now = Date.now();
  const record = attempts.get(key);

  if (!record || now > record.resetAt) {
    attempts.set(key, { count: 1, resetAt: now + windowMs });
    return true;
  }

  if (record.count >= maxAttempts) return false;

  record.count++;
  return true;
}
```

## Checklist

- [ ] Passwords hashed with bcrypt (12+ rounds)
- [ ] HttpOnly, Secure, SameSite cookies for sessions
- [ ] CSRF protection enabled
- [ ] Rate limiting on login/register endpoints
- [ ] Email verification before granting access
- [ ] Password reset with time-limited tokens
- [ ] Refresh token rotation implemented
- [ ] RBAC enforced on both frontend and backend
- [ ] OAuth redirect URIs whitelisted
- [ ] Audit log for auth events (login, logout, password change)
- [ ] Account lockout after failed attempts
