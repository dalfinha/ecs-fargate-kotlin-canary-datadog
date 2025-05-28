FROM gradle:8.1.1-jdk17 AS builder

WORKDIR /app

COPY . .

RUN gradle bootJar --no-daemon

FROM openjdk:17-slim

WORKDIR /app

COPY --from=builder /app/build/libs/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
