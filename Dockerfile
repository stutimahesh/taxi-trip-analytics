# ---- Build stage: compile TripAnalytics and collect Spark jars ----
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY TripAnalytics.java .
RUN mvn -B -q compile dependency:copy-dependencies -DincludeScope=runtime -DoutputDirectory=target/lib

# ---- Runtime stage: JRE 17 + Python for charts ----
FROM eclipse-temurin:17-jre-jammy
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip fonts-liberation \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY --from=build /build/target/classes ./classes
COPY --from=build /build/target/lib ./lib
COPY .mvn/jvm.config ./jvm.config
COPY charts_real.py docker-entrypoint.sh ./
COPY data ./data
RUN mkdir -p out && sed -i 's/\r$//' docker-entrypoint.sh && chmod +x docker-entrypoint.sh

# Heap for the Spark driver; override with -e JAVA_OPTS=-Xmx6g
ENV JAVA_OPTS="-Xmx4g"
VOLUME ["/app/out"]
ENTRYPOINT ["./docker-entrypoint.sh"]
