FROM debian:trixie-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends sbcl cl-ppcre cl-alexandria cl-split-sequence \
 && rm -rf /var/lib/apt/lists/*
# Bake the libraries into a core so every run starts with them loaded (no ASDF at runtime).
RUN sbcl --non-interactive \
      --eval '(require :asdf)' \
      --eval '(asdf:load-systems :cl-ppcre :alexandria :split-sequence)' \
      --eval '(sb-ext:save-lisp-and-die "/opt/aoc.core")'
WORKDIR /aoc
