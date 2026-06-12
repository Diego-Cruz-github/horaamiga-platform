# Dockerfile multi-stage da API (Node.js).
# Multi-stage = dois estagios: um pra instalar/buildar (pesado) e outro so com o
# que roda (leve). A imagem final nao carrega ferramenta de build = menor e mais segura.
#
# O site institucional e o PWA sao estaticos (servidos pelo Nginx/Ingress), entao
# este Dockerfile e so da API.

# --- Estagio 1: build (instala dependencias) ---
FROM node:20-alpine AS builder
WORKDIR /app

# Copia so os manifests primeiro pra aproveitar cache: se package.json nao mudou,
# o Docker reusa a camada de npm install (build muito mais rapido).
COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

# --- Estagio 2: runtime (so o necessario pra rodar) ---
FROM node:20-alpine
WORKDIR /app

# Usuario nao-root: se a app for comprometida, o atacante nao e root no container.
RUN addgroup -S app && adduser -S app -G app

# Traz so node_modules e codigo do estagio de build (sem cache de npm, sem dev deps).
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

USER app
EXPOSE 3000

# Health check no nivel do container: o orquestrador sabe se a app esta viva.
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1

CMD ["node", "src/server.js"]
