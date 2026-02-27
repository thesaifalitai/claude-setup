---
name: nodejs-backend
description: >
  Expert Node.js backend development skill. ALWAYS trigger for ANY task involving Node.js,
  Express.js, NestJS, Fastify, REST APIs, GraphQL APIs, authentication (JWT/OAuth), databases
  (MySQL/PostgreSQL/MongoDB), ORMs (Prisma/TypeORM/Mongoose), middleware, validation (Zod/Joi),
  API architecture, microservices, WebSockets, background jobs (Bull/BullMQ), caching (Redis),
  rate limiting, backend security, server deployment, or server-side TypeScript.
  Also triggers for: "build an API", "create endpoint", "backend service", "backend architecture",
  "server-side", "database schema", "REST endpoint", "GraphQL schema/resolver", "authentication system".
---

# Node.js Backend Expert

You are a senior backend engineer specializing in Node.js, NestJS, Express, TypeScript, REST, GraphQL,
and production-grade API systems. You write clean, secure, scalable server-side code.

## Tech Stack Decisions

| Use Case | Recommended |
|----------|------------|
| Framework | NestJS (enterprise) or Express + TypeScript (lightweight) |
| ORM | Prisma (PostgreSQL/MySQL) or Mongoose (MongoDB) |
| Validation | Zod (type-safe) or class-validator (NestJS DTOs) |
| Auth | Passport.js + JWT + refresh tokens |
| Caching | Redis (ioredis) |
| Queue | BullMQ (Redis-based) |
| Testing | Jest + Supertest |
| Logging | Winston + Morgan |
| Env | dotenv + Zod schema validation |

## NestJS Project Structure

```
src/
├── modules/
│   ├── auth/
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── auth.module.ts
│   │   ├── dto/
│   │   │   ├── login.dto.ts
│   │   │   └── register.dto.ts
│   │   └── guards/
│   │       ├── jwt.guard.ts
│   │       └── roles.guard.ts
│   ├── users/
│   └── products/
├── common/
│   ├── decorators/
│   ├── filters/         # Exception filters
│   ├── interceptors/    # Response transform
│   └── pipes/           # Validation pipes
├── config/              # Config module (ConfigService)
├── database/            # Prisma module
└── main.ts
```

## REST API Patterns

```typescript
// ✅ DTOs with class-validator
import { IsEmail, IsString, MinLength } from 'class-validator';
export class RegisterDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  password: string;
}

// ✅ Controller with proper HTTP semantics
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  findAll(@Query() query: PaginationDto) {
    return this.usersService.findAll(query);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.usersService.findOne(id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto);
  }

  @Patch(':id')
  update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateUserDto) {
    return this.usersService.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.usersService.remove(id);
  }
}
```

## JWT Authentication

```typescript
// auth.service.ts
@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async login(email: string, password: string) {
    const user = await this.usersService.findByEmail(email);
    if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const payload = { sub: user.id, email: user.email, roles: user.roles };
    return {
      access_token: this.jwtService.sign(payload, { expiresIn: '15m' }),
      refresh_token: this.jwtService.sign(payload, { expiresIn: '7d' }),
    };
  }
}

// jwt.strategy.ts
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('JWT_SECRET'),
    });
  }

  async validate(payload: JwtPayload): Promise<UserEntity> {
    return { id: payload.sub, email: payload.email, roles: payload.roles };
  }
}
```

## Prisma Schema Patterns

```prisma
// schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id           String    @id @default(uuid())
  email        String    @unique
  passwordHash String    @map("password_hash")
  roles        Role[]    @default([USER])
  createdAt    DateTime  @default(now()) @map("created_at")
  updatedAt    DateTime  @updatedAt @map("updated_at")
  posts        Post[]

  @@map("users")
}

model Post {
  id        String   @id @default(uuid())
  title     String
  content   String?
  published Boolean  @default(false)
  authorId  String   @map("author_id")
  author    User     @relation(fields: [authorId], references: [id])
  createdAt DateTime @default(now()) @map("created_at")

  @@index([authorId])
  @@map("posts")
}

enum Role {
  USER
  ADMIN
}
```

## GraphQL with NestJS

```typescript
// schema.gql is auto-generated with code-first approach
@Resolver(() => User)
export class UsersResolver {
  constructor(private usersService: UsersService) {}

  @Query(() => [User])
  @UseGuards(GqlAuthGuard)
  users(): Promise<User[]> {
    return this.usersService.findAll();
  }

  @Mutation(() => User)
  createUser(@Args('input') input: CreateUserInput): Promise<User> {
    return this.usersService.create(input);
  }

  @ResolveField(() => [Post])
  posts(@Parent() user: User, @Context() ctx: GqlContext): Promise<Post[]> {
    return ctx.loaders.postsLoader.load(user.id); // DataLoader to avoid N+1
  }
}
```

## Redis Caching

```typescript
// cache.service.ts
@Injectable()
export class CacheService {
  constructor(@InjectRedis() private readonly redis: Redis) {}

  async get<T>(key: string): Promise<T | null> {
    const data = await this.redis.get(key);
    return data ? JSON.parse(data) : null;
  }

  async set(key: string, value: unknown, ttlSeconds = 300): Promise<void> {
    await this.redis.setex(key, ttlSeconds, JSON.stringify(value));
  }

  async invalidate(pattern: string): Promise<void> {
    const keys = await this.redis.keys(pattern);
    if (keys.length) await this.redis.del(...keys);
  }
}
```

## Error Handling

```typescript
// filters/global-exception.filter.ts
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    const status = exception instanceof HttpException
      ? exception.getStatus()
      : HttpStatus.INTERNAL_SERVER_ERROR;

    const message = exception instanceof HttpException
      ? exception.getResponse()
      : 'Internal server error';

    if (status === 500) this.logger.error(exception);

    response.status(status).json({
      statusCode: status,
      message,
      timestamp: new Date().toISOString(),
    });
  }
}
```

## BullMQ Job Queue

```typescript
// queues/email.processor.ts
@Processor('email')
export class EmailProcessor {
  @Process('send-welcome')
  async handleWelcomeEmail(job: Job<{ email: string; name: string }>) {
    await this.emailService.sendWelcome(job.data.email, job.data.name);
  }
}

// Adding jobs
await this.emailQueue.add('send-welcome', { email, name }, {
  attempts: 3,
  backoff: { type: 'exponential', delay: 1000 },
});
```

## Security Checklist

- [ ] Helmet.js (HTTP headers)
- [ ] Rate limiting (throttler: 100 req/min per IP)
- [ ] Input validation on all endpoints
- [ ] Parameterized queries (no raw SQL)
- [ ] bcrypt for passwords (rounds ≥ 12)
- [ ] JWT secrets in env, rotated regularly
- [ ] CORS configured for known origins only
- [ ] SQL injection prevention via Prisma/TypeORM
- [ ] XSS prevention via sanitization
- [ ] Audit logs for sensitive actions

## Production Setup

```bash
# Install
npm i @nestjs/common @nestjs/core @nestjs/platform-express
npm i @nestjs/config @nestjs/jwt @nestjs/passport
npm i @nestjs/throttler @nestjs/cache-manager
npm i prisma @prisma/client
npm i class-validator class-transformer
npm i bcrypt ioredis bullmq
npm i -D @types/bcrypt

# Database
npx prisma generate
npx prisma migrate dev --name init
npx prisma migrate deploy  # production

# Docker
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16
docker run -d -p 6379:6379 redis:7-alpine
```
