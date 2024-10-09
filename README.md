# Users Service API

This project is a simple demo Node.js application for a Users Service API. It is designed to be used as part of a webinar session about CI/CD pipelines in AWS.

![image](https://github.com/user-attachments/assets/e1fda6d5-5c0d-4eda-a238-f897fe99e2d3)



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

## Deployment

This project comes with a Terraform configuration to deploy the Users Service API to AWS. To deploy the API, follow these steps:

1. Install Terraform:
    ```bash
    brew install terraform
    ```
2. Define your variables in `terraform.tfvars`:
    ```hcl
    region = "us-east-2"
    ...
    ```
3. Initialize Terraform:
    ```bash
    terraform init
    ```
4. Plan the deployment:
    ```bash
    terraform plan -var-file="terraform.tfvars" -out="out.plan"
    ```
5. Deploy the changes:
    ```bash
    terraform apply "out.plan"
    ```

## Usage
Once the server is running, you can interact with the API using tools like Postman or curl. The server will be running on `http://localhost:8080`.

## License
This project is licensed under the MIT License.
