FROM ocaml/opam:debian-12-ocaml-5.3
RUN opam install -y dune.3.20.2 && opam clean -a
ENV PATH=/home/opam/.opam/5.3/bin:$PATH \
    OPAM_SWITCH_PREFIX=/home/opam/.opam/5.3 \
    DUNE_CACHE=enabled \
    DUNE_CACHE_STORAGE_MODE=copy
RUN mkdir -p /home/opam/.cache/dune
WORKDIR /aoc
