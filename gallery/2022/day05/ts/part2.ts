// Supply Stacks, part 2: the CrateMover 9001 lifts the whole slice, keeping order.
// TypeScript: same as part 1 minus the reverse().
import { parse, tops } from "./stacks";

export function solve(input: string): string {
  const { stacks, moves } = parse(input);
  for (const { count, from, to } of moves) {
    stacks[to].push(...stacks[from].splice(-count));
  }
  return tops(stacks);
}
