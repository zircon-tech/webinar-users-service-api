FROM public.ecr.aws/w9j2a6e3/nodejs:latest

WORKDIR /usr/src/app

COPY . .

RUN npm i

EXPOSE 8080

USER node

CMD ["node", "index.js"]
