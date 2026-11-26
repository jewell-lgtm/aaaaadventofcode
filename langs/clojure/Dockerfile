FROM eclipse-temurin:25.0.5.1_2-jdk-noble
ARG CLOJURE_CLI=1.12.7.1681
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/* \
 && curl -fsSL https://download.clojure.org/install/linux-install-$CLOJURE_CLI.sh | bash
# Pre-fetch deps (clojure + data.json) into ~/.m2.
COPY template/deps.edn /tmp/warm/deps.edn
RUN cd /tmp/warm && clojure -P && rm -rf /tmp/warm
WORKDIR /aoc
