# Language template spec

Each language is a folder `langs/<id>/`. The harness (`src/`) is language-agnostic. Look at `langs/ts`, `langs/python`, `langs/haskell` as reference implementations.

## Files

- `lang.json`
  - `name`: display name.
  - `aliases`: optional, lowercase.
  - `criteria`: one sentence, used by an LLM to pick languages per puzzle. Say what this language is *genuinely good at* for AoC-style problems, concretely (e.g. "pattern matching on parsed ASTs", "fast mutable 2D arrays for brute-force simulation"), not marketing.
  - `specialist`: true only for r/octave/sql/jq.
  - `solution`: `{ "1": "<path>", "2": "<path>" }`. The files the user edits, relative to the lang dir.
  - `build`: optional shell, run before every run. **Must be incremental**: near-instant when nothing changed. Prefer the toolchain's own incremental build, or a `[ out -nt src ] ||` guard.
  - `run`: shell. Reads the puzzle input from stdin.
  - `caches`: optional `{ "<container path>": "<volume name>" }` for package or build caches (e.g. `/root/.gradle`). The volume becomes `aoc-cache-<name>`, shared across days.
  - `ignore`: build outputs to gitignore inside the day dir (e.g. `["target/", ".build/"]`).
- `Dockerfile`: `FROM` an official or well-maintained image, **version pinned** (exact or minor tag, arm64 + amd64). Docker Hub, ghcr.io (e.g. gleam) and mcr.microsoft.com (.NET) are all fine. If the official image is amd64-only (racket, scala-cli), use a pinned distro base (`debian:trixie-slim`) plus distro packages or a pinned binary. Install everything the template needs at image build time (dependencies, warmed caches) so the first run doesn't download. `WORKDIR /aoc`. No ENTRYPOINT. The harness runs `sleep infinity` and then `docker exec`.
- `template/`: copied to `solutions/YYYY/dayDD/<id>/` once per day. `{{year}} {{day}} {{dd}}` get substituted in text files.

## Runtime contract

Inside the container, cwd is the day's `<id>/` dir (the repo is mounted at `/aoc`). Env vars:

- `AOC_PART` = `1` | `2`
- `AOC_EXAMPLE` = `1` when running an example, `0` for real input
- `AOC_ARGS` = JSON object (flat; numbers/strings/bools) from examples.toml `args`, `{}` for real input

The program must print the answer as the **last non-empty line of stdout**. Anything printed before it (or to stderr) is shown to the user as a debug log. A non-zero exit code is a failure.

## Template shape (same for every language)

1. **Entry/main file**, marked "Harness entry: don't edit". It reads all of stdin, dispatches on `AOC_PART` to part 1 or part 2, and prints the result.
2. **Helper module** `aoc` (idiomatic name/casing) exposing:
   - `example`: bool from `AOC_EXAMPLE`
   - `arg(name, default)`: value from `AOC_ARGS`, else default. Use a JSON lib if one ships with the toolchain; otherwise a tiny flat-object parser like `langs/haskell/template/Aoc.hs`.
3. **Two solution files**, one per part (or one file with two clearly separated functions if the language really wants that; say so in `solution`). Each holds a `solve(input) -> answer` stub that splits lines and returns `0`. Keep the stub tiny, idiomatic and ready to type into. Import the helper but don't over-scaffold.

The template must compile and run as-is, printing `0`.

## Gallery solutions

`gallery/YYYY/dayDD/<id>/` is a scaffolded template with real solutions in it. Purpose: a human browses the same puzzle across languages to decide which language they like for a kind of problem. So:

- **Idiomatic, not clever.** Write it the way a strong, tasteful practitioner of that language would. Use the language's signature features where they fit naturally (pattern matching, pipelines, comprehensions, CTEs, vectorisation…).
- Readable: short header comment (2-4 lines) naming the approach and what's characteristic about doing it in this language. Small helper functions over one giant function. No golfing.
- Standard library plus whatever your Dockerfile installs. Nothing fetched at runtime.
- Parse input robustly (trailing newline, CRLF not needed).
- Reasonable performance: each part under ~10 s on real input (most well under 1 s).
- Real input isn't available yet. Correctness is checked against examples now and real inputs later, so make it correct in general, not example-shaped.

## Commands

```
aoc langs                                         # bank, check yours shows up
aoc gallery test 2022 12 p1 --lang <id>           # scaffolds gallery/2022/day12/<id>/ if missing, runs part 1 examples
aoc gallery test 2022 12 p2 --lang <id>
aoc gallery ex 2022 12                            # list examples
```

The first use of a language builds its Docker image (can take minutes). Later runs are warm (`docker exec` into `aoc-<id>`). If you change the Dockerfile, the container is rebuilt automatically.

## Gallery puzzles

| dir | puzzle | archetype |
|---|---|---|
| 2024/day03 | Mull It Over | regex scanning |
| 2020/day01 | Report Repair | sets / combinations |
| 2022/day05 | Supply Stacks | messy parsing + stack simulation |
| 2022/day12 | Hill Climbing Algorithm | grid BFS |
| 2021/day15 | Chiton | Dijkstra / priority queue (part 2: 5×5 tiled map) |
| 2023/day07 | Camel Cards | custom sort / comparator |
| 2022/day11 | Monkey in the Middle | parsing records + modular arithmetic (big numbers) |
| 2023/day12 | Hot Springs | memoised DP |
| 2022/day21 | Monkey Math | expression tree, solve for unknown |
| 2021/day14 | Extended Polymerization | pair frequency counting |

The puzzle text is in `gallery/YYYY/dayDD/puzzle.md` (part 1 only, since we're logged out; you know the part 2 twists). Examples and expected answers are in `examples.toml`.

## Rules for parallel work

Several agents work in this repo at once, each on its own languages. Only create or edit `langs/<your ids>/` and `gallery/*/day*/<your ids>/`. Never touch `src/`, other languages, `day.json`, `examples.toml` or git. If the harness gets in your way, stop and report what you'd change.
