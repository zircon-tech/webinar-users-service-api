FROM public.ecr.aws/lambda/nodejs:20

COPY . ${LAMBDA_TASK_ROOT}

RUN npm i

# Set the CMD to your handler 
CMD [ "index.handler" ]
