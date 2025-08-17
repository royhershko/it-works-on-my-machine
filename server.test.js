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
