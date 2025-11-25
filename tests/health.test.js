const request = require('supertest');

const app = require('../server');

describe('API health endpoint', () => {
  test('GET /api/health returns 200 and JSON', async () => {
    const res = await request(app).get('/api/health');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('status');
    expect(res.body).toHaveProperty('message');
  });
});
