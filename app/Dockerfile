FROM gradle:8.1.1-jdk17 AS builder

WORKDIR /app
COPY . .
RUN gradle bootJar --no-daemon

FROM openjdk:17-slim AS runtime

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && \
    curl -L -o dd-java-agent.jar https://dtdg.co/latest-java-tracer && \
    apt-get remove -y curl && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-javaagent:/app/dd-java-agent.jar", "-Xmx512m", "-Xms512m", "-jar", "app.jar"]