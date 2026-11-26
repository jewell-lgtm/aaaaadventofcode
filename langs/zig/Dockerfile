# Zig's std API changes between releases, so the version is pinned exactly.
FROM debian:trixie-slim
ARG ZIG_VERSION=0.15.2
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl xz-utils \
    && rm -rf /var/lib/apt/lists/*
RUN arch="$(uname -m)" && case "$arch" in \
      aarch64) sha=958ed7d1e00d0ea76590d27666efbf7a932281b3d7ba0c6b01b0ff26498f667f ;; \
      x86_64)  sha=02aa270f183da276e5b5920b1dac44a63f1a49e55050ebde3aecc9eb82f93239 ;; \
    esac \
    && curl -fsSL -o /tmp/zig.tar.xz "https://ziglang.org/download/$ZIG_VERSION/zig-$arch-linux-$ZIG_VERSION.tar.xz" \
    && echo "$sha  /tmp/zig.tar.xz" | sha256sum -c - \
    && tar -xJf /tmp/zig.tar.xz -C /opt && rm /tmp/zig.tar.xz \
    && ln -s "/opt/zig-$arch-linux-$ZIG_VERSION/zig" /usr/local/bin/zig
WORKDIR /aoc
# Warm the global cache (compiler_rt, std) so the first day builds quickly.
RUN cd /tmp && printf 'pub fn main() void {}\n' > warm.zig \
    && zig build-exe -O ReleaseSafe warm.zig -femit-bin=/tmp/warm && rm -rf /tmp/warm* /tmp/.zig-cache
