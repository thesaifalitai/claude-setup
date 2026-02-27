---
name: devops-cicd
description: >
  Expert DevOps, CI/CD, Docker, and cloud infrastructure skill. ALWAYS trigger for ANY task involving
  Docker, Docker Compose, Kubernetes, AWS (Lambda, EC2, S3, ECS, RDS, CloudFront), Nginx config,
  GitHub Actions, CI/CD pipelines, deployment automation, environment variables, secrets management,
  SSL/TLS, load balancing, auto-scaling, monitoring (CloudWatch, Datadog), logging (ELK stack),
  Firebase hosting, Vercel/Netlify deployment, CDN setup, database migrations in production,
  blue-green deployments, or infrastructure as code (Terraform/CDK).
  Also triggers for: "deploy my app", "set up Docker", "containerize", "production setup",
  "CI/CD pipeline", "GitHub Actions workflow", "AWS setup", "scale my app".
---

# DevOps & CI/CD Expert

You are a senior DevOps engineer specializing in containerization, cloud infrastructure,
GitHub Actions CI/CD, and production deployments. You build reliable, scalable pipelines.

## Docker Patterns

```dockerfile
# Dockerfile (multi-stage Node.js)
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/dist ./dist
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
USER nextjs
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

```yaml
# docker-compose.yml (development)
version: '3.9'
services:
  api:
    build: { context: ., target: builder }
    command: npm run start:dev
    volumes:
      - .:/app
      - /app/node_modules
    ports: ['3000:3000']
    environment:
      - DATABASE_URL=postgresql://postgres:secret@db:5432/myapp
      - REDIS_URL=redis://cache:6379
    depends_on:
      db: { condition: service_healthy }
      cache: { condition: service_started }

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: secret
    volumes: ['pgdata:/var/lib/postgresql/data']
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U postgres']
      interval: 5s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes: ['redisdata:/data']

volumes:
  pgdata:
  redisdata:
```

## GitHub Actions Workflows

```yaml
# .github/workflows/deploy.yml
name: Build, Test & Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports: ['5432:5432']
        options: --health-cmd pg_isready --health-interval 10s --health-timeout 5s --health-retries 5

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: npm }
      - run: npm ci
      - run: npm run lint
      - run: npm run test:ci
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/testdb

  build-and-push:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4
      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest,${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Deploy to EC2
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_KEY }}
          script: |
            docker pull ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
            docker stop api || true
            docker rm api || true
            docker run -d --name api \
              --restart unless-stopped \
              -p 3000:3000 \
              --env-file /etc/myapp/.env \
              ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
```

## Nginx Configuration

```nginx
# /etc/nginx/sites-available/myapp
server {
    listen 80;
    server_name myapp.com www.myapp.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name myapp.com www.myapp.com;

    ssl_certificate /etc/letsencrypt/live/myapp.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/myapp.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;

    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    # Gzip
    gzip on;
    gzip_types text/plain application/json application/javascript text/css;

    # API
    location /api/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 90;
    }

    # Next.js
    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_cache_bypass $http_upgrade;
    }
}
```

## AWS Lambda (Serverless)

```typescript
// handler.ts
import { APIGatewayProxyHandler } from 'aws-lambda';
import serverlessExpress from '@vendia/serverless-express';
import { app } from './app';

const serverlessApp = serverlessExpress({ app });

export const handler: APIGatewayProxyHandler = async (event, context) => {
  context.callbackWaitsForEmptyEventLoop = false;
  return serverlessApp(event, context);
};
```

```yaml
# serverless.yml
service: my-api
frameworkVersion: '3'

provider:
  name: aws
  runtime: nodejs20.x
  region: us-east-1
  memorySize: 512
  timeout: 30
  environment:
    DATABASE_URL: ${ssm:/myapp/DATABASE_URL}
    JWT_SECRET: ${ssm:/myapp/JWT_SECRET}

functions:
  api:
    handler: dist/handler.handler
    events:
      - httpApi: 'ANY /{proxy+}'

plugins:
  - serverless-plugin-optimize
  - serverless-offline
```

## Environment Management

```bash
# .env.example (commit this, NOT .env)
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-jwt-secret-change-in-production
JWT_EXPIRES_IN=15m
AWS_REGION=us-east-1
AWS_S3_BUCKET=my-bucket

# Production: use AWS SSM, Doppler, or GitHub Secrets
aws ssm put-parameter --name /myapp/JWT_SECRET --value "secret" --type SecureString

# Load from SSM in startup
aws ssm get-parameters-by-path --path /myapp --with-decryption
```

## Zero-Downtime Deployment

```bash
#!/bin/bash
# deploy.sh - Blue/Green with Docker
set -e

IMAGE="ghcr.io/myorg/myapp:${1:-latest}"
CURRENT=$(docker ps --filter name=app-blue -q)

if [ -n "$CURRENT" ]; then
  NEW_NAME="app-green"
  OLD_NAME="app-blue"
else
  NEW_NAME="app-blue"
  OLD_NAME="app-green"
fi

echo "Starting $NEW_NAME..."
docker pull $IMAGE
docker run -d --name $NEW_NAME --restart unless-stopped \
  -p 3001:3000 --env-file /etc/.env $IMAGE

# Health check
sleep 10
if curl -sf http://localhost:3001/health; then
  echo "✅ Health check passed. Switching traffic..."
  # Update nginx upstream
  sed -i "s/$OLD_NAME/$NEW_NAME/" /etc/nginx/conf.d/upstream.conf
  nginx -s reload
  sleep 5
  docker stop $OLD_NAME 2>/dev/null || true
  docker rm $OLD_NAME 2>/dev/null || true
  echo "✅ Deployment complete"
else
  echo "❌ Health check failed. Rolling back..."
  docker stop $NEW_NAME && docker rm $NEW_NAME
  exit 1
fi
```

## Monitoring Setup

```typescript
// health endpoint
@Get('/health')
healthCheck() {
  return {
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: process.env.npm_package_version,
  };
}

// Structured logging (Winston)
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL ?? 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    process.env.NODE_ENV === 'production'
      ? winston.format.json()
      : winston.format.colorize({ all: true })
  ),
  transports: [new winston.transports.Console()],
});
```

## Production Checklist

- [ ] Environment variables in secrets manager (not `.env` files in server)
- [ ] SSL certificate via Let's Encrypt (auto-renew with certbot)
- [ ] Docker images in private registry
- [ ] Health check endpoint (`/health`)
- [ ] Readiness/liveness probes (Kubernetes)
- [ ] Centralized logging (CloudWatch, Papertrail, or ELK)
- [ ] Error monitoring (Sentry)
- [ ] Uptime monitoring (BetterUptime, Checkly)
- [ ] Database connection pooling (PgBouncer)
- [ ] Rate limiting at Nginx/API level
- [ ] Automated DB backups
- [ ] Rollback strategy tested
