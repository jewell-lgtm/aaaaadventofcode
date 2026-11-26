# Official Temurin image via the ECR mirror of Docker Hub's library (same image, no pull rate limit).
FROM public.ecr.aws/docker/library/eclipse-temurin:25.0.5.1_2-jdk-noble
ARG KOTLIN=2.4.21
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates unzip && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL -o /tmp/k.zip https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN/kotlin-compiler-$KOTLIN.zip \
 && unzip -q /tmp/k.zip -d /opt && rm /tmp/k.zip
ENV PATH=/opt/kotlinc/bin:$PATH
# Train a JDK AOT cache on a template compile: kotlinc starts ~25% faster.
COPY template /tmp/warm
RUN cd /tmp/warm && JAVA_OPTS="-XX:AOTCacheOutput=/opt/kotlinc.aot" kotlinc -nowarn -d /tmp/warm-out *.kt && rm -rf /tmp/warm /tmp/warm-out
ENV JAVA_OPTS="-XX:AOTCache=/opt/kotlinc.aot"
WORKDIR /aoc
