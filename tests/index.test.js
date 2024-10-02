const request = require('supertest');
const app = require('../index'); // Assuming you export the app from index.js

describe('GET /', () => {
    it('should return a welcome message', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('sentence', 'Welcome to the Automation world');
    });
});

describe('GET /metrics', () => {
    it('should return metrics', async () => {
        const res = await request(app).get('/metrics');
        expect(res.statusCode).toEqual(200);
        expect(res.headers['content-type']).toMatch(/text\/plain/);
    });
});

describe('GET /ping', () => {
    it('should return pong', async () => {
        const res = await request(app).get('/ping');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('message', 'pong');
    });
});

describe('GET /error', () => {
    it('should return an internal server error', async () => {
        const res = await request(app).get('/error');
        expect(res.statusCode).toEqual(500);
        expect(res.body).toHaveProperty('error', 'Internal Server Error');
    });
});

describe('GET /users', () => {
    it('should return a list of users', async () => {
        const res = await request(app).get('/users');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('users');
        expect(res.body.users).toEqual([
            { name: 'Alice', age: 25 },
            { name: 'Bob', age: 30 },
            { name: 'Charlie', age: 35 },
        ]);
    });
});