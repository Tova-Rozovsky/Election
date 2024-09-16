# Stage for building the client
FROM node:18-alpine as client-builder

WORKDIR /usr/src/app/client

COPY client/package*.json ./

RUN npm install

COPY client .

# Build the client output
RUN npm run build

# Stage for building the server
FROM node:18-alpine as server-builder

WORKDIR /usr/src/app/server

COPY server/package*.json ./

RUN npm install

COPY server .

# Final stage
FROM node:18-alpine

WORKDIR /usr/src/app

COPY --from=client-builder /usr/src/app/client /usr/src/app/client
COPY --from=server-builder /usr/src/app/server /usr/src/app/server

EXPOSE 3000  
EXPOSE 3001  

CMD ["npm", "start"]  # Assuming client uses npm start