# Advent of Code Runner

Bun + TypeScript/Python/Haskell AoC runner with smart defaults.

## Setup

```bash
asdf plugin add bun && asdf install
bun install && bun link
cp .env.example .env  # add AOC_SESSION cookie
```

## Usage

```bash
aoc --year=2025 --day=1 --part=1 --input=input.txt
aoc                    # rerun last command
aoc --part=2           # switch to part 2, keep other params
aoc --input=example.txt # switch input file
aoc next               # advance to next part/day
aoc today              # run today's puzzle (Dec 1-25)
aoc correct            # save last result as expected, commit+push
aoc progress           # show star progress
aoc help               # full help
```

## Flags

```
--year=YYYY      Year (2015-2025)
--day=DD         Day (1-25)
--part=P         Part (1 or 2)
--lang=LANG      ts (default), py, hs
--input=FILE     Input file (input.txt, example.txt, etc.)
--raw-input=STR  Raw input string instead of file
--expected=VAL   Expected answer for validation
--solution=NAME  Alt solution file (e.g., part2-linear)
```

## Expected Values

Auto-loaded from files if present (gitignored):
- `expected-part1.txt` / `expected-part2.txt` for input.txt
- `expected-example-part1.txt` for example.txt

Create with `aoc correct` after successful run.

## Writing Solutions

**TypeScript** (`part1.ts`):
```typescript
export function solve(input: string): number | string {
  const lines = input.trim().split('\n');
  return 0;
}
```

**Python** (`part1.py`):
```python
def solve(input: str) -> int | str:
    lines = input.strip().split('\n')
    return 0
```

**Haskell** (`Part1.hs`):
```haskell
module Part1 (solve) where
solve :: String -> String
solve input = show $ length (lines input)
```

## Project Structure

```
solutions/
  2025/
    day01/
      part1.ts           # solution
      part2.ts
      input.txt          # auto-downloaded
      expected-part1.txt # created by `aoc correct`
```
