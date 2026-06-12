# Multi-stage Dockerfile for the API (Node.js).
# Multi-stage = two stages: one installs/builds (heavy), the other only runs
# (light). The final image carries no build tooling = smaller and safer.
#
# The institutional website and the PWA are static (served by Nginx/Ingress),
# so this Dockerfile covers the API only.
#
# Build from the repository root (the .dockerignore at the root applies):
#   docker build -f docker/Dockerfile -t horaamiga-api:v1.0.0 .

# --- Stage 1: build (installs dependencies) ---
FROM node:20-alpine AS builder
WORKDIR /app

# Copy only the manifests first to leverage layer cache: if package.json did
# not change, Docker reuses the npm install layer (much faster builds).
COPY package*.json ./
RUN npm ci --omit=dev

COPY src ./src

# --- Stage 2: runtime (only what is needed to run) ---
FROM node:20-alpine
WORKDIR /app

# Non-root user: if the app is compromised, the attacker is not root in the container.
RUN addgroup -S app && adduser -S app -G app

# Bring only what the runtime needs, explicitly (no build cache, no dev deps).
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src

USER app
EXPOSE 3000

# Container-level health check: the orchestrator knows whether the app is alive.
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1

CMD ["node", "src/server.js"]
