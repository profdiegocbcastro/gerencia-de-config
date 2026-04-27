FROM rust:1.78-slim AS builder

WORKDIR /app

COPY Cargo.toml .

COPY src ./src

RUN cargo build --release

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/target/release/hello-rust .

EXPOSE 8088

CMD ["./hello-rust"]
