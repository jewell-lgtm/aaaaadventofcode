// Report Repair, part 2: fix the first number, then reuse the Set-complement trick for the pair.
// TypeScript: a small generic helper keeps both loops readable.
function pairProduct(nums: number[], target: number): number | undefined {
  const seen = new Set<number>();
  for (const n of nums) {
    if (seen.has(target - n)) return n * (target - n);
    seen.add(n);
  }
}

export function solve(input: string): number {
  const nums = input.trim().split("\n").map(Number);
  for (const [i, a] of nums.entries()) {
    const rest = pairProduct(nums.slice(i + 1), 2020 - a);
    if (rest !== undefined) return a * rest;
  }
  throw new Error("no triple sums to 2020");
}
