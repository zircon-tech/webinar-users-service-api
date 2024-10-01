# Users Service API

This project is a simple demo Node.js application for a Users Service API. It is designed to be used as part of a webinar session about CI/CD pipelines in AWS.

## Installation
To install and run the Users Service API locally, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/zircon-tech/webinar/users-service-api.git
    cd users-service-api
    ```

2. Build the docker image:
    ```bash
    docker build -t users-service-api .
    ```

3. Start the container:
    ```bash
    docker run -p 8080:8080 users-service-api
    ```

## Usage
Once the server is running, you can interact with the API using tools like Postman or curl. The server will be running on `http://localhost:8080`.

## License
This project is licensed under the MIT License.
