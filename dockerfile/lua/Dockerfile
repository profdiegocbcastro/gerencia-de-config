FROM alpine:3.20

RUN apk add --no-cache lua5.4 lua5.4-socket

WORKDIR /app

COPY server.lua .

EXPOSE 8091

CMD ["lua5.4", "server.lua"]
