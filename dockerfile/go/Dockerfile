FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /app/server .

EXPOSE 8081

CMD ["./server"]
