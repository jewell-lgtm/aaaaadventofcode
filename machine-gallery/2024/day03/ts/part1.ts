// Mull It Over, part 1: matchAll a global regex with capture groups, sum the products.
// TypeScript: matchAll + destructuring pulls both operands out of each match.
export function solve(input: string): number {
  let total = 0;
  for (const [, a, b] of input.matchAll(/mul\((\d{1,3}),(\d{1,3})\)/g)) total += +a * +b;
  return total;
}
