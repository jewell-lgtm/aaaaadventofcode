FROM rust:1.99-slim-bookworm
RUN rustup component add rustfmt clippy
WORKDIR /aoc
# Pre-fetch the optional crates listed in the template's Cargo.toml so builds run --offline.
RUN cargo new -q /tmp/warm && cd /tmp/warm && cargo add -q regex@1 itertools@0.14 && cargo fetch -q && rm -rf /tmp/warm
