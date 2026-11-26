# LDC (LLVM-based D compiler), pinned by the Debian release.
FROM debian:trixie-slim
RUN apt-get update && apt-get install -y --no-install-recommends ldc gcc libc6-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /aoc
