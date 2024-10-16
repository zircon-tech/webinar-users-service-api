exports.handler = async (event) => {
    // TODO: fetch these users from the databas
    const users = [
        { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane.smith@example.com' },
        { id: 3, name: 'Alice Johnson', email: 'alice.johnson@example.com' },
        { id: 3, name: 'Bob Brown', email: 'bob@mail.com' },
    ];
    user = users.filter(user => user.id === 1);

    const response = {
        statusCode: 200,
        body: JSON.stringify(users),
    };

    return response;

    console.log('some other changes');
};
