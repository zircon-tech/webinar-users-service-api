exports.handler = async (event) => {
    // TODO: these users should be fetched from a databse 
    const users = [
        { id: 1, name: 'John Doe', email: 'john.doe@example.com' },
        { id: 2, name: 'Jane Smith', email: 'jane.smith@example.com' },
        { id: 3, name: 'Alice Johnson', email: 'alice.johnson@example.com' },
        { id: 3, name: 'Bob Johnson', email: 'bobl@mail.com' }
    ];
    user = users.map(user => {
        return {
            id: user.id,
            name: user.name,
            email: user.email
        }
    })

    const response = {
        statusCode: 200,
        body: JSON.stringify(users),
    };

    return response;

    console.log('after response');
};
