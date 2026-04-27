# Dockerfile - APIs Hello World

## Pré-requisitos

- Docker
- Docker Compose

## Subir todos os serviços

```bash
cd dockerfile
docker compose up --build
```

## Serviços

- Go: [http://localhost:8081](http://localhost:8081)
- Java: [http://localhost:8082](http://localhost:8082)
- Node.js: [http://localhost:8083](http://localhost:8083)
- PHP: [http://localhost:8084](http://localhost:8084)
- Python: [http://localhost:8086](http://localhost:8086)
- C#: [http://localhost:8087](http://localhost:8087)
- Rust: [http://localhost:8088](http://localhost:8088)
- Kotlin: [http://localhost:8089](http://localhost:8089)
- Deno: [http://localhost:8090](http://localhost:8090)
- Lua: [http://localhost:8091](http://localhost:8091)

## PostgreSQL

O PostgreSQL está disponível em `localhost:8085`.

Teste via SQL:

```bash
docker exec -it dockerfile-postgresql-1 psql -U appuser -d appdb -c "SELECT * FROM messages;"
```
