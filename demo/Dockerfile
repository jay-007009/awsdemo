FROM node:14
WORKDIR awsdemo
COPY package.json .
RUN npm install
COPY . .
EXPOSE 4001
CMD [ "node","app.js" ] 