# gnuoctave/octave is amd64-only; Debian's package covers arm64 too.
FROM debian:13.8-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends octave \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /aoc
