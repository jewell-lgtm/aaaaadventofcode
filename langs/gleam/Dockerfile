# Gleam moves fast: compiler and stdlib are pinned together (template/manifest.toml).
FROM ghcr.io/gleam-lang/gleam:v1.19.2-erlang-alpine
# Warm the hex cache with the template's locked deps so day builds never hit the network.
COPY template /tmp/warm
RUN cd /tmp/warm && gleam build && rm -rf /tmp/warm
WORKDIR /aoc
