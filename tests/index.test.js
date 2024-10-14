const handler = require('../index').handler;

describe('Handler function', () => {
    it('should return status code 200', async () => {
        const event = {};
        const result = await handler(event);
        expect(result.statusCode).toEqual(200);
    });

    it('should return a list of users', async () => {
        const event = {};
        const result = await handler(event);
        const users = JSON.parse(result.body);
        expect(users).toBeInstanceOf(Array);
        expect(users).toHaveLength(4);
        expect(users[0]).toHaveProperty('id', 1);
        expect(users[0]).toHaveProperty('name', 'John Doe');
        expect(users[0]).toHaveProperty('email', 'john.doe@example.com');
    });
});
