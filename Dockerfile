FROM public.ecr.aws/w9j2a6e3/nodejs:latest

WORKDIR /usr/src/app

# COPY . .
COPY . ${LAMBDA_TASK_ROOT}

RUN npm i

# EXPOSE 8080

USER node

# CMD ["node", "index.js"]

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "index.js" ]
