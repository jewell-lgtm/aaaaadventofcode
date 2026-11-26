// Supply Stacks, part 1: arrays as stacks; the CrateMover 9000 moves one crate at a time.
// TypeScript: splice + reverse models "one at a time" in a single call.
import { parse, tops } from "./stacks";

export function solve(input: string): string {
  const { stacks, moves } = parse(input);
  for (const { count, from, to } of moves) {
    stacks[to].push(...stacks[from].splice(-count).reverse());
  }
  return tops(stacks);
}
