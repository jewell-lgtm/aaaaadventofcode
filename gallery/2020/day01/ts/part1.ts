// Report Repair, part 1: one pass with a Set of seen numbers; look up each complement.
// TypeScript: Set lookups and early return from a for..of keep it O(n).
export function solve(input: string): number {
  const seen = new Set<number>();
  for (const n of input.trim().split("\n").map(Number)) {
    if (seen.has(2020 - n)) return n * (2020 - n);
    seen.add(n);
  }
  throw new Error("no pair sums to 2020");
}
