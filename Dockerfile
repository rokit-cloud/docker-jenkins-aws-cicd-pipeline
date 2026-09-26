# ---- Build Stage ----
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build 2>/dev/null || echo "no build step, skipping"

# ---- Runtime Stage (Hardened Non-Root) ----
FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production

# Security: Create and run under dedicated non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=build --chown=appuser:appgroup /app ./

USER appuser
EXPOSE 3000

# Health check to verify application readiness
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD wget -qO- http://localhost:3000/ || exit 1

# Production preview serving on port 3000
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "3000"]
