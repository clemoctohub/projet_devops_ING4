FROM node:16

WORKDIR /app

COPY /userapi/package*.json ./

RUN npm install

COPY /userapi .

EXPOSE 3000

CMD [ "npm", "start" ]

#RUN apt-get update
#RUN apt-get -y install sudo
#ENTRYPOINT [ "sudo apt install redis-server", "Y" ] 
#RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
#USER docker