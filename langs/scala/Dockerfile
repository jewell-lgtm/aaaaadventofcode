FROM eclipse-temurin:25.0.5.1_2-jdk-noble
ARG SCALA_CLI=1.18.0
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL "https://github.com/VirtusLab/scala-cli/releases/download/v$SCALA_CLI/scala-cli-$(uname -m)-pc-linux.gz" | gzip -d > /usr/local/bin/scala-cli \
 && chmod +x /usr/local/bin/scala-cli
# Pre-fetch the compiler, ujson and Bloop by compiling the template once.
COPY template /tmp/warm
RUN cd /tmp/warm && scala-cli --power config suppress-warning.outdated-dependencies-files true \
 && scala-cli compile . && scala-cli --power bloop exit && rm -rf /tmp/warm
WORKDIR /aoc
