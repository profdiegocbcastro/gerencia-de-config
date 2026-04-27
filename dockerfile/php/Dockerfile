FROM php:8.3-cli-alpine

WORKDIR /app

COPY index.php .

EXPOSE 8084

CMD ["php", "-S", "0.0.0.0:8084", "-t", "/app"]
