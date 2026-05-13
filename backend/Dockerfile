# ========== Stage 1 : Build ==========
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# ========== Stage 2 : Production ==========
FROM node:22-alpine AS production
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
RUN rm -rf .env .git .gitignore Dockerfile docker-compose* \
    && chown -R appuser:appgroup /app
USER appuser
EXPOSE 5000
# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5000/health || exit 1
# Démarrer l'application
CMD ["node", "server.js"]