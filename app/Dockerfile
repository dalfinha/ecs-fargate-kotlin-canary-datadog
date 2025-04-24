FROM openjdk:17-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y wget unzip

RUN wget https://github.com/JetBrains/kotlin/releases/download/v1.9.21/kotlin-compiler-1.9.21.zip && \
    unzip kotlin-compiler-1.9.21.zip && \
    mv kotlinc /opt/kotlinc

ENV PATH="/opt/kotlinc/bin:$PATH"

COPY src/app/Main.kt .

RUN kotlinc Main.kt -include-runtime -d app.jar

FROM openjdk:17-slim

WORKDIR /app

COPY --from=builder /app/app.jar .

CMD ["java", "-jar", "app.jar"]
