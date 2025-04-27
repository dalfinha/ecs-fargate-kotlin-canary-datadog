FROM openjdk:17-slim AS builder

WORKDIR /app

COPY src/ /app/src/

RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/JetBrains/kotlin/releases/download/v1.9.21/kotlin-compiler-1.9.21.zip && \
    unzip kotlin-compiler-1.9.21.zip && \
    mv kotlinc /opt/kotlinc

ENV PATH="/opt/kotlinc/bin:$PATH"

RUN kotlinc src/app/Main.kt src/app/healthCheck.kt -include-runtime -d /app/app.jar

FROM openjdk:17-slim

WORKDIR /app

COPY --from=builder /app/app.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
