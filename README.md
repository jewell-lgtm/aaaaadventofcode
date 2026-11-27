# 🎄 aaaaadventofcode

```
         ★
        /.\
       /..'\      a polyglot Advent of Code harness
       /'.'\      32 languages · all in Docker · zero flags
      /.''.'\
     ^^^[_]^^^
```

`aoc` works out which puzzle you mean, lets JEV pick a language that suits it, scaffolds a project, pulls the examples out of the puzzle text as tests, runs everything in Docker, and keeps track of every answer you've submitted. There's an nvim plugin, so you never leave the editor. **New here? Read [TUTORIAL.md](TUTORIAL.md).**

## Setup

```bash
bun install && bun link          # bun is the only thing on the host; every toolchain lives in Docker
cp .env.example .env             # AOC_SESSION=<session cookie from adventofcode.com>
```

`.env` (all optional except the session):

| var | |
|---|---|
| `AOC_SESSION` | adventofcode.com `session` cookie |
| `AOC_USER_AGENT` | sent to AoC; their automation guidelines ask for contact info |
| `OPENROUTER_API_KEY` | JEV language picks (or keychain `openrouter-api-key`); without it, a random unused language |
| `AOC_PUSH=1` | push after the auto-commit on a correct answer |
| `AOC_LANG` | default language override |

## Daily loop

```bash
aoc            # today: fetch puzzle+input, JEV picks a language, scaffold, run examples
aoc test       # examples for the current part        (aoc test p2)
aoc run        # real input
aoc submit     # run + submit + record verdict; on ⭐, fetch part 2 and commit
```

Inside nvim: `<leader>a` opens a picker of every action; `:Aoc <sub>` does the same (`:help aoc`).

## Targets

| | |
|---|---|
| `aoc` | the day of the current dir › today (during the event) › the last day you touched |
| `aoc 2026` | today if 2026 is running, else the earliest incomplete 2026 day |
| `aoc next` | the newest released day you haven't started (any year) |
| `aoc 2026 next` | same, within 2026 |
| `aoc 2017 3` / `2017/3` | explicit |

The part defaults to the first unsolved one. Since 2025, AoC has 12 days. Older years have 25.

## Languages

`aoc langs` lists the bank: ts, python, haskell, java, kotlin, scala, clojure, csharp, fsharp, go, rust, swift, c, cpp, zig, d, ocaml, elixir, erlang, gleam, racket, common-lisp, ruby, perl, lua, julia, php, dart, crystal, nim, plus the specialists r and octave.

- **JEV** (OpenRouter `systemone`) reads the puzzle and picks from the bank. Languages used on the previous 3 days are left out, it prefers languages you haven't used this year, and specialists only win on a strong fit.
- Override with `--lang rust`, `AOC_LANG=rust`, or `LANG=kotlin aoc` (`LANG` only counts when it names a bank language, since it's normally your locale).
- `aoc lang rust` switches the day for good, and `aoc lang repick` asks JEV for something else. One day can hold several languages (`day03/rust/`, `day03/ts/`), and `verify` checks them all.
- Every language is a folder in `langs/<id>/` (`lang.json`, pinned `Dockerfile`, `template/`). See [langs/SPEC.md](langs/SPEC.md) to add one.
- Each language gets a warm container (`aoc-<id>`), so runs are a `docker exec` (tens of ms). The first use builds the image. `aoc langs prune` removes the containers.

## Examples = tests

`examples.toml` is filled from the puzzle text, then again after part 1 to add part 2. Your edits are never overwritten.

```toml
[[example]]
input = "examples/1.txt"    # or text = """..."""
part1 = "142"
part2 = "281"
args = { size = 7 }         # example-only constants → arg("size", 71) in your solution
auto = true                 # extracted by aoc; flip to false once checked
```

`pbpaste | aoc ex add p2 281` adds one by hand, and `aoc ex` lists them. Every template ships an `aoc` helper module with `arg(name, default)` and `example`.

## Answers & regression

`day.json` keeps the accepted answers and every submission with its verdict. `aoc submit` won't resend a wrong answer, an answer outside a known too-high/too-low bound, a `0` from the template, or anything during AoC's cooldown, and it won't submit at all while examples fail (`-f` overrides that). Submitting a puzzle you already solved on the site imports the accepted answers.

`aoc verify [year]` reruns every solved part in every language dir against the accepted answers.

## Gallery

`machine-gallery/` has 10 classic puzzles solved in every language, for browsing when you're choosing a language for a kind of problem: regex, sets, messy parsing, BFS, Dijkstra, custom sort, modular arithmetic, DP, expression trees and counting.

```bash
aoc gallery test 2022 12 --lang ocaml
aoc gallery verify            # needs inputs: aoc gallery start <year> <day> fetches them
```

In nvim: `:Aoc gallery [filter]` (snacks picker; `<C-v>` vsplit to compare).

## Commands

```
aoc [target]  info  test  run  submit  verify  watch  puzzle [-f]  lang [x|repick]  langs [prune]
ex [add]  status [year]  where  help        flags: --lang X  p1|p2  --json  -y  -f
```

## Layout

```
src/                      the CLI (bun)
langs/<id>/               lang.json, Dockerfile, template/
solutions/YYYY/dayDD/     day.json, examples.toml, <lang>/  (input.txt, puzzle.*, examples/ are gitignored)
machine-gallery/YYYY/dayDD/<id>/  the same layout
nvim/                     the plugin
```
