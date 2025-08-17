# Multi-stage Dockerfile for production-ready deployment
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Add non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S appuser -u 1001

# Copy package files
COPY package*.json ./

# Development stage
FROM base AS development
RUN npm ci --include=dev
COPY . .
USER appuser
EXPOSE 3000
CMD ["npm", "run", "dev"]

# Test stage
FROM development AS test
USER root
RUN npm run test:coverage
USER appuser

# Production dependencies stage
FROM base AS production-deps
RUN npm ci --only=production && npm cache clean --force

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Add non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S appuser -u 1001

# Copy production dependencies
COPY --from=production-deps --chown=appuser:nodejs /app/node_modules ./node_modules

# Copy application code
COPY --chown=appuser:nodejs server.js ./
COPY --chown=appuser:nodejs package*.json ./

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "const http=require('http'); \
    http.get('http://localhost:3000/health', (res) => { \
      process.exit(res.statusCode === 200 ? 0 : 1) \
    }).on('error', () => process.exit(1))"

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
