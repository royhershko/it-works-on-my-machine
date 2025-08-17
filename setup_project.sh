#!/bin/bash

# Setup script for it-works-on-my-machine project
echo "🚀 Setting up it-works-on-my-machine project..."

# Create package.json
cat > package.json << 'EOF'
{
  "name": "it-works-on-my-machine",
  "version": "1.0.0",
  "description": "A microservice demonstrating production-ready CI/CD practices",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "node server.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint . --ext .js",
    "lint:fix": "eslint . --ext .js --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "audit:security": "npm audit --audit-level moderate",
    "build": "echo 'No build step required for Node.js'",
    "healthcheck": "./test.sh"
  },
  "keywords": [
    "microservice",
    "express",
    "devops",
    "ci-cd",
    "production-ready"
  ],
  "author": "royhershko",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "supertest": "^6.3.3",
    "eslint": "^8.57.0",
    "prettier": "^3.2.5",
    "@eslint/js": "^9.0.0"
  },
  "jest": {
    "testEnvironment": "node",
    "collectCoverageFrom": [
      "*.js",
      "!coverage/**",
      "!node_modules/**"
    ],
    "coverageThreshold": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
EOF

# Create enhanced server.js
cat > server.js << 'EOF'
const express = require('express');
const app = express();

// Middleware for JSON parsing
app.use(express.json());

// Security headers middleware
app.use((req, res, next) => {
  res.set({
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'X-XSS-Protection': '1; mode=block',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains'
  });
  next();
});

// Request logging middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`${timestamp} - ${req.method} ${req.path} - ${req.ip}`);
  next();
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    service: 'it-works-on-my-machine',
    version: process.env.VERSION || '1.0.0',
    status: 'running',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  const healthData = {
    status: 'healthy',
    message: 'Still working... on *my* machine 🧃',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    version: process.env.VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  };
  
  res.status(200).json(healthData);
});

// Readiness probe endpoint
app.get('/ready', (req, res) => {
  res.status(200).json({
    status: 'ready',
    timestamp: new Date().toISOString()
  });
});

// Version endpoint
app.get('/version', (req, res) => {
  res.json({
    version: process.env.VERSION || '1.0.0',
    build: process.env.BUILD_NUMBER || 'dev',
    commit: process.env.GIT_COMMIT || 'unknown',
    buildDate: process.env.BUILD_DATE || new Date().toISOString()
  });
});

// Metrics endpoint (basic)
app.get('/metrics', (req, res) => {
  const metrics = {
    uptime_seconds: process.uptime(),
    memory_usage_bytes: process.memoryUsage(),
    cpu_usage: process.cpuUsage(),
    timestamp: new Date().toISOString()
  };
  res.json(metrics);
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.originalUrl} not found`,
    timestamp: new Date().toISOString()
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'production' ? 'Something went wrong' : err.message,
    timestamp: new Date().toISOString()
  });
});

const port = process.env.PORT || 3000;
const server = app.listen(port, () => {
  console.log(`🚀 Server is running on http://localhost:${port}`);
  console.log(`📊 Health check: http://localhost:${port}/health`);
  console.log(`🏃 Readiness: http://localhost:${port}/ready`);
  console.log(`📈 Metrics: http://localhost:${port}/metrics`);
  console.log(`📝 Version: http://localhost:${port}/version`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  server.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});

module.exports = app;
EOF

# Create test.sh (original from assignment)
cat > test.sh << 'EOF'
#!/bin/bash
curl -s http://localhost:3000/health | grep "Still working" && echo "PASS ✅" || echo "FAIL ❌"
EOF

chmod +x test.sh

# Create server.test.js
cat > server.test.js << 'EOF'
const request = require('supertest');
const app = require('./server');

describe('it-works-on-my-machine API', () => {
  describe('GET /', () => {
    test('should return service information', async () => {
      const response = await request(app).get('/');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('service', 'it-works-on-my-machine');
      expect(response.body).toHaveProperty('status', 'running');
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('timestamp');
    });
  });

  describe('GET /health', () => {
    test('should return health status', async () => {
      const response = await request(app).get('/health');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'healthy');
      expect(response.body).toHaveProperty('message');
      expect(response.body.message).toContain('Still working... on *my* machine');
      expect(response.body).toHaveProperty('uptime');
      expect(response.body).toHaveProperty('timestamp');
    });

    test('should include version and environment info', async () => {
      const response = await request(app).get('/health');
      
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('environment');
    });
  });

  describe('GET /ready', () => {
    test('should return readiness status', async () => {
      const response = await request(app).get('/ready');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'ready');
      expect(response.body).toHaveProperty('timestamp');
    });
  });

  describe('GET /version', () => {
    test('should return version information', async () => {
      const response = await request(app).get('/version');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('version');
      expect(response.body).toHaveProperty('build');
      expect(response.body).toHaveProperty('commit');
      expect(response.body).toHaveProperty('buildDate');
    });
  });

  describe('GET /metrics', () => {
    test('should return basic metrics', async () => {
      const response = await request(app).get('/metrics');
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('uptime_seconds');
      expect(response.body).toHaveProperty('memory_usage_bytes');
      expect(response.body).toHaveProperty('cpu_usage');
      expect(response.body).toHaveProperty('timestamp');
      expect(typeof response.body.uptime_seconds).toBe('number');
    });
  });

  describe('Error handling', () => {
    test('should return 404 for unknown routes', async () => {
      const response = await request(app).get('/nonexistent');
      
      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('error', 'Not Found');
      expect(response.body).toHaveProperty('message');
      expect(response.body.message).toContain('/nonexistent');
    });
  });

  describe('Security headers', () => {
    test('should include security headers', async () => {
      const response = await request(app).get('/');
      
      expect(response.headers).toHaveProperty('x-content-type-options', 'nosniff');
      expect(response.headers).toHaveProperty('x-frame-options', 'DENY');
      expect(response.headers).toHaveProperty('x-xss-protection', '1; mode=block');
      expect(response.headers).toHaveProperty('strict-transport-security');
    });
  });

  describe('JSON parsing', () => {
    test('should parse JSON request body', async () => {
      const response = await request(app)
        .post('/nonexistent')
        .send({ test: 'data' })
        .set('Content-Type', 'application/json');
      
      expect(response.status).toBe(404);
    });
  });
});
EOF

echo "✅ Created main application files"

# Create Dockerfile
cat > Dockerfile << 'EOF'
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
EOF

echo "✅ Created Dockerfile"

echo "🎉 Setup completed! Run 'chmod +x setup_project.sh && ./setup_project.sh' to create all files."
EOF
```
