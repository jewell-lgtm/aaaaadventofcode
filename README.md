# 🎄 Advent of Code Starter

Fast, minimal AoC solution runner built with Bun + TypeScript.

## Setup

1. **Install Bun** (managed via asdf):
   ```bash
   asdf plugin add bun
   asdf install
   ```

2. **Install CLI**:
   ```bash
   bun install
   bun link
   ```

3. **Add your session cookie** (for auto-downloading inputs):
   ```bash
   cp .env.example .env
   # Edit .env and add your session cookie from adventofcode.com
   ```

   To get your session cookie:
   - Log in to [adventofcode.com](https://adventofcode.com)
   - Open browser dev tools (F12)
   - Go to Application/Storage > Cookies
   - Copy the value of the `session` cookie

## Usage

```bash
aoc <year> <day> <part> <input_file> [--expected=<value>]
```

### Examples

```bash
# Run 2025 day 1 part 1 with input.txt
aoc 2025 01 1 input.txt

# Run with expected result validation
aoc 2025 01 1 input.txt --expected=301

# Use a different input file (e.g., example from puzzle)
aoc 2025 01 1 example.txt --expected=7
```

### What happens

1. **Auto-scaffold**: Creates `solutions/YEAR/dayDD/part1.ts` and `part2.ts` if they don't exist
2. **Auto-download**: Downloads `input.txt` from adventofcode.com if missing (requires session cookie)
3. **Run**: Executes your solution and shows the result with timing
4. **Validate**: Checks result against `--expected` value if provided

## Writing Solutions

Edit the generated `part1.ts` or `part2.ts` files:

```typescript
export function solve(input: string): number | string {
  const lines = input.trim().split('\n');

  // Your solution here

  return 0;
}
```

- Input is provided as a string
- Return a number or string
- That's it!

## Project Structure

```
solutions/
  2024/
    day01/
      part1.ts      # Your part 1 solution
      part2.ts      # Your part 2 solution
      input.txt     # Puzzle input (auto-downloaded)
      example.txt   # Optional example input (manual)
    day02/
      ...
  2025/
    day01/
      ...
```

## Tips

- Run with example input first: `aoc 2025 01 1 example.txt --expected=7`
- Once working, run with real input: `aoc 2025 01 1 input.txt`
- Solutions are just TypeScript - use any Bun/Node APIs you want
- Fast reload - no build step needed

## Why Bun?

- ⚡ Instant startup (no build step)
- 🎯 TypeScript support out of the box
- 🔥 Fast execution
- 🎄 Fun to use
- 📦 Single executable

Happy coding! 🎅
