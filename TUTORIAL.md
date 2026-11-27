# Tutorial: your first day with `aoc`

About 15 minutes. You'll solve 2015 day 1 end to end, first in the terminal and then in nvim, and pick up the less obvious features along the way. Prerequisites: `bun link` done, `AOC_SESSION` set in `.env`, Docker (OrbStack) running.

## 1. Start a day

```bash
aoc 2015 1
```

What happens:

1. **Target.** `2015 1` is explicit. During December, a bare `aoc` means today.
2. **Fetch.** The puzzle goes to `solutions/2015/day01/puzzle.md` and your input to `input.txt`. Both are cached forever and gitignored.
3. **Examples.** The examples in the puzzle text become `examples.toml`. Day 1 has nine inline ones, like `(())` → `0`.
4. **Language.** JEV reads the puzzle and picks one, e.g. `🎲 Lua  JEV pick (confidence 0.88…)`.
5. **Scaffold.** The language's template is copied to `solutions/2015/day01/<lang>/`.
6. **Test.** The examples run against the empty template, so they mostly fail with `got 0`. That's expected.

Don't fancy Lua today?

```bash
aoc lang repick     # ask JEV for something else
aoc lang ts         # or just pick one
LANG=kotlin aoc     # one-off override (also --lang kotlin / AOC_LANG)
```

## 2. Solve part 1

```bash
aoc info            # prints the language and the file to edit
```

Every template has the same shape: a `main` you don't touch, an `aoc` helper module, and `part1`/`part2` files, each with a `solve(input)` stub. Fill in part 1 (TypeScript here):

```ts
export function solve(input: string) {
  return [...input.trim()].reduce((floor, c) => floor + (c === "(" ? 1 : -1), 0);
}
```

```bash
aoc test            # ✓ example 1  want 0  got 0  41ms … all 9 example(s) pass
aoc run             # ⭐ 280  38ms  (unsubmitted: aoc submit)
```

Print debug output freely. Only the **last line of stdout** counts as the answer, and everything else shows up as a dimmed `│` log under the result.

`aoc watch` reruns the tests every time you save.

## 3. Submit

```bash
aoc submit
```

It reruns the examples (and refuses while any fail), runs the real input, shows the answer and asks `Submit? [y/N]`. Then:

- **⭐ correct**: the answer goes in `day.json`, the page is refetched so `puzzle.md` gains part 2 (and `examples.toml` gains part 2 answers), and the day is committed (`2015: day01 part 1 (ts)`).
- **too high / too low**: recorded, so a later answer outside the known range is refused before it's ever sent. The same goes for repeating a wrong answer, a template `0`, and AoC's cooldown.

Already solved this on the site years ago? Submitting replies "already complete" and imports your accepted answer, so nothing is lost.

## 4. Part 2

```bash
aoc puzzle          # read part 2 (aoc puzzle -f refetches)
aoc test            # the part now defaults to 2
```

Your `part2` file already holds a copy of part 1 (with `Part1` → `Part2` renamed for Haskell-style modules and Java-style classes), so you start from working code rather than an empty stub. That happens whenever the day is on part 2 and `part2` is still untouched.

If the part 2 example wasn't extracted (or its value is wrong), fix it in `examples.toml`, or add one:

```bash
pbpaste | aoc ex add p2 5
aoc ex              # list them
```

Solve `part2`, then `aoc test`, `aoc submit`. ⭐⭐.

## 5. Examples with different constants

Some puzzles use smaller numbers in the example than in the real thing ("the space is 101 wide, but in this example it's 11"). `aoc` warns when it spots this. Tell the example its constants:

```toml
[[example]]
input = "examples/1.txt"
part1 = "12"
args = { width = 11, height = 7 }
```

…and read them with a real-input default:

```ts
import { arg, example } from "./aoc";
const width = arg("width", 101);
```

Every language's helper has the same `arg(name, default)` and `example`.

## 6. Moving around

```bash
aoc next            # newest released day you haven't started
aoc 2017            # earliest incomplete 2017 day
aoc 2026 next       # newest unstarted 2026 day
aoc status          # star grid (★ both, ☆ one, red · started)
aoc verify          # regression check: rerun every solved part against its accepted answer
```

Inside a day dir (`cd solutions/2017/day03/ts`), every command targets that day.

## 7. Same thing in nvim

You don't need to memorise anything: `<leader>a` opens a picker of every action (type `sub` ⏎ to submit), and `:Aoc <Tab>` completes the same set.

`:Aoc` opens the day in three tabs, in a fixed order (Tab / Shift+Tab or `1gt` `2gt` `3gt` to switch):

| tab | | |
|---|---|---|
| 1 read | puzzle.md │ example over input.txt | where a fresh part opens |
| 2 code | your solution, nothing else | where you work |
| 3 exec | terminal running `aoc watch` | examples rerun on every save |

`:Aoc test` shows a float, and failures go to the quickfix list (`:cnext` jumps to the failing `[[example]]`). `:Aoc run` copies the answer to the clipboard. `:Aoc submit` does a dry run, asks for confirmation, and on ⭐ refreshes the read tab with part 2.

See `:help aoc` for the rest.

## 8. Choosing a language: the gallery

Not sure whether Elixir or OCaml would be nicer for a parsing-heavy day? The gallery has 10 classic puzzles solved in all 32 languages:

```
:Aoc gallery             snacks picker: type "chiton" or "rust" to filter, <C-v> vsplit to compare two
:Aoc gallery ocaml
```

| puzzle | shows off |
|---|---|
| 2024/03 Mull It Over | regex |
| 2020/01 Report Repair | sets |
| 2022/05 Supply Stacks | messy parsing |
| 2022/12 Hill Climbing | BFS |
| 2021/15 Chiton | Dijkstra |
| 2023/07 Camel Cards | custom sorting |
| 2022/11 Monkey in the Middle | records + modular maths |
| 2023/12 Hot Springs | memoised DP |
| 2022/21 Monkey Math | expression trees |
| 2021/14 Extended Polymerization | counting |

Each solution starts with a short header comment on the approach and what's characteristic about writing it in that language.

## Cheat sheet

```
aoc                    start/resume today + test        aoc submit [-y] [-f]   submit
aoc test [p1|p2]       examples                         aoc puzzle [-f]        read
aoc run  [p1|p2]       real input                       aoc ex [add p1 X]      examples
aoc next | 2026 | 2017 3                                aoc lang [x|repick]    language
aoc status | verify | watch | langs | where | help      --json (for scripts)
```
