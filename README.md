# 🎄 Advent of Code Runner ⭐

```
         ★
        /.\
       /..'\
       /'.'\
      /.''.'\
      /.'.'.\
     /'.''.'.\
     ^^^[_]^^^
```

> *"The elves have prepared your input. The reindeer are standing by. Your hot cocoa is getting cold. Time to code."*

Bun-powered sleigh for TypeScript/Python/Haskell puzzle solving. Smart defaults so you can focus on collecting stars instead of fighting tooling.

## 🔧 Setup

```bash
asdf plugin add bun && asdf install
bun install && bun link
cp .env.example .env  # add AOC_SESSION cookie (steal it from your browser like Santa steals cookies)
```

## 🚀 Usage

```bash
aoc --year=2025 --day=1 --part=1 --input=input.txt
aoc                    # rerun last command (elves remember everything)
aoc --part=2           # switch to part 2, keep other params
aoc --input=example.txt # test against the sample first, you know you should
aoc next               # unwrap the next puzzle 🎁
aoc today              # what's behind today's door? (Dec 1-25)
aoc correct            # ⭐ claim your star, commit+push
aoc progress           # how's your leaderboard looking?
aoc help               # summon the documentation elves
```

## 🎛️ Flags

```
--year=YYYY      Year (2015-2025, because time travel exists here)
--day=DD         Day (1-25, the magic numbers)
--part=P         Part (1 or 2, the eternal sequel)
--lang=LANG      ts (default), py, hs
--input=FILE     Input file (input.txt, example.txt, etc.)
--raw-input=STR  Raw input string instead of file
--expected=VAL   Expected answer for validation
--solution=NAME  Alt solution file (e.g., part2-linear for when brute force isn't enough)
```

## ⭐ Expected Values

Auto-loaded from files if present (gitignored, your answers are secret):
- `expected-part1.txt` / `expected-part2.txt` for input.txt
- `expected-example-part1.txt` for example.txt

Create with `aoc correct` after a triumphant run.

## ✨ Writing Solutions

Pick your weapon of choice:

**TypeScript** (`part1.ts`) - *for the speed demons*
```typescript
export function solve(input: string): number | string {
  const lines = input.trim().split('\n');
  return 0; // TODO: actual magic goes here
}
```

**Python** (`part1.py`) - *for the readable folks*
```python
def solve(input: str) -> int | str:
    lines = input.strip().split('\n')
    return 0  # TODO: clever algorithm pending
```

**Haskell** (`Part1.hs`) - *for the pure of heart*
```haskell
module Part1 (solve) where
solve :: String -> String
solve input = show $ length (lines input)  -- elegance awaits
```

## 📁 Project Structure

```
solutions/
  2025/
    day01/
      part1.ts           # your glorious solution
      part2.ts           # the twist
      input.txt          # auto-downloaded from the North Pole
      expected-part1.txt # proof of victory (via `aoc correct`)
```

## 🦌 Pro Tips

- **Read the problem twice.** Then read it again. That edge case you missed? It's in there.
- **The example works but real input doesn't?** Your input is probably bigger than you think. Much bigger.
- **Part 2 broke everything?** That's not a bug, that's a feature. Welcome to AoC.
- **Stuck?** Take a walk. The answer will come to you in the shower. It always does.

## 🏆 The Leaderboard Grind

```
  December 1st, 00:00 EST
  ________________________
  |  You  |  Sleep  | ⭐  |
  |-------|---------|-----|
  |  😴   |    ❌    |  0  |
  |  ☕   |    ❌    |  1  |
  |  🤯   |    ❌    |  2  |
  |  😵   |    ✅    | 50  |
  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
```

---

*Happy puzzling! May your algorithms be fast, your edge cases be few, and your off-by-one errors be... well, off by zero.* 🎅

```
    *  .  *
  . _\/ \/_ .
   \  \ /  /     Ho ho ho!
  . /_ \/ _\ .
   *  /\  *
      ||
     _||_
```
