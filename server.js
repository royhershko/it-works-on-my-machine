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
