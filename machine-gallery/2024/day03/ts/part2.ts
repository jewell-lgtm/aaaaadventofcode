// Mull It Over, part 2: one regex alternation for mul/do/don't, scanned in order with an on/off flag.
// TypeScript: matchAll yields matches in source order, so a single loop handles the state.
export function solve(input: string): number {
  let enabled = true;
  let total = 0;
  for (const [op, a, b] of input.matchAll(/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/g)) {
    if (op === "do()") enabled = true;
    else if (op === "don't()") enabled = false;
    else if (enabled) total += +a * +b;
  }
  return total;
}
