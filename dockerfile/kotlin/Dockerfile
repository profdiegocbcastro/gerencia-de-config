FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y kotlin && rm -rf /var/lib/apt/lists/*

COPY Main.kt .

RUN kotlinc Main.kt -include-runtime -d app.jar

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/app.jar .

EXPOSE 8089

CMD ["java", "-jar", "app.jar"]
