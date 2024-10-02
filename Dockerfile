FROM node:20

WORKDIR /usr/src/app

COPY . .

RUN npm i

EXPOSE 8080

USER node

CMD ["node", "index.js"]
