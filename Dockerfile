FROM node:16

WORKDIR /app

COPY /userapi/package*.json ./

RUN npm install

COPY /userapi .

EXPOSE 3000

CMD [ "npm", "start" ]
