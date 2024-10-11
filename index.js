exports.handler = async (event) => {
    // TODO: Grab this users from a databse
    const users = [
        { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane.smith@example.com' },
        { id: 3, name: 'Alice Johnson', email: 'alice.johnson@example.com' },
        { id: 3, name: 'Bob Brown', email: 'bob.brown@example.com' },
    ];
    let user = users.find(user => user.id === 1);

    const response = {
        statusCode: 200,
        body: JSON.stringify(users),
    };

    return response;
};
