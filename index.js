exports.handler = async (event) => {
    // TODO fetch users from dtbase
    const users = [
        { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane.smith@example.com' },
        { id: 3, name: 'Alice Johnson', email: 'alice.johnson@example.com' },
        { id: 3, name: 'Bob Brown', email: 'bob@mail.com' },
    ];

    const response = {
        statusCode: 200,
        body: JSON.stringify(users),
    };

    return response;
};
