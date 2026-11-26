# Official racket/racket images are amd64-only; Debian trixie ships Racket 8.x for both arches.
FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends racket && rm -rf /var/lib/apt/lists/*
WORKDIR /aoc
